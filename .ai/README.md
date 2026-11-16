# AI project guide

This folder is the evolving, evidence-based project knowledge base for every AI agent working on this repository, whether local or online.

## Required load order
1. Read root AGENT.md and AGENTS.md.
2. Read governance/operating-model.md, dynamic-role-selection.md, deliberation-protocol.md and approval-and-execution.md.
3. Read governance/approval-register.md before implementation, workflow changes or release decisions.

4. Read memory/project-facts.md, current-state.md and open-questions.md.

4. Read memory/project-facts.md, memory/current-state.md and memory/open-questions.md.

5. Read product/vision.md, product/scope.md and relevant domain documents.
6. For pharmacy tasks, read the Egypt monitoring policy, source register, requirements register, evidence register, roles/pharmacy-domain.md and skills/egypt-compliance-review/SKILL.md.
7. Read relevant architecture, decisions, quality, security and delivery documents.

8. Read governance/cross-platform-agent-compatibility.md when configuring a new agent host; use roles/role-selection.md as the per-task record template.
9. Load only task-relevant SKILL.md files from .ai/skills/. Each skill uses YAML metadata, a focused workflow, guardrails and links to detailed references; the directory name alone does not guarantee host auto-discovery.
10. Read governance/standards-register.md and certification-roadmap.md when security, privacy, AI, audit, procurement or certification scope is affected.
11. Inspect repository reality; memory and plans are navigation aids, not proof of implementation.

8. Read governance/cross-platform-agent-compatibility.md when configuring or operating a new agent host; use roles/role-selection.md as the per-task role-selection record template.
9. Load only task-relevant SKILL.md files from .ai/skills/. Each skill should have YAML metadata, a focused workflow, guardrails and links to detailed references; folder placement alone does not guarantee host auto-discovery.
10. Read governance/standards-register.md and governance/certification-roadmap.md when security, privacy, AI, audit, procurement or certification scope is affected.
11. Inspect repository reality; memory is a navigation aid, not a substitute for source-code inspection.
10. Inspect repository reality; memory is a navigation aid, not a substitute for source-code inspection.

## Egypt pharmacy intelligence — mandatory
The Egypt market/regulatory monitoring policy is required for pharmacy discovery, requirements, architecture, implementation, tests and release. It defines source coverage, evidence classes, review cadence, impact mapping, human approval and limits on claims. The source register is an expandable starting point, not an exhaustive whitelist. The dated scan is an initial snapshot, not a substitute for fresh checks.

The EDA ingestion MVP is owner-approved and merged to master (PR #22); the duplicate-index migration correction is merged (PR #24). Owner-provided VM logs dated 2026-11-11 record a scan of five sources, 100 discovered links, 12 new documents and zero failures. This is one successful observed scan, not proof of exhaustive coverage or continuous service-level reliability. For implementation and operations, read [architecture/eda-regulatory-ingestion.md](architecture/eda-regulatory-ingestion.md) and [delivery/eda-regulatory-ingestion-runbook.md](delivery/eda-regulatory-ingestion-runbook.md). Broader sources and outbound notifications remain gated.

## Phase 1 technical-control references
- [ADR-0002: Identity and access architecture](architecture/ADR-0002-identity-and-access.md) — ASP.NET Core Identity is the owner-directed replacement for Keycloak and is present on master; end-to-end authentication and production policy are not yet evidenced.
- [Identity and access security baseline](security/identity-access-baseline.md) — technical requirements and negative-test expectations.
- [Audit and application logging baseline](security/audit-logging-baseline.md) — event, integrity, access and redaction requirements.
- [Phase 1 technical controls plan](delivery/phase-1-technical-controls-plan.md) — work packages, gates and acceptance evidence.
- [Native application authentication](../docs/security/phase-3-authenticated-workspace.md) — local account bootstrap, sign-in, session and safe migration steps.


## Governance model
The five role responsibilities remain stable; ICT and business specializations are selected dynamically for each task. See governance/dynamic-role-selection.md, governance/deliberation-protocol.md and roles/role-selection.md. The Devil's Advocate and Clueless Client must each challenge the initial proposal with a serious evidence-based flaw; the Maestro remains silent until debate and retesting are complete.

## Approval system
The central governance/approval-register.md is authoritative. Test results never substitute for owner, professional, security or release approval. Owner authorization to develop a capability does not automatically approve its business rules or production activation.

## Egypt pharmacy intelligence
The Egypt market/regulatory monitoring policy is required for pharmacy discovery, requirements, architecture, implementation, tests and release. The source register is expandable, not exhaustive. The dated scan is a snapshot, not continuous monitoring. The EDA ingestion MVP and its limitations are recorded in memory/current-state.md and the architecture/runbook references. Broader sources and outbound notifications remain gated unless separately approved.

## Memory rules
- Memory is curated project knowledge, not a conversation transcript.
- Mark facts confirmed, owner-provided, assumption, proposed or unverified.
- Record evidence/source, owner and review date for decisions that can change.
- Do not store credentials, patient records, personal information or raw production records.

- Put enduring technical decisions in ADRs; unresolved decisions in memory/open-questions.md.

- Update memory only when new information is confirmed; do not convert assumptions into facts by repetition.
- Put enduring technical decisions in ADRs; keep unresolved decisions in memory/open-questions.md.

## Standards and certification
- governance/standards-register.md maps versioned standards to testable controls; verify official source status before use.
- governance/certification-roadmap.md is an evaluation aid, not a certification claim.
- Egyptian legal and pharmacy requirements remain separate and require qualified review.

## Source reconciliation
- See governance/source-reconciliation-ai-chat.md for the 2026-11-15 mapping of the four owner-supplied ai-chat documents to existing SGSCTR context and the decisions deliberately not imported.

## Documentation size and approval
Every Markdown file must remain below 200 lines. Aim for 180 lines or fewer. Split long content into linked focused documents. CI enforces the limit through scripts/check_markdown_line_limit.py.

Agents may analyze, challenge, propose, implement and test within approved scope. They may not approve legal, pharmacy, accounting, tax or other reserved decisions on behalf of qualified people. Maestro is a technical decision role, not the business owner and cannot waive approval gates.


## Standards and certification
- governance/standards-register.md maps versioned standards to testable controls; recheck official source status before use.
- governance/certification-roadmap.md is a planning aid only. A standard, checklist or agent-generated document is not certification.
- Egypt-specific legal and pharmacy obligations remain in their separate register and require qualified review.

## Documentation size and approval
Every Markdown file must remain below 200 lines; aim for 180 or fewer. CI enforces scripts/check_markdown_line_limit.py. Split detailed guidance into focused linked documents.


## Docker API startup recovery
- [Docker API startup-crash recovery](delivery/docker-api-startup-recovery.md) — evidence-led diagnosis and safe recovery for API exit 139, native runtime faults, EF migration failures, Compose health dependencies and credential exposure. This is a runbook, not proof the owner's VM was repaired.
