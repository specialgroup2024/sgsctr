# AI project guide

This folder is the evolving, evidence-based project knowledge base for every AI agent working on this repository, whether local or online.

## Required load order

1. Read root AGENT.md and AGENTS.md.
2. Read governance/operating-model.md, governance/dynamic-role-selection.md, governance/deliberation-protocol.md and governance/approval-and-execution.md.
3. Read memory/current-state.md and memory/open-questions.md.
4. Read product/vision.md, product/scope.md and relevant domain documents.
5. For pharmacy tasks, read governance/egypt-pharmacy-market-monitoring.md, governance/egypt-pharmacy-source-register.md, governance/egypt-requirements-register.md, governance/evidence-register.md, roles/pharmacy-domain.md and skills/egypt-compliance-review/SKILL.md.
6. Read relevant architecture, decisions, quality, security and delivery documents.
7. Load only the skills relevant to the task.
8. Inspect repository reality; memory is a navigation aid, not a substitute for source-code inspection.

## Egypt pharmacy intelligence — mandatory

The Egypt market/regulatory monitoring policy is required for pharmacy discovery, requirements, architecture, implementation, tests and release. It defines source coverage, evidence classes, review cadence, impact mapping, human approval and limits on claims. The source register is an expandable starting point, not an exhaustive whitelist. The dated scan is an initial snapshot, not a substitute for fresh checks.

Maintain the Egyptian requirements and evidence registers. The EDA ingestion MVP is owner-approved and implemented on feat/eda-regulatory-ingestion, pending CI/runtime verification and merge. It is separate from the mandatory agent research workflow. For implementation and operations, read [architecture/eda-regulatory-ingestion.md](architecture/eda-regulatory-ingestion.md) and [delivery/eda-regulatory-ingestion-runbook.md](delivery/eda-regulatory-ingestion-runbook.md). The MVP is not exhaustive; broader sources and outbound notifications remain gated.

## Phase 1 technical-control references

- [ADR-0002: Identity and access architecture](architecture/ADR-0002-identity-and-access.md) — ASP.NET Core Identity is the owner-directed replacement; CI/runtime verification and business access decisions remain pending.
- [Identity and access security baseline](security/identity-access-baseline.md) — technical requirements and negative-test expectations.
- [Audit and application logging baseline](security/audit-logging-baseline.md) — event, integrity, access and redaction requirements.
- [Phase 1 technical controls plan](delivery/phase-1-technical-controls-plan.md) — work packages, gates and acceptance evidence.
- [Native application authentication](../docs/security/phase-3-authenticated-workspace.md) — local account bootstrap, sign-in, session and safe migration steps.

## Governance model

The five role responsibilities are stable, while their ICT and business professional identities are selected dynamically for each problem. See governance/dynamic-role-selection.md. All agents must use the same principles across local and online environments.

## Memory rules

- Memory is curated project knowledge, not a conversation transcript.
- Mark facts confirmed, owner-provided, assumption, proposed or unverified.
- Record evidence/source, owner and review date for decisions that can change.
- Do not store credentials, patient records, personal information or raw production records.
- Update memory only when new information is confirmed; do not convert assumptions into facts by repetition.
- Put enduring technical decisions in ADRs; keep unresolved decisions in memory/open-questions.md.

## Documentation size and approval

Every Markdown file must remain below 200 lines. Aim for 180 lines or fewer. Split long content into linked focused documents. CI enforces the limit through scripts/check_markdown_line_limit.py.

Agents may analyze, challenge, propose, implement and test within approved scope. They may not approve legal, pharmacy, accounting, tax or other reserved decisions on behalf of qualified people. Maestro is a technical decision role, not the business owner and cannot waive approval gates.

No business features or production financial calculations before required owner and professional approvals of requirements and worked examples. Proposed ADRs remain unapproved until an authorized decision is recorded.

## Phase 2 UI references

- [Application shell and organization workspace plan](delivery/phase-2-application-shell-plan.md) — Phase 2 scope and exclusions.
- [Authenticated workspace setup](../docs/security/phase-3-authenticated-workspace.md) — native Identity BFF login, VM tunnel, migration and organization-manager setup.
- [Product scope](product/scope.md) — staged product boundaries and explicit exclusions.
