# AI-agent governance instruction consolidation — review record

Date: 2026-11-16  
Base: `master` at the time of branch creation  
Branch: `docs/ai-governance-instruction-consolidation`

## Scope and evidence

This is a documentation-only correction to the bootstrap and governance instructions in root `AGENT.md`, root `AGENTS.md` and `.ai/README.md`. Repository inspection confirmed duplicated startup/load-order sequences, repeated architecture and Egypt-pharmacy controls, inconsistent relative paths and repeated standards/documentation sections. The existing five-role model, approval register and substantive safeguards are retained.

## Dynamically selected review perspectives

This low-risk, reversible documentation task uses proportionate review rather than a full five-role transcript, as permitted by `.ai/governance/deliberation-protocol.md`.

| Stable role | Selected profile | Review focus |
|---|---|---|
| Architect | AI-agent governance / repository documentation architect | One canonical bootstrap and precedence model |
| Devil's Advocate | Developer-experience and instruction-conflict reviewer | Broken paths, omitted gates, accidental loss of safeguards |
| Clueless Client | Solo project owner / non-specialist repository operator perspective | Clear, linear startup steps; no duplicate instructions |
| Subject Matter Expert | Documentation-as-code and AI-agent interoperability specialist | Relative-link correctness, scope preservation, line-limit policy |
| Maestro | Senior engineering governance reviewer (simulated) | Technical determination after the focused checks |

These are simulated analytical perspectives, not independent agents or human professional approvals.

## Findings and correction

- Root `AGENT.md` contained two competing startup sequences, repeated numbering and paths that omitted the `.ai/` prefix. It now has one numbered sequence with explicit root-relative paths and the approval-register gate.
- Root `AGENTS.md` repeated architecture controls and Egypt pharmacy monitoring rules. These are consolidated into one section each; unique requirements and PR/runtime evidence qualifications are retained. The approval-register path is corrected to `.ai/governance/approval-register.md`.
- `.ai/README.md` repeated and misnumbered load-order steps, repeated Egypt intelligence, standards and documentation-governance sections, and duplicated memory guidance. It now has one ordered load sequence and one canonical section for each topic.
- No business rule, approval status, application code, database schema, migration, workflow behavior or production setting was changed.

## Challenges and retesting

- Devil's Advocate challenge: simplifying repeated controls could accidentally remove a unique security, regulatory or approval safeguard. Response: consolidate by retaining unique clauses and preserving the more detailed current EDA evidence and limitations.
- Clueless Client challenge: multiple startup sequences leave an operator unsure which path to follow. Response: retain one sequential load order in each entry point and make paths unambiguous.
- SME review: root instructions must use `.ai/...` paths, while links inside `.ai/README.md` remain relative to the `.ai/` directory. The corrected paths follow that distinction.
- Architect response: preserve the five stable responsibilities and dynamic specialization rules; do not turn the cleanup into a fixed role catalogue or a static project plan.
- Maestro determination: the documentation consolidation is appropriate and bounded. It does not establish that every linked file exists, that CI passes, or that the application/runtime is healthy. Those require separate verification.

## Verification status

- Source files were fetched from `master` before editing; edits are applied on the isolated branch.
- Required follow-up: inspect the branch diff, count the three edited files, run the repository Markdown line-limit checker and verify referenced bootstrap paths.
- No tests/builds were run because no application code changed.
- Human owner approval remains required before merging this pull request. No merge is performed by this task.
