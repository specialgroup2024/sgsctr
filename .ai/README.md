# AI project guide

This folder is the evolving, evidence-based project knowledge base for every AI agent working on this repository, whether local or online.

## Required load order
1. Read root AGENT.md and AGENTS.md.
2. Read governance/operating-model.md, dynamic-role-selection.md, deliberation-protocol.md and approval-and-execution.md.
3. Read governance/approval-register.md before implementation, workflow changes or release decisions.
4. Read memory/project-facts.md, current-state.md and open-questions.md.
5. Read product/vision.md, product/scope.md and relevant domain documents.
6. For pharmacy tasks, read the Egypt monitoring policy, source register, requirements register, evidence register, roles/pharmacy-domain.md and skills/egypt-compliance-review/SKILL.md.
7. Read relevant architecture, decisions, quality, security and delivery documents.
8. Read governance/cross-platform-agent-compatibility.md when configuring a new agent host; use roles/role-selection.md as the per-task record template.
9. Load only task-relevant SKILL.md files from .ai/skills/. Each skill uses YAML metadata, a focused workflow, guardrails and links to detailed references; the directory name alone does not guarantee host auto-discovery.
10. Read governance/standards-register.md and certification-roadmap.md when security, privacy, AI, audit, procurement or certification scope is affected.
11. Inspect repository reality; memory and plans are navigation aids, not proof of implementation.

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

## Standards and certification
- governance/standards-register.md maps versioned standards to testable controls; recheck official source status before use.
- governance/certification-roadmap.md is a planning aid only. A standard, checklist or agent-generated document is not certification.
- Egypt-specific legal and pharmacy obligations remain in their separate register and require qualified review.

## Documentation size and approval
Every Markdown file must remain below 200 lines; aim for 180 or fewer. CI enforces scripts/check_markdown_line_limit.py. Split detailed guidance into focused linked documents.
