# Repository-wide instructions

## Bootstrap and precedence
- Read AGENT.md, this file and .ai/README.md before acting.
- AGENT.md governs universal behavior; this file governs repository execution; .ai/ contains project context and procedures.
- Apply the most restrictive security, safety and approval rule. If instructions conflict, stop the affected action, record the conflict and ask for resolution.
- Agent-host-specific files may bootstrap to these sources but must not create contradictory policy.

## Dynamic specialist operation
- Select professional profiles for the five stable roles using .ai/governance/dynamic-role-selection.md.
- Follow .ai/governance/deliberation-protocol.md for substantive decisions; do not permanently assign ICT job titles.
- Add pharmacy, Egyptian regulatory, pharmacist, pharmacovigilance/quality, supply-chain, legal, tax and accounting profiles only when relevant.
- If multiple agents cannot run, disclose that perspectives are simulated, not independent agents or qualified professionals.

## Dynamic agent work cycle
- Use: Discover → Understand → Analyze → Impact-map → Select specialists → Deliberate → Resolve approval gates → Implement authorized scope → Verify → Document → Remember → Reassess.
- Inspect repository state, history, tests, configuration and current state; plans and memory are not proof of implementation.
- Identify affected domains, users, data classes, dependencies, risks and acceptance evidence.
- Map changes to requirements, components, data/migrations, security/privacy, tests, documentation, rollback and approvals.
- If a source or prerequisite is unavailable, record it as unknown; continue only safe discovery or authorized draft work.
- Keep ADRs, work packages, current-state notes and open questions synchronized. Do not create a static master plan that overrides .ai/.

## Architecture and implementation
- Confirm .NET, PostgreSQL and React Native versions in `.ai/architecture/system-context.md` before dependency changes.
- Inspect code, configuration, tests, migrations and deployment assets before proposing implementation.
- Respect module ownership; shared code must not absorb business-specific rules.
- Enforce server-side authorization for every protected operation.
- Protect approved financial and inventory invariants with database transactions and constraints.
- Store money as fixed-precision decimals with explicit currency; never use floating-point arithmetic for money. Precision, rounding and calculation order require approved rules.
- Make timestamp/time-zone behavior explicit; do not rely on implicit server-local time.
- Make migrations reversible where feasible; document irreversible steps and recovery.
- Make retryable integrations idempotent.
- Keep secrets, patient/employee health information and production records out of Git, logs and test fixtures.
- Add or update tests for behavior and migrations; update relevant requirements, decisions, memory and runbooks.
- Run applicable builds, tests, linters and security checks; report exact commands and results.

## Egypt pharmacy intelligence and regulatory controls
- Follow the mandatory monitoring policy and source register under `.ai/governance/` before pharmacy discovery, design, implementation, testing or release.
- Check current Egyptian primary sources and broaden discovery to relevant professional, industry, supplier, payer, procurement and reputable media sources; record source class and retrieval time.
- Distinguish binding instruments, regulator guidance, drafts, official announcements and unverified market signals. Verify current text, amendments, applicability and effective dates.
- Link material updates to the Egyptian requirements register, evidence register, affected modules, tests and proposed actions.
- Legal interpretation, pharmacy practice, licensing, clinical/quality disposition, tax/accounting and business-policy decisions require qualified human review and owner approval as applicable.
- Never claim exhaustive coverage, real-time monitoring or legal compliance without evidence. Never autonomously change prices, dispensing, stock, reimbursement or accounting.
- The EDA ingestion MVP is owner-approved and merged (PR #22); its duplicate-index migration correction is merged (PR #24). Owner-provided runtime evidence records one scan of five sources, 100 links, 12 new documents and zero failures on 2026-11-11. This does not establish exhaustive coverage, continuous reliability or completed human review. See `.ai/architecture/eda-regulatory-ingestion.md`, `.ai/delivery/eda-regulatory-ingestion-runbook.md` and `.ai/memory/current-state.md`. Broader sources, paid feeds, outbound notifications and retention policy remain gated.

## Approval and change controls
- `.ai/governance/approval-register.md` is authoritative. Approval applies only to its recorded scope and conditions.
- A recommendation, draft ADR, passing CI or merged PR is not automatically an approval.
- Legal entity, licensing, regulatory interpretation, accounting, tax, pharmacy procedures, financial calculations, stock valuation, sensitive production-data access and irreversible operations require designated approval.
- Do not create production schema changes, stock movements, financial postings or external side effects without required authorization.
- Never merge a pull request without explicit user authorization.

## Documentation governance
- Use the generated `.ai/index.md` and `.ai/CONTEXT_MANIFEST.json` for navigation and tracked-Markdown integrity; never treat them as approval or policy sources.
- Regenerate with `python scripts/ai_context_index.py`; verify with `python scripts/ai_context_index.py --check`.
- CI checks generated-index freshness and repository-relative Markdown links. External URLs are not fetched by the link check.
- Preserve existing canonical documents and history; do not create parallel task logs or duplicate policy documents.
- Every Markdown file must contain fewer than 200 lines; aim for 180 or fewer.
- Enforce with scripts/check_markdown_line_limit.py and the CI workflow.
- Do not embed executable Python source in Markdown instructions.
- Do not report the line-limit check as passed unless it was run successfully.

## Internationalization and RTL
- Use the shared locale provider and translation catalogue; do not add per-page locale state or browser-translation workarounds.
- Persist locale through the approved preference mechanism and render matching document language/direction.
- Use direction-aware layout and CSS logical properties; preserve LTR for identifiers, URLs, email addresses, serials and code values.
- Add tests for locale persistence, switching, root direction, translation coverage and mixed-direction content.
- Never translate persisted business data, API enums, regulatory evidence or audit records.
