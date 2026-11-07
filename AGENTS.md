# Repository rules

## Architecture and implementation
- Confirm selected .NET, PostgreSQL and React Native versions in .ai/architecture/system-context.md before changing dependencies.
- Follow module ownership; shared code must not absorb business-specific rules.
- Use server-side authorization for every protected operation.
- Use database constraints and transactions for approved financial and stock invariants.
- Use fixed-precision monetary values with explicit currency; follow approved precision and rounding rules.
- Make migrations reversible where feasible; document irreversible steps.
- Make retryable integrations idempotent.
- Keep secrets, patient information and production data out of Git, logs and test fixtures.
- Add or update tests for behavior changes and database migrations.
- Update relevant requirements, decisions, memory and runbooks.
- Run applicable builds, tests, linters and security checks before reporting completion.
- If a requirement conflicts with this file, stop and record the conflict.

## Documentation governance
- Every Markdown file in the repository must contain fewer than 200 lines.
- Aim for 180 lines or fewer; split long guidance into linked focused documents.
- Enforce the rule with scripts/check_markdown_line_limit.py in CI.
- Never embed executable Python source in Markdown instructions.
- Do not report the line-limit check as passed unless it was run successfully.
