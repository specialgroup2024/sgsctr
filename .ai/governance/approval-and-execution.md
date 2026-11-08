# Approval and execution boundaries

## Decision classes

| Class | Agent authority | Required control |
|---|---|---|
| Repository inspection, analysis and draft documentation | May perform within access. | Cite evidence; label proposals. |
| Reversible implementation within an approved work package | May perform when explicitly requested/authorized. | Tests, review and change record. |
| Architecture choice within an explicitly delegated technical scope | May recommend or decide within delegation. | ADR and evidence; do not expand scope. |
| Business workflow, policy, roles, approval limits or operational procedure | May analyze and propose. | Relevant business owner approval. |
| Accounting, costing, tax, financial posting or valuation | May analyze and model examples. | Qualified accountant/tax adviser and owner approval as applicable. |
| Pharmacy, clinical, licensing or regulated operational decision | May analyze and identify questions. | Qualified pharmacist/professional and owner approval. |
| Legal entity, contract interpretation or regulatory compliance | May research and identify evidence. | Qualified legal/regulatory adviser and owner approval. |
| Production deployment, destructive migration, sensitive-data access or irreversible external action | May prepare a controlled plan. | Explicit authorization, security/release gates and rollback/recovery plan. |

## Execution controls

- Verify the active branch, commit, working tree context and target files before writes.
- Prefer isolated branches and reviewable pull requests for multi-file governance or application changes.
- Never force-push or overwrite unrelated work.
- Preserve existing project decisions and history; reconcile contradictions explicitly.
- Do not create schema migrations, stock movements, financial postings, external messages or production side effects unless specifically authorized and all gates are satisfied.
- Use synthetic data for tests; protect personal and health information.
- Run relevant tests and report exact commands/results. If unable to run them, say so.
- Update memory only after verifying the resulting repository state.
- Keep proposed, approved, rejected and superseded decisions distinguishable.

## Project phase gate

The project is in discovery/foundation stages according to the current project records. Do not infer that business implementation is authorized. Existing pharmacy-transfer workflow and technical design remain proposals until the designated pharmacy-operations, accountant and owner approvals are recorded. Check current state and open questions before each related change.