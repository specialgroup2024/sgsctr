# Pharmacy stock-transfer workflow (proposed)

- Status: **Draft for pharmacy-operations and accountant approval**
- Scope: internal transfers among authorized Pharmacies Sector locations.
- Owner-confirmed routes: Mokattam warehouse ↔ branches and direct branch ↔ branch.
- This document defines a testable proposal; it does not authorize production inventory posting.

## 1. Locations and boundary

Initial owner-reported locations:
- Mokattam — main warehouse.
- Student Hospital branch.
- Qasr El-Aini Hospital branch.
- Manial Hospital branch.

Treat each as a separately accountable inventory location under the provisional Pharmacies Sector/legal-entity model. Validate the complete site register, legal operator, licence holder and stock custodian before production setup.

A transfer between locations of the same verified legal entity is an internal stock movement, not a sale or intercompany transaction. Both source and destination must be active, authorized locations.

## 2. Proposed lifecycle

1. **Draft** — requester selects source, destination, item lines, units, requested quantities and reason.
2. **Submitted** — system validates distinct source/destination, active locations, item eligibility and required lot/expiry data.
3. **Pending approval** — authorized approver reviews availability, destination and policy limits.
4. **Approved / Rejected** — rejection requires a reason; an approved request becomes eligible for picking.
5. **Picking** — dispatcher records actual picked quantities and lot/batch/expiry details. Picking does not silently alter stock.
6. **Dispatched** — an authorized dispatcher confirms handover. The source quantity is relieved from available stock and represented as in-transit stock against the transfer. It must not remain available at source.
7. **In transit** — custody and dispatch/expected-arrival details remain visible. The transfer cannot be treated as received merely because it was dispatched.
8. **Partially received / Received** — receiver records accepted quantities by line and lot, actual receipt time and any discrepancy. Accepted quantities become destination stock; unreceived quantities remain in transit or enter an approved discrepancy process.
9. **Closed** — all quantities are accounted for and discrepancies are resolved or formally accepted under policy.
10. **Cancelled / Returned** — only through controlled actions and before/after dispatch according to policy. A dispatched transfer must not be erased; use a return movement or approved reversal.

Statuses and transitions are proposed. Pharmacy operations must approve final names, transitions and exception paths.

## 3. Required transfer record

- Immutable transfer ID/reference and document version.
- Source and destination location IDs.
- Item/product identifier, requested/picked/dispatched/received quantities and unit.
- Unit-of-measure conversion evidence where applicable.
- Batch/lot and expiry for lot-controlled products.
- Request reason and supporting reference/attachment where required.
- Requester, approver, picker/dispatcher and receiver identities.
- Submitted, approved, picked, dispatched and received timestamps.
- Status, rejection/cancellation/return reason and discrepancy resolution.
- Audit events recording actor, action, timestamp and before/after references.

Never store patient-identifying information in transfer descriptions or general logs unless a separately approved use case requires it.

## 4. Stock and transaction invariants

- Source and destination must differ and belong to the authorized Pharmacies Sector scope.
- Quantities must be positive and expressed in valid units; reject invalid conversions.
- Prevent dispatch beyond eligible source stock, except through a separately approved and audited exception policy.
- At dispatch, atomically decrease source available/on-hand according to the approved stock model and increase in-transit quantity.
- At receipt, atomically decrease in-transit by accepted quantity and increase destination on-hand by accepted quantity.
- Partial receipt leaves the balance explicitly in transit or in a controlled discrepancy state; never silently write it off.
- Retries of the same dispatch/receipt command must be idempotent and must not double-post.
- Completed movement history is immutable. Corrections use linked reversal/adjustment/return records.
- Concurrent transfers must not overspend the same stock; use database transactions and concurrency protection.
- Location balances and movement history must reconcile. Do not infer valuation or general-ledger posting from quantity movement alone.

## 5. Roles and separation of duties

Proposed permissions are distinct capabilities, not assumed job titles:
- Request transfer.
- Approve/reject transfer.
- Pick and dispatch.
- Receive and confirm discrepancy.
- Resolve discrepancy / authorize return.
- View location stock and audit history.
- Administer location and role assignments.

Enforce authorization on the server for every command. Scope access by sector and authorized locations. Apply configurable separation of duties; at minimum, policy must decide whether requester may approve, dispatcher may receive, and approver may receive. Do not hard-code a same-user exception before approval.

## 6. Exceptions requiring approved procedures

- Partial or zero receipt; shortage, overage, damage or wrong item/lot.
- Lost, delayed or damaged in-transit stock.
- Expired, recalled, temperature-sensitive or controlled products.
- Destination refusal, return to source or onward return to another location.
- Cancellation before dispatch versus after dispatch.
- Emergency transfer and retrospective authorization.
- Stock count adjustment while a transfer is open.
- Network interruption, duplicate submission and device retry.
- Negative stock, unavailable lot, unit conversion and concurrent dispatch.
- Transfer reversal and period-close handling.

Each exception must preserve original events, identify an authorized resolver, record evidence/reason and avoid silent balance edits.

## 7. Accounting and valuation boundary

The workflow records physical custody and quantities. It does not define weighted-average costing, transfer valuation, posting timing, journals, tax treatment or statutory reporting. The accountant must approve worked examples for dispatch, receipt, partial receipt, discrepancy, return, adjustment and period close before any valuation or financial posting is implemented.

## 8. Approval gates before implementation

- Pharmacy operations approves lifecycle, custody, roles, approval limits, lot/expiry rules and exception handling.
- Accountant approves costing impact, valuation, posting and reconciliation examples.
- Business owner approves operational authority and any emergency/segregation exceptions.
- Legal/pharmacy professionals verify site and product regulatory requirements where applicable.
- Technical design then specifies API commands, persistence constraints, audit schema, concurrency and migration strategy.

Until these approvals are recorded, implement documentation and non-posting prototypes only; do not enable production stock movement.
