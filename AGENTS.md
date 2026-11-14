# Repository-wide instructions

## Instruction bootstrap and precedence
- All agents must read AGENT.md, this file and .ai/README.md before acting.
- AGENT.md defines universal agent behavior; AGENTS.md defines repository execution constraints; .ai/ contains project-specific context and detailed procedures.
- Apply the most restrictive applicable security, safety and approval rule. A lower-level file cannot waive a higher-level restriction or owner approval.
- If instructions conflict, stop the affected action, record the conflict and ask for resolution. Do not silently choose a convenient interpretation.
- Agent-tool-specific files may bootstrap to these sources but must not create contradictory parallel policy.

## Dynamic specialist operation
- Dynamically identify task specializations and select professional profiles for the five stable roles using .ai/governance/dynamic-role-selection.md.
- Follow .ai/governance/deliberation-protocol.md for substantive design, architecture, security, data, business-process and high-impact decisions.
- Do not permanently assign ICT job titles to the roles. Re-evaluate specialization for each materially different task.
- For pharmacy work, dynamically add Egyptian regulatory affairs, licensed pharmacist/pharmacy operations, pharmacovigilance/quality, pharmaceutical supply-chain/market analysis, Egyptian legal, tax/accounting and relevant ICT profiles as the task requires. These are selected profiles, not fictitious independent experts.
- When a tool cannot support multiple agents, conduct clearly labeled perspective-based analysis; do not imply independent agents participated.

## Architecture and implementation
- Confirm selected .NET, PostgreSQL and React Native versions in .ai/architecture/system-context.md before changing dependencies.
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

## Egypt pharmacy market and regulatory controls
- Follow the mandatory monitoring policy and source register under .ai/governance before any pharmacy-related discovery, design, implementation, testing or release.
- Check current Egyptian primary sources and broaden discovery to professional, industry, supplier, payer, procurement and reputable media sources; record source class and retrieval time.
- Distinguish binding instruments, regulator guidance, drafts, official announcements and unverified market signals. Verify current text, amendments, applicability and effective date.
- Link each material update to the Egyptian requirements register, evidence register, affected modules, tests and proposed actions.
- Legal interpretation, pharmacy practice, licensing, clinical/quality disposition, tax/accounting and business-policy decisions require qualified human review and owner approval.
- Never claim complete market coverage, real-time monitoring or legal compliance without evidence. Do not make autonomous changes to product prices, dispensing, stock, reimbursement or financial rules.
- The EDA ingestion MVP is owner-approved and merged to master (PR #22); the duplicate-index migration correction is merged (PR #24). Runtime evidence supplied by the owner confirms a scan of five sources and 100 links, with 12 new documents and zero failures on 2026-11-11. This does not establish exhaustive coverage or end-to-end reviewer workflow. Check .ai/architecture/eda-regulatory-ingestion.md and .ai/delivery/eda-regulatory-ingestion-runbook.md. Broader Egyptian source coverage, email/SMS/push, paid feeds and retention policy remain gated.

## Approval and change controls
- The agent may inspect, analyze and propose within its access.
- Implementation must remain within explicitly approved scope and the repository's current release gates.
- Legal entity, licensing, regulatory interpretation, accounting policy, tax treatment, pharmacy procedures, financial calculations, stock valuation, access to sensitive production data and irreversible operations require designated qualified professional/owner approval.
- Proposed ADRs, plans and deliberation outcomes are not approved merely because an agent or Maestro recommends them.
- Do not create production schema changes, stock movements, financial postings or external side effects without required authorization.

## Documentation governance
- Every Markdown file must contain fewer than 200 lines.
- Aim for 180 lines or fewer; split long guidance into linked focused documents.
- Enforce the rule with scripts/check_markdown_line_limit.py in CI.
- Never embed executable Python source in Markdown instructions.
- Do not report the line-limit check as passed unless it was run successfully.
