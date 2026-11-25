#!/usr/bin/env python3
"""Black-box regression tests for the AI context generator and Markdown link checker."""
import json
import shutil
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GENERATOR = ROOT / "scripts" / "ai_context_index.py"
LINK_CHECKER = ROOT / "scripts" / "check_markdown_links.py"
LINE_LIMIT_CHECKER = ROOT / "scripts" / "check_markdown_line_limit.py"

def run(command, cwd, expected=0):
    result = subprocess.run(command, cwd=cwd, text=True, capture_output=True)
    if result.returncode != expected:
        raise AssertionError(
            f"exit={result.returncode}, expected={expected}: {command}\n"
            f"stdout:\n{result.stdout}\nstderr:\n{result.stderr}"
        )
    return result

class AiContextIntegrityTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="sgsctr-ai-context-")
        self.root = Path(self.temp.name)
        for directory in ("scripts", ".ai", "assets", "futher_md"):
            (self.root / directory).mkdir()
        shutil.copy2(GENERATOR, self.root / "scripts" / GENERATOR.name)
        shutil.copy2(LINK_CHECKER, self.root / "scripts" / LINK_CHECKER.name)
        shutil.copy2(LINE_LIMIT_CHECKER, self.root / "scripts" / LINE_LIMIT_CHECKER.name)
        (self.root / "AGENT.md").write_text("# Bootstrap\n\n## Overview\n", encoding="utf-8")
        (self.root / ".ai" / "guide.md").write_text(
            "# Guide\n\n[Root](../AGENT.md#bootstrap)\n"
            "[Asset](../assets/schema.json)\n[Duplicate](#duplicate-1)\n\n"
            "## Duplicate\n\n## Duplicate\n\n"
            "```md\n[Not a real link](missing-in-fence.md)\n```\n",
            encoding="utf-8",
        )
        (self.root / "assets" / "schema.json").write_text('{"ok": true}\n', encoding="utf-8")
        (self.root / "empty.md").write_bytes(b"")
        run(["git", "init", "-q"], self.root)
        run(["git", "config", "user.email", "ai-context-test@example.invalid"], self.root)
        run(["git", "config", "user.name", "AI Context Test"], self.root)
        run(["git", "add", "."], self.root)
        run(["git", "commit", "-qm", "fixture"], self.root)

    def tearDown(self):
        self.temp.cleanup()

    def command(self, script, *args, expected=0):
        return run([sys.executable, f"scripts/{script}", *args], self.root, expected)

    def test_generator_is_deterministic_and_manifest_matches_git(self):
        self.command("ai_context_index.py")
        manifest_path = self.root / ".ai" / "CONTEXT_MANIFEST.json"
        index_path = self.root / ".ai" / "index.md"
        manifest_bytes, index_bytes = manifest_path.read_bytes(), index_path.read_bytes()
        manifest = json.loads(manifest_bytes)
        self.assertEqual(manifest["tracked_markdown_count"], 3)
        self.assertEqual(manifest["empty_markdown_count"], 1)
        paths = [entry["path"] for entry in manifest["entries"]]
        self.assertEqual(paths, sorted(paths))
        self.assertNotIn(".ai/index.md", paths)
        for entry in manifest["entries"]:
            expected_sha = run(["git", "hash-object", entry["path"]], self.root).stdout.strip()
            self.assertEqual(entry["git_blob_sha"], expected_sha)
            self.assertEqual(entry["size_bytes"], (self.root / entry["path"]).stat().st_size)
        self.command("ai_context_index.py", "--check")
        self.command("ai_context_index.py")
        self.assertEqual(manifest_bytes, manifest_path.read_bytes())
        self.assertEqual(index_bytes, index_path.read_bytes())
        (self.root / "AGENT.md").write_text("# Bootstrap\n\nChanged.\n", encoding="utf-8")
        self.command("ai_context_index.py", "--check", expected=1)
        self.command("ai_context_index.py")
        self.command("ai_context_index.py", "--check")

    def test_link_checker_accepts_markdown_anchors_assets_and_ignores_fences(self):
        result = self.command("check_markdown_links.py")
        self.assertIn("Markdown link check passed", result.stdout)

    def test_link_checker_fails_for_missing_path_and_anchor(self):
        guide = self.root / ".ai" / "guide.md"
        guide.write_text(
            guide.read_text(encoding="utf-8")
            + "\n[Missing](../assets/not-found.json)\n[Bad anchor](../AGENT.md#not-here)\n",
            encoding="utf-8",
        )
        result = self.command("check_markdown_links.py", expected=1)
        self.assertIn("unresolved local target", result.stdout)
        self.assertIn("missing anchor", result.stdout)

    def test_line_limit_excludes_read_only_legacy_corpus_and_checks_project_docs(self):
        legacy = self.root / "futher_md" / "legacy-reference.md"
        legacy.write_text("# Legacy\n" + "source evidence\n" * 220, encoding="utf-8")
        generated_index = self.root / ".ai" / "index.md"
        generated_index.write_text("# Generated index\n" + "navigation\n" * 220, encoding="utf-8")
        maintained = self.root / ".ai" / "too-long.md"
        maintained.write_text("# Maintained\n" + "project documentation\n" * 199, encoding="utf-8")
        result = self.command("check_markdown_line_limit.py", str(self.root), expected=1)
        self.assertIn(".ai/too-long.md", result.stdout)
        self.assertNotIn("futher_md", result.stdout)
        self.assertNotIn(".ai/index.md", result.stdout)

        maintained.write_text("# Maintained\n" + "project documentation\n" * 197, encoding="utf-8")
        result = self.command("check_markdown_line_limit.py", str(self.root))
        self.assertIn("line-count check passed", result.stdout)

if __name__ == "__main__":
    unittest.main(verbosity=2)
