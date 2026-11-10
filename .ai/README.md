# AI project guide

This folder is the evolving, evidence-based project knowledge base for every AI agent working on this repository, whether local or online.

## Required load order

1. Read root `AGENT.md` and `AGENTS.md`.
2. Read `governance/operating-model.md`, `governance/dynamic-role-selection.md`, `governance/deliberation-protocol.md` and `governance/approval-and-execution.md`.
3. Read `memory/current-state.md` and `memory/open-questions.md`.
4. Read `product/vision.md`, `product/scope.md` and relevant domain documents.
5. Read relevant architecture, decisions, quality, security and delivery documents.
6. Load only the skills relevant to the task.
7. Inspect repository reality; memory is a navigation aid, not a substitute for source-code inspection.

## Phase 1 technical-control references

- [ADR-0002: Identity and access architecture](architecture/ADR-0002-identity-and-access.md) — self-hosted Keycloak selected; production topology and business access decisions remain pending.
- [Identity and access security baseline](security/identity-access-baseline.md) — technical requirements and negative-test expectations.
- [Audit and application logging baseline](security/audit-logging-baseline.md) — event, integrity, access and redaction requirements.
- [Phase 1 technical controls plan](delivery/phase-1-technical-controls-plan.md) — work packages, gates and acceptance evidence.
- [Keycloak local setup](../docs/security/keycloak-local-setup.md) — local realm, test-client and API verification steps.

## Governance model

The five role responsibilities are stable, while their ICT professional identities are selected dynamically for each problem. See `governance/dynamic-role-selection.md`. All agents must use the same principles across local and online environments.

## Memory rules

- Memory is curated project knowledge, not a conversation transcript.
- Mark facts confirmed, owner-provided, assumption, proposed or unverified.
- Record evidence/source, owner and review date for decisions that can change.
- Do not store credentials, patient records, personal information or raw production records.
- Update memory only when new information is confirmed; do not convert assumptions into facts by repetition.
- Put enduring technical decisions in ADRs; keep unresolved decisions in `memory/open-questions.md`.

## Documentation size

Every Markdown file must remain below 200 lines. Aim for 180 lines or fewer. Split long content into linked focused documents. CI enforces the limit through `scripts/check_markdown_line_limit.py`.

## Agent behavior and phase gates

Agents may analyze, challenge, propose, implement and test within approved scope. They may not approve legal, pharmacy, accounting, tax or other reserved decisions on behalf of qualified people. Maestro is a technical decision role, not the business owner and cannot waive approval gates.

No business features or production financial calculations before required owner and professional approvals of requirements and worked examples. Proposed ADRs remain unapproved until an authorized decision is recorded.
