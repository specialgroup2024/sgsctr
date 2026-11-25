# Repository execution instructions

This file is intentionally limited to repository mechanics. Universal behavior/approval boundaries are in [AGENT.md](AGENT.md); context loading is in [.ai/README.md](.ai/README.md) and [.ai/agent-context.json](.ai/agent-context.json).

## Before editing
- Confirm repository, branch, commit and working-tree state.
- Read the machine-readable baseline, then select the task profile; do not load the entire documentation tree by default.
- Inspect affected source, callers, tests, migrations, configuration and deployment files.
- Map affected modules, APIs, data, UI, security, tests, docs, rollback and approvals.
- Preserve unrelated work; use focused branches and reviewable commits for multi-file changes.

## Implementation conventions
- Backend: ASP.NET Core/C# and EF Core/Npgsql. Confirm pins in global.json, project files and Directory.Packages.props.
- Database: PostgreSQL; inspect migration SQL and model snapshots.
- Web: Next.js/TypeScript; follow shared locale provider, BFF and design conventions.
- Mobile: React Native is direction; verify project/toolchain before claiming it exists.
- Keep module ownership explicit; use transactions and constraints for persistent invariants.
- Use fixed-precision decimal with explicit currency; never floating point for money.
- Use UTC timestamps and explicit source timezone where required.
- Authorize every API request server-side; default deny.
- Make retries idempotent. Never edit an applied migration; add a forward correction.
- Keep secrets and sensitive data out of Git/logs.

## Verification
- Add tests for changed behavior, failure paths, authorization and persistence.
- Run applicable build, tests, format/lint, EF parity, migration, documentation and security checks.
- Record exact command, environment, result and evidence. Runner not started = Blocked/Not Run.
- Validate machine-readable agent context, specialist routing, security policy and every referenced path:
  python scripts/check_ai_governance.py
- Regenerate/check context metadata after Markdown changes:
  python scripts/ai_context_index.py
  python scripts/ai_context_index.py --check
- Run Markdown line-limit and relative-link checks. Never claim a check passed unless executed.
- Keep maintained project Markdown below 200 lines; target 180 or fewer. Split focused docs and link them. The owner-designated read-only legacy evidence corpus `futher_md/` is exempt: preserve its source files unchanged, and exclude that folder from the maintained-document line-limit check.
- Update current-state/open-questions/project-facts only when evidence requires it; do not duplicate one-off chat summaries.

## Release
Do not deploy or merge without explicit authorization. Follow .ai/delivery/release-and-rollback.md and the approval register. A successful build is not release approval.
