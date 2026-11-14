# Approval and execution boundaries

## Authoritative approval record

- Check [.ai/governance/approval-register.md](approval-register.md) before implementation, workflow activation or release.
- The register is the authoritative index. Each entry links to a detailed decision/review record and evidence.
- A chat response, agent recommendation, draft ADR, merged PR or passing CI is not automatically an approval.
- Approval applies only to the exact scope, conditions, authority and period recorded. Do not broaden it by interpretation.
- Record the approver's role, verified identity where available, date, evidence, conditions and status. Never invent a name or qualification.
- Preserve withdrawn and superseded approvals as history; do not silently replace them.

## Decision classes

| Class | Agent authority | Required control |
|---|---|---|
| Repository inspection, analysis and draft documentation | May perform within access. | Cite evidence; label proposals. |
| Reversible implementation within an approved work package | May perform when explicitly authorized. | Tests, review and change record. |
| Architecture choice within an explicitly delegated technical scope | May recommend or decide within delegation. | ADR and evidence; do not expand scope. |
| Business workflow, policy, roles, approval limits or operational procedure | May analyze and propose. | Relevant business owner approval. |
| Accounting, costing, tax, financial posting or valuation | May analyze and model examples. | Qualified accountant/tax adviser and owner approval as applicable. |
| Pharmacy, clinical, licensing or regulated operational decision | May analyze and identify questions. | Qualified pharmacist/professional and owner approval. |
| Legal entity, contract interpretation or regulatory compliance | May research and identify evidence. | Qualified legal/regulatory adviser and owner approval. |
| Production deployment, destructive migration, sensitive-data access or irreversible external action | May prepare a controlled plan. | Explicit authorization, security/release gates and rollback/recovery plan. |

## Important distinction

Owner approval to develop a capability authorizes work only within the stated delivery scope. It does not automatically approve the detailed business rules, accounting treatment, legal/regulatory interpretation, professional procedures, security residual risk, operational activation or production release.

Professional sign-off and owner approval are separate gates when both are required. A professional reviewer validates matters within their remit; the owner decides whether the business adopts the proposed policy. Neither can be substituted by an AI agent or inferred from the other's approval.

If an approval is pending, agents may perform safe discovery, draft-only design and explicitly authorized non-posting implementation. They must keep the gated behavior disabled and must not create production stock movements, financial postings or other operational side effects.

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

## Pharmacy Inventory authorization

The project owner authorized staged Pharmacy Inventory implementation on 2026-11-14; see approval ID INV-OWN-001 in the central register and the linked owner authorization record. This supersedes the older blanket statement that no inventory implementation is authorized.

That authorization does not satisfy the separate pharmacist, Egyptian regulatory/legal, quality, accountant, security and release gates. Until each applicable gate is recorded as approved, implement only safe draft/non-posting capability and do not enable production operations. Check the central register and the delivery authorization record for the exact phase boundaries.
