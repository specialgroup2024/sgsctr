from pathlib import Path
import sys

LIMIT = 200
EXCLUDED = {".git", "node_modules", "bin", "obj", ".venv", "venv"}
# Owner-designated read-only legacy evidence is not maintained SGSCTR documentation.
# Keep its original source documents intact; enforce the line limit on project-authored docs.
EXCLUDED_ROOT_PATHS = {"futher_md"}
EXCLUDED_PATHS = {".ai/index.md"}


def check_markdown(root: Path, limit: int = LIMIT) -> list[str]:
    root = root.resolve()
    violations = []
    for path in root.rglob("*.md"):
        relative = path.relative_to(root)
        if not relative.parts:
            continue
        if relative.parts[0] in EXCLUDED_ROOT_PATHS or relative.as_posix() in EXCLUDED_PATHS:
            continue
        if any(part in EXCLUDED for part in relative.parts):
            continue
        try:
            count = len(path.read_text(encoding="utf-8").splitlines())
        except UnicodeDecodeError:
            violations.append(f"{relative}: not valid UTF-8")
            continue
        if count >= limit:
            violations.append(f"{relative}: {count} lines (maximum allowed: {limit - 1})")
    return violations


def main() -> int:
    root = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(".")
    violations = check_markdown(root)
    if violations:
        print("\n".join(violations))
        return 1
    print("Markdown line-count check passed (owner-designated futher_md/ legacy evidence excluded).")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
