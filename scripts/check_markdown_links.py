#!/usr/bin/env python3
"""Check repository-relative inline Markdown links and reference definitions.

External URLs are classified but not fetched. This intentionally avoids network
availability being mistaken for repository integrity.
"""
from __future__ import annotations

import re
import subprocess
import sys
from pathlib import Path
from urllib.parse import unquote, urlsplit

ROOT = Path(__file__).resolve().parents[1]
FENCE = re.compile(r"^\s{0,3}(`{3,}|~{3,})")
INLINE = re.compile(r"!?(?:\[[^\]]*\])\(\s*(<[^>]*>|[^\s)]+)(?:\s+[\"'][^\"']*[\"'])?\s*\)")
DEFINITION = re.compile(r"^\s{0,3}\[[^\]]+\]:\s*(<[^>]*>|\S+)", re.MULTILINE)
HEADING = re.compile(r"^#{1,6}\s+(.+?)\s*#*\s*$", re.MULTILINE)
HTML_ID = re.compile(r"\bid=[\"']([^\"']+)[\"']")


def tracked_files() -> list[Path]:
    result = subprocess.run(["git", "ls-files", "-z"],
                            cwd=ROOT, check=True, capture_output=True)
    return sorted(ROOT / item.decode("utf-8") for item in result.stdout.split(b"\0") if item)


def strip_fences(text: str) -> str:
    output, fence_char, fence_len = [], None, 0
    for line in text.splitlines():
        match = FENCE.match(line)
        if match:
            marker = match.group(1)
            if fence_char is None:
                fence_char, fence_len = marker[0], len(marker)
            elif marker[0] == fence_char and len(marker) >= fence_len:
                fence_char, fence_len = None, 0
            continue
        if fence_char is None:
            output.append(line)
    return "\n".join(output)


def anchors(text: str) -> set[str]:
    result = {x for x in HTML_ID.findall(text)}
    for heading in HEADING.findall(text):
        slug = re.sub(r"[^\w\- ]", "", heading.lower())
        result.add(re.sub(r"\s+", "-", slug.strip()))
    return result


def main() -> int:
    all_files = tracked_files()
    known = {p.resolve() for p in all_files}
    files = [p for p in all_files if p.suffix.lower() == ".md"]
    errors, checked, external = [], 0, 0
    content_cache = {p: p.read_text(encoding="utf-8") for p in files}
    anchor_cache = {p: anchors(strip_fences(t)) for p, t in content_cache.items()}

    for source, original in content_cache.items():
        text = strip_fences(original)
        destinations = [m.group(1).strip("<>") for m in INLINE.finditer(text)]
        destinations += [m.group(1).strip("<>") for m in DEFINITION.finditer(text)]
        for destination in destinations:
            if not destination or destination.startswith("#"):
                if destination.startswith("#") and destination[1:] not in anchor_cache[source]:
                    errors.append(f"{source.relative_to(ROOT)}: missing anchor #{destination[1:]}")
                checked += 1
                continue
            parts = urlsplit(destination)
            if parts.scheme or parts.netloc:
                external += 1
                continue
            target_text = unquote(parts.path)
            if not target_text:
                target = source
            else:
                target = (source.parent / target_text).resolve()
            if target.is_dir():
                candidates = [target / "README.md", target / "index.md"]
                target = next((p for p in candidates if p in known), target)
            if target not in known:
                errors.append(f"{source.relative_to(ROOT)}: unresolved local target {destination}")
                checked += 1
                continue
            if parts.fragment and target in anchor_cache and parts.fragment not in anchor_cache[target]:
                errors.append(f"{source.relative_to(ROOT)}: missing anchor {destination}")
            checked += 1

    if errors:
        print("\n".join(errors))
        print(f"FAILED: {len(errors)} issue(s); checked {checked} local links; skipped {external} external links.")
        return 1
    print(f"Markdown link check passed: {checked} local links checked; {external} external links not fetched.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
