# Pharmacy stock-transfer technical design (proposed)

- Status: **Draft — not approved for production implementation**
- Scope: non-posting technical design for internal pharmacy location transfers.
- Inputs: [operational workflow](../domain/pharmacy-stock-transfer-workflow.md), [acceptance criteria](../quality/pharmacy-stock-transfer-acceptance.md), [system context](system-context.md).
- Owner-confirmed capability: Mokattam warehouse ↔ branches and direct branch ↔ branch.
- Excludes: production inventory posting, valuation, journals, tax, and any policy not yet approved.

## 1. Design goals and boundaries

- Model a transfer as a controlled movement of custody between two distinct inventory locations.
- Preserve separate location balances and a first-class in-transit balance.
- Treat branch-to-branch as a direct route; do not create an artificial Mokattam leg.
- Expose use cases through authenticated, versioned ASP.NET Core APIs. Clients never write directly to PostgreSQL.
- Keep Pharmacy module ownership of transfer state and inventory movement. Finance owns approved valuation and posting policies.
- Use a modular-monolith boundary initially; no microservice or distributed transaction is required by current evidence.

## 2. Proposed application components

- **Transfer command handler:** validates command, actor permissions, transfer state and policy.
- **Transfer domain model:** enforces allowed state transitions and quantity invariants.
- **Inventory availability service:** obtains eligible source quantities by item and lot; does not reserve or deduct stock merely because a draft exists.
- **Movement ledger:** records immutable dispatch, receipt, return and approved correction events.
- **Audit writer:** records actor, action, outcome, timestamp, correlation and entity references.
- **Outbox publisher (if asynchronous integration is introduced):** commits event intent in the same database transaction and publishes idempotently.
- **Query handlers:** return transfer details, location balances, in-transit balances and history subject to location-scoped authorization.

These are logical responsibilities, not a mandate for separate deployables or packages.

## 3. API command surface (proposed)

Use a consistent versioned route prefix such as `/api/v1/pharmacy/transfers`. Exact naming and API conventions must be reconciled with repository-wide conventions before coding.

| Operation | Proposed endpoint | Effect |
|---|---|---|
| Create draft | `POST /api/v1/pharmacy/transfers` | Creates a draft; no stock effect |
| Edit draft | `PUT /api/v1/pharmacy/transfers/{id}` | Edits only while policy permits |
| Submit | `POST /{id}/submit` | Validates and submits; no stock deduction |
| Approve | `POST /{id}/approve` | Records authorized decision |
| Reject | `POST /{id}/reject` | Requires reason; no stock effect |
| Record picking | `POST /{id}/pick` | Records actual picked quantities/lots; no dispatch yet |
| Dispatch | `POST /{id}/dispatch` | Atomic source-to-in-transit movement |
| Receive | `POST /{id}/receive` | Atomic accepted in-transit-to-destination movement |
| Resolve discrepancy | `POST /{id}/discrepancies/{discrepancyId}/resolve` | Applies only an approved resolution |
| Return | `POST /{id}/return` | Creates linked return movement; never erases original events |
| Cancel | `POST /{id}/cancel` | Allowed only in policy-approved states |
| Read | `GET /{id}` | Returns authorized transfer details/history |
| List | `GET /api/v1/pharmacy/transfers` | Filters by authorized locations, status and date |

Commands should carry a client-generated idempotency key and a concurrency/version token where appropriate. Use stable error codes for invalid state, insufficient eligible stock, forbidden location, stale version, duplicate command and unresolved policy gate. Do not expose stock details to unauthorized callers.

## 4. Conceptual domain records

Names below are logical concepts, not approved physical table names.

- **InventoryLocation:** ID, legal-entity reference, sector, location type, active status and operational metadata.
- **StockTransfer:** ID/reference, source and destination IDs, status, reason, creator, timestamps, version and optional external document reference.
- **StockTransferLine:** item ID, unit, requested quantity, picked quantity and references to lot allocations.
- **TransferLotAllocation:** item/lot/batch, expiry where applicable, unit and picked/dispatched/received quantities.
- **TransferEvent:** immutable event ID, transfer ID, event type, actor, timestamp, command/idempotency reference and event data.
- **InventoryMovement:** immutable quantity movement with item, location or in-transit account, signed quantity, unit, lot, source document and event reference.
- **TransferDiscrepancy:** line/lot, expected and actual quantities, discrepancy type, reason, evidence reference, resolver and resolution event.
- **AuditEvent:** actor, action, resource, outcome, timestamp, correlation ID and safe before/after references.

All records require stable IDs and tenant/legal-entity/sector scoping consistent with the approved company model. Avoid duplicating mutable balance values as the sole source of truth; define balance projections from authoritative movements and reconciliation controls during detailed data design.

## 5. State and quantity model

Proposed high-level states: Draft → Submitted → PendingApproval → Approved/Rejected → Picking → Dispatched/InTransit → PartiallyReceived/Received → Closed. Cancellation and return are controlled transitions or linked movements, not deletion. Final state names and transition rules require operations approval.

- Draft/submitted/approved/picking do not change on-hand stock unless a separately approved reservation policy is introduced.
- Dispatch transaction: validate current state and available eligible quantities; record dispatch event; decrease source available/on-hand per approved stock model; increase in-transit quantity; update transfer state; write audit event.
- Receipt transaction: validate dispatched balance; record accepted quantities by line/lot; decrease in-transit quantity; increase destination on-hand; record remaining in-transit quantity and discrepancies; write audit event.
- A partial receipt leaves the unaccepted balance in transit or in an explicitly controlled discrepancy state.
- No quantity may be created, lost or moved between locations without a corresponding immutable movement/event.
- Return, damage, expiry, recall and adjustment effects require approved policy and linked movement records.

## 6. Transaction, concurrency and idempotency

- Dispatch and receipt each execute in one database transaction covering transfer state, movement rows, balance projection updates (if used), audit event and outbox row (if used).
- Protect competing dispatches using row-level locking or optimistic concurrency plus a conditional stock-availability update; select one consistent approach in the implementation spike.
- Enforce database uniqueness for idempotency scope/key and immutable event identity.
- Same key and same request returns the original outcome; same key with a different payload returns a conflict.
- Use a transfer version/ETag or equivalent to reject stale commands.
- Never rely on client-side validation for stock, authorization or state.
- Add reconciliation queries/tests for location and in-transit balances. Define operational repair procedures before production.

## 7. Authorization, privacy and audit

- Authorize every command and query on the server, scoped to legal entity, sector, source/destination location and action.
- Permission capabilities should distinguish request, approve, pick/dispatch, receive, resolve discrepancy, return and administer locations.
- Enforce separation of duties only after the owner-approved role matrix is recorded; keep policy configurable rather than inventing job titles.
- Record denied access and state-changing outcomes without leaking protected stock details.
- Never include patient-identifying data, credentials or secrets in transfer descriptions, audit payloads, telemetry or fixtures.
- Historical movement and audit events are append-only at the application boundary; database privileges and operational controls must prevent ordinary application users from rewriting them.

## 8. Test implementation map

- Domain tests: allowed transitions, same-location rejection, quantity conservation, partial receipt and immutable history.
- Application tests: permissions, approval gates, rejection reasons, discrepancy resolution and idempotency.
- PostgreSQL integration tests: concurrent dispatch, transaction rollback, unique idempotency key and reconciliation.
- API tests: authentication, location scoping, version conflicts, stable error contracts and sensitive-data redaction.
- End-to-end tests: warehouse↔branch and direct branch↔branch flows, including partial receipt and return.
- Map each test to AT-01 through AT-21 in the acceptance document; do not mark a criterion passed until CI evidence exists.

## 9. Decisions required before production implementation

1. Pharmacy operations approves lifecycle, state transitions, custody, roles, approval limits, lot/expiry rules and exception paths.
2. Accountant approves weighted-average costing level/timing and worked examples for dispatch, receipt, partial receipt, discrepancy, return, adjustment and period close.
3. Business owner approves authority matrix, separation-of-duties exceptions and emergency process.
4. Legal/pharmacy professionals verify applicable site/product requirements.
5. Technical owner confirms framework/runtime/database versions, repository API conventions, migration approach, concurrency strategy, audit retention and deployment requirements.

Until these approvals are recorded, do not implement production stock-changing commands, migrations, valuation or ledger posting. Safe preparatory work is limited to review, test design and non-posting prototypes with synthetic data.
