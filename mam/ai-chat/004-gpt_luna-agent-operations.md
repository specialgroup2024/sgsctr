# Agent operating guidance

This document continues [002-gpt_luna.md](002-gpt_luna.md).

## Keep every Markdown file below 200 lines

Add this rule to `AGENTS.md` and enforce it in CI. A 180-line target is safer than writing files up to the limit.

```python
from pathlib import Path

limit = 200
violations = []

for path in Path(".").rglob("*.md"):
    if any(part in {".git", "node_modules", "bin", "obj"} for part in path.parts):
        continue
    count = len(path.read_text(encoding="utf-8").splitlines())
    if count >= limit:
        violations.append(f"{path}: {count} lines")

if violations:
    print("\n".join(violations))
    raise SystemExit(1)

print("Markdown line-count check passed.")
```

See [003-gpt_luna-standards-and-certification.md](003-gpt_luna-standards-and-certification.md) for the version baseline, standards references and certification roadmap.
