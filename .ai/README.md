# SGSCTR AI project context

Evidence-based project knowledge for local/online agents; not a transcript or static master plan.

## Start small
Read [agent-context.json](agent-context.json) first. It defines the mandatory baseline and task profiles that load only relevant references. Do not read every Markdown file by default; follow links and inspect source as impact requires.

Generated [index](index.md) is navigation; [manifest](CONTEXT_MANIFEST.json) records tracked Markdown integrity. Neither is an approval source.

## Authority
- Root [AGENT.md](../AGENT.md): universal mission, safety and human approval boundaries.
- Root [AGENTS.md](../AGENTS.md): repository execution mechanics.
- [Security rules](governance/security-rules.json): mandatory AI handling of secrets, sensitive data, logs, artifacts and untrusted external input.
- [Approval register](governance/approval-register.md): authoritative recorded approvals.
- [Project facts](memory/project-facts.md): stable curated facts and provenance.
- [Current state](memory/current-state.md): dated repository/runtime reconciliation; verify against source.
- [Open questions](memory/open-questions.md): unresolved decisions and owners.
- [Operating model](governance/operating-model.md): evidence classes and work cycle.
- [Agent execution and context](governance/agent-execution-and-context.md): session protocol, progressive context, delegation, stop conditions and evidence-based handoff.
- [Agent safety detail](governance/agent-safety-and-tool-boundaries.md): untrusted input, least privilege, safe tool use and incident response.
- [Skill governance](governance/skill-governance.md): reusable-method selection, structure and maintenance.
- [Behavioral evaluations](evals/README.md): tests of actual agent behavior, not documentation presence alone.
- [SG_WAP reconciliation](governance/source-reconciliation-sg-wap.md): evidence-backed compatibility matrix and explicit non-imports.
- [Dynamic roles](governance/dynamic-role-selection.md): five stable responsibilities with task-selected specializations.
- [Role/skill routing](governance/role-skill-routing.json): machine-readable task signals, specialist references and additive profiles.
- [ADR conventions](governance/adr-conventions.md): repository-wide numbering and lifecycle rules.
- [Repository policy gaps](governance/repository-policy-decisions.md): owner-gated licence/security scaffolding and conservative cleanup decisions.
- [Deliberation](governance/deliberation-protocol.md): substantive decision review.
- [Approval and execution](governance/approval-and-execution.md): work authorization vs approval.

## Project baseline
Owner identifies Special Group with Pharmacies and Specialized Contracting sectors. One legal entity is provisional pending documentary verification. Owner-identified pharmacy sites: Mokattam main warehouse, Student Hospital, Qasr El-Aini and Manial Hospital. Branch-to-branch transfers are required capability; workflow, costing and posting remain approval-gated.

Technology baseline is in [system context](architecture/system-context.md). Implementation status is in current-state and must be checked against source.

## Pharmacy controls
For pharmacy tasks, task profiles load Egyptian requirements, source/evidence registers and compliance skill. Distinguish binding instruments, regulator guidance, drafts, official announcements and market signals. Verify primary sources and applicability. Qualified legal/regulatory, pharmacy, quality, accounting and owner decisions remain separate gates. Never auto-change dispensing, stock, prices, reimbursement or accounting from detected updates.

## Memory discipline
See [state update protocol](memory/state-update-protocol.md) and the append-only [change log](memory/change-log.md). Current-state is a concise snapshot; detailed incidents and acceptance evidence belong in canonical delivery records.

Memory is curated, not transcript. Mutable statements require status/provenance or linked evidence and owner/review date where applicable. Record dated evidence-linked changes; reconcile current summary from canonical records. Do not create contradictory one-off notes or overwrite approval history. Never store secrets, patient records or raw production data.

## Documentation integrity
Keep Markdown below 200 lines (target 180). Run generator check, line-limit checker and relative-link checker. Regenerate, never hand-edit, generated manifest/index. See [integrity policy](governance/ai-context-index-and-integrity.md).

## Source reconciliation
Owner-provided /mam/ai-chat guidance is mapped in [source-reconciliation-ai-chat.md](governance/source-reconciliation-ai-chat.md). Reuse modular-monolith, accounting-boundary, dynamic-specialist, curated-memory, standards and concise-documentation principles without converting generic proposals into approvals.
