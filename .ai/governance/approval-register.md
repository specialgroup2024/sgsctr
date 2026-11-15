# Central approval register

Status: authoritative index of project approvals and their evidence.
Last updated: 2026-11-15.

## Purpose and authority

This register distinguishes permission to perform work from approval of the decisions and outcomes produced by that work. A project-owner authorization to develop a capability does **not** approve every business rule, professional interpretation, technical design, production release or operational transaction within that capability.

The register is an index. The linked decision, requirement, review or evidence record is the detailed source of truth. A chat message or pull-request comment is not, by itself, a durable project approval unless it is captured here or in a linked controlled record.

## Approval statuses

- **Approved** — the named authority approved the precisely stated scope, supported by recorded evidence.
- **Approved with conditions** — approval is limited by explicit conditions; work outside them is not approved.
- **Pending** — requested but no sufficient approval evidence is recorded.
- **Rejected** — explicitly not approved; retain rationale and date.
- **Withdrawn** — previously approved, then withdrawn by the authority.
- **Superseded** — replaced by a later recorded decision; preserve the history.
- **Not required** — documented reason why this approval class does not apply.

Never infer approval from silence, a merged PR, an agent recommendation, a passing test, a draft ADR or approval of a broader work package.

## Approval classes and required evidence

| Class | Who can approve | Minimum record |
|---|---|---|
| Owner / business scope | Project owner or formally delegated business owner | Scope, exclusions, authority, date, conditions and evidence |
| Business rule / workflow | Relevant business owner | Exact rule, affected process, rationale and effective scope |
| Pharmacy / clinical operations | Qualified pharmacist or authorized pharmacy professional | Reviewer role/qualification, exact operational decision, evidence and date |
| Regulatory / legal | Qualified Egyptian regulatory or legal professional within remit | Instrument/version, applicability analysis, exact conclusion, limitations and date |
| Quality | Designated qualified quality reviewer | Quality procedure/control, acceptance criteria and disposition |
| Accounting / costing / tax | Qualified accountant or tax adviser within remit | Policy, worked examples, assumptions, treatment and date |
| Architecture / technical | Delegated technical authority; owner where scope/impact requires | ADR, alternatives, risks, decision and validation evidence |
| Security / privacy | Designated security/privacy reviewer; owner for residual risk acceptance | Findings, severity, remediation, residual risk and explicit acceptance |
| Release / production | Authorized owner/release authority plus all applicable professional gates | Tested release candidate, migration/recovery plan, sign-offs and release authorization |

A person’s name must not be invented. Where identity or qualification evidence is unavailable, record the role as unverified and keep the approval pending.

## Current recorded approvals

| ID | Subject | Authority | Status | Evidence / scope |
|---|---|---|---|---|
| INV-OWN-001 | Pharmacy Inventory delivery authorization | Project owner | **Approved** | Owner authorization recorded 2026-11-14 in [Pharmacy Inventory owner authorization](../delivery/pharmacy-inventory-owner-authorization-and-execution.md), PR #38. Authorizes staged implementation across database, API, UI, tests and governance. Does not approve professional decisions or production use. |
| INV-OWN-003 | Non-operative supplier onboarding intake | Project owner | **Approved with conditions** | Owner approved in chat on 2026-11-15: capture supplier-declared legal identity/licence metadata as OwnerProvided / Unverified; create Pending due-diligence intake cases; capture department-level business email, business phone/switchboard and business website only. No named-person contact data, legal/licence verification, qualification/approval decisions, reviewer authority grants, purchasing/receiving eligibility, stock/financial posting or production deployment. See [implementation deliberation](../roles/invb-supplier-draft-onboarding-implementation-deliberation.md). |

## Pharmacy Inventory — separate gates

The following are **not approved by INV-OWN-001**. Keep them pending until the relevant qualified reviewer and owner decision are recorded with evidence:

| ID | Approval required | Status | Scope / linked record |
|---|---|---|---|
| INV-PRO-001 | Pharmacist / pharmacy-operations approval | **Pending** | Product-family applicability, lot/expiry/serial controls, FEFO, receipt, quarantine, recall, returns and operational exceptions remain pending qualified review. No verified pharmacist decision or supporting evidence has been recorded. |
| INV-REG-001 | Egyptian regulatory / legal approval | Pending | Site/operator licensing, product-specific EDA/EPTTS obligations, retention and legal applicability. See evidence register and dated regulatory scans. |
| INV-QLT-001 | Quality approval | Pending | Inspection, storage evidence, deviations, rejection/quarantine, recall and disposition. |
| INV-ACC-001 | Accountant approval | Pending | Moving weighted-average valuation pool, timing, transfers, returns, losses, expiry, adjustments, rounding, tax and period close. |
| INV-OWN-002 | Owner approval of operating policies | Pending | Supplier qualification, purchasing limits, separation of duties, adjustment authority, opening-stock cutover and production release. |
| INV-SEC-001 | Security review and residual-risk acceptance | Pending | Server-side access controls, separation of duties, audit integrity, privacy and production security. |
| INV-REL-001 | Controlled production release | Pending | End-to-end acceptance, professional sign-offs, migration rehearsal, recovery, opening-stock reconciliation and explicit release authorization. |

## Application tracking

The application approval register is implemented as a read-only, PostgreSQL-backed view in the Pharmacy Inventory workspace:

- UI: `/pharmacies/inventory` → **Approvals**.
- BFF: `GET /api/pharmacy/approvals`.
- ASP.NET Core API: `GET /api/v1/pharmacy/catalogue/approvals` (authenticated).
- Persistence: `GovernanceApprovals` table, introduced by migration `20261114170000_GovernanceApprovalRegister`.
- The migration seeds INV-OWN-001 as Approved and INV-PRO-001 plus INV-REG-001 through INV-REL-001 as Pending.
- Historical demo migrations `20261115090000_SeedPharmacistApprovalDemo` and `20261115103000_PharmacyApprovalDemoStatus` introduced the synthetic `DemoApproved` state. PR #47 merged forward correction migration `20261115120000_RemovePharmacistApprovalDemo`, which restores `INV-PRO-001` to Pending only when its status is the synthetic `DemoApproved` and removes that value from the database constraint. A deployed database is not corrected until this migration is applied and verified.

A separate [Governance test-readiness workspace](../delivery/governance-test-readiness-workspace.md) tracks platform and gate test cases in PostgreSQL. Test execution records are not approval decisions and cannot change any status in this register. The test-result write endpoint is restricted to Development and Administrator; cases blocked by an approval or unimplemented workflow cannot be marked Passed or Failed.

Illustrative pharmacist review examples supplied by the owner are documented separately in [Pharmacist review examples — proposed/demo only](../delivery/pharmacy-inventory-pharmacist-review-examples.md). They are not `GovernanceApprovals` rows, do not appear in the authoritative API response, and do not change INV-PRO-001 from Pending.

The first application increment intentionally does not provide a decision-write endpoint. It cannot promote a Pending item to Approved, Rejected or another terminal state. Reviewer identity, professional qualification, delegated authority and server-side role separation must be designed and verified before decision entry is enabled. Update this document and the database together when an approval is later recorded.

## How to record a new approval

1. Create or update the detailed source record (ADR, requirement decision, professional review, security review or release record).
2. State the exact decision and boundaries; separate approved items from pending questions.
3. Record the approver's role and name only when supplied/verified, date, evidence, conditions and review/expiry date where applicable.
4. Add a unique approval ID here and link the detailed record and supporting evidence.
5. Update related requirements, ADR status, open questions and delivery gates consistently.
6. Preserve prior entries when an approval is withdrawn or superseded; never silently overwrite the decision history.

## Mandatory agent behavior

Before implementing or enabling a capability, agents must check this register and the linked detailed records. If the required approval is pending, agents may perform safe discovery, draft-only design and non-posting implementation where explicitly authorized, but must not enable the gated operational behavior. Agents cannot act as the professional approver. A PR merge or CI pass does not change an approval status.
