# SG_WAP to SGSCTR agent-governance reconciliation

## Purpose and boundary

This record tracks reusable AI-agent operating guidance reviewed from `specialgroup2024/SG_WAP` and its adaptation into `specialgroup2024/sgsctr`. The repositories remain separate. SG_WAP is a reference source only; it is not an authority for SGSCTR product scope, business policy, technology choices, approvals or implementation status.

The central architecture is preserved: five stable deliberation responsibilities, with ICT and business specializations selected dynamically for the actual task and adapted as evidence, risk, dependencies, scope and lifecycle stage change. The specialist catalogue is open-ended, not a fixed permanent team. A role simulation is not independent review or professional approval.

## Compatibility matrix

| SG_WAP source | Reusable guidance | SGSCTR disposition / target |
|---|---|---|
| `.ai/AGENT_OPERATING_MODEL.md` | Evidence over assertion; small reversible steps; human authority; autonomy boundaries; session protocol; progressive context; delegation; memory hygiene; quality; behavioral improvement; host compatibility | Adapted across `AGENT.md`, `AGENTS.md`, `governance/operating-model.md`, `governance/agent-execution-and-context.md`, `governance/agent-safety-and-tool-boundaries.md` |
| `.ai/AGENTIC_ENGINEERING_EXECUTION.md` | Intake-route-plan-patch-review-verify-handoff; Builder/Reviewer/Verifier stages; capability transparency; tool boundaries; memory lifecycle; solo-developer rollout; completion report | Adapted in `governance/agent-execution-and-context.md`; runtime capabilities remain unverified until behavioral tests are executed |
| `.ai/AGENT_SAFETY.md` | Trust model; untrusted content; secret/data minimization; least privilege; MCP/tool review; safe code/migration execution; memory integrity; incident response; agentic threat coverage | Adapted and reconciled with SGSCTR's existing `governance/security-rules.json`, root `AGENT.md`, security baselines and approval register in `governance/agent-safety-and-tool-boundaries.md`; SGSCTR rules remain authoritative |
| `.ai/ROUTING.md` | Task-based progressive disclosure; route to relevant specs, skills and risk controls | Existing SGSCTR `agent-context.json` and `role-skill-routing.json` are the canonical machine-readable routing. Do not copy SG_WAP paths, skill numbers, sector codes or risk assumptions |
| `.ai/ROLES.md` | Open-ended competency families; task-driven smallest sufficient set; adaptation; explicit lens outputs; examples and review coverage | Adapted in `governance/dynamic-role-selection.md`, `roles/role-selection.md` and machine-readable routing; SGSCTR's five responsibilities remain stable |
| `.ai/workflows/technical-deliberation.md` | Challenge-based deliberation; role-specific challenge duties; retesting; synthesis; evidence and decision record | Existing `governance/deliberation-protocol.md` provides SGSCTR-specific implementation; retained and linked rather than duplicated |
| `.ai/SKILL_INDEX.md` | Skills are methods, not project truth; smallest useful set; reusable-skill structure and maintenance | Adapted in `governance/skill-governance.md`; SGSCTR skill paths and routing remain canonical |
| `.ai/evals/README.md`, `.ai/evals/agentic-capabilities.md` | Behavioral regression tests for instruction discovery, routing, safety, approval, tools, memory, handoff and truthful verification | Adapted into `.ai/evals/`; actual host/runtime execution is a separate verification task and must not be claimed from static checks |

## Deliberately not imported

- SG_WAP-only business scope, sector codes, phase/M00 gates, legacy database, Django or other source-specific stack details.
- SG_WAP-specific skill numbers, file paths, hard-stop identifiers, secret locations and tool configuration.
- Any source-repository proposal or status as an SGSCTR approval or implementation fact.

## Verification and maintenance

This matrix is a semantic adaptation record, not a claim that every possible source file or runtime integration has been exhaustively tested. When SG_WAP guidance changes or new source files are proposed for reuse, inspect them and update the matrix with covered/partial/not-applicable status and rationale. For SGSCTR changes run the governance validator, generated index/manifest checks, Markdown line limit and relative-link checks. Run behavioral cases in the actual target agent environment before claiming runtime compatibility.
