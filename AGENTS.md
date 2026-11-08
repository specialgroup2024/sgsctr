# Repository-wide instructions

## Instruction bootstrap and precedence

- All agents must read `AGENT.md`, this file and `.ai/README.md` before acting.
- `AGENT.md` defines universal agent behavior; `AGENTS.md` defines repository execution constraints; `.ai/` contains project-specific context and detailed procedures.
- Apply the most restrictive applicable security, safety and approval rule. A lower-level file cannot waive a higher-level restriction or owner approval.
- If instructions conflict, stop the affected action, record the conflict and ask for resolution. Do not silently choose a convenient interpretation.
- Agent-tool-specific files (for example, vendor-specific instruction files) may bootstrap to these sources but must not create contradictory parallel policy.

## Dynamic specialist operation

- Dynamically identify task specializations and select professional profiles for the five stable roles using `.ai/governance/dynamic-role-selection.md`.
- Follow the deliberation protocol in `.ai/governance/deliberation-protocol.md` for substantive design, architecture, security, data, business-process and high-impact decisions.
- Do not permanently assign ICT job titles to the roles. Re-evaluate specialization for each materially different task.
- When a tool cannot support multiple agents, conduct clearly labeled perspective-based analysis; do not imply independent agents participated.

## Architecture and implementation

- Confirm selected .NET, PostgreSQL and React Native versions in `.ai/architecture/system-context.md` before changing dependencies.
- Inspect current code, configuration, tests, migrations and deployment assets before proposing implementation.
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

## Approval and change controls

- The agent may inspect, analyze and propose within its access.
- Implementation must remain within explicitly approved scope and the repository's current release gates.
- Legal entity, licensing, regulatory interpretation, accounting policy, tax treatment, pharmacy procedures, financial calculations, stock valuation, access to sensitive production data and irreversible operations require the designated qualified owner/professional approval.
- Proposed ADRs, plans and deliberation outcomes are not approved merely because an agent or Maestro recommends them.
- Do not create production schema changes, stock movements, financial postings or external side effects without the required authorization.

## Documentation governance

- Every Markdown file must contain fewer than 200 lines.
- Aim for 180 lines or fewer; split long guidance into linked focused documents.
- Enforce the rule with `scripts/check_markdown_line_limit.py` in CI.
- Never embed executable Python source in Markdown instructions.
- Do not report the line-limit check as passed unless it was run successfully.