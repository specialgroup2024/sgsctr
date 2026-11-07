from pathlib import Path
import sys

LIMIT = 200
EXCLUDED = {".git", "node_modules", "bin", "obj", ".venv", "venv"}
violations = []

for path in Path(".").rglob("*.md"):
    if any(part in EXCLUDED for part in path.parts):
        continue
    try:
        count = len(path.read_text(encoding="utf-8").splitlines())
    except UnicodeDecodeError:
        violations.append(f"{path}: not valid UTF-8")
        continue
    if count >= LIMIT:
        violations.append(f"{path}: {count} lines (maximum allowed: {LIMIT - 1})")

if violations:
    print("\n".join(violations))
    sys.exit(1)

print("Markdown line-count check passed.")
