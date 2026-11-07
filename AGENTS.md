# Repository rules

- Confirm the selected .NET, PostgreSQL, and React Native versions from
  .ai/architecture/system-context.md before changing dependencies.
- Follow module ownership: shared code must not absorb business-specific rules.
- Use server-side authorization for every protected operation.
- Use database constraints and transactions for financial and stock invariants.
- Use fixed-precision monetary values with an explicit currency.
- Make migrations reversible where feasible; document any irreversible step.
- Make retryable integrations idempotent.
- Do not put secrets, personal health information, or production data in Git.
- Add or update tests for behavior changes and database migrations.
- Update the relevant requirements, decision, memory, and runbook documents.
- Run the applicable build, tests, linters, and security checks before reporting
  completion.
- If a requirement conflicts with this file, stop and record the conflict.


# Add this rule to AGENTS.md and enforce it in CI. A 180-line target is safer than writing files up to the limit.
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
# end of Add this rule to AGENTS.md