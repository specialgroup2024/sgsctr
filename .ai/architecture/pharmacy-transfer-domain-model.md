# Pharmacy transfer domain model

- Status: **Technical proposal — not approved for production**
- Context: .NET modular-monolith direction; PostgreSQL persistence; API-only access.
- Business workflow: [pharmacy-stock-transfer-workflow.md](../domain/pharmacy-stock-transfer-workflow.md)
- Acceptance criteria: [pharmacy-stock-transfer-acceptance.md](../quality/pharmacy-stock-transfer-acceptance.md)

## 1. Aggregate boundary

Use a **StockTransfer aggregate** as the consistency boundary for a single source-to-destination transfer. It owns its transfer lines, lifecycle state, dispatch/receipt records and discrepancy records. Inventory balance changes are committed atomically with the corresponding immutable stock-movement records.

The aggregate must not own or directly modify another module's tables. It calls the Pharmacy Inventory application service within the same transaction boundary. Financial valuation and ledger posting are separate capabilities and remain disabled until accountant approval.

## 2. Core concepts

| Concept | Responsibility |
|---|---|
| LegalEntity | Verified statutory entity boundary; provisional LE-01 only |
| BusinessSector | Pharmacies Sector ownership and authorization dimension |
| InventoryLocation | Warehouse or branch with active status and location identity |
| StockItem | Product identity and stock-control policy |
| StockLot | Batch/lot, expiry and item-specific traceability |
| StockBalance | Quantity by location, item and lot; available/reserved/in-transit as approved |
| StockTransfer | Request, source, destination, requester, status and lifecycle metadata |
| StockTransferLine | Item, unit, requested and picked quantities |
| TransferDispatch | Dispatch event, actor, timestamp and shipped quantity by line/lot |
| TransferReceipt | Receipt event, receiver, timestamp and accepted quantity by line/lot |
| TransferDiscrepancy | Shortage, overage, damage, wrong item/lot or unresolved quantity |
| StockMovement | Append-only inventory movement ledger |
| IdempotencyRecord | Prevent duplicate command effects |
| AuditEvent | Security/business audit record, separate from mutable operational state |

## 3. Aggregate identifiers and invariants

- Use stable opaque identifiers (UUID recommended) for locations, transfers, lines, lots and movement records.
- Transfer reference is human-readable and unique within the approved legal-entity/sector numbering scope; numbering policy remains open.
- Source and destination must be different active locations within the same authorized sector and verified legal entity.
- A transfer line references one stock item and valid unit. Lot-controlled items require lot/expiry traceability according to item policy.
- Quantities use exact decimal/numeric representation; permitted scale and unit conversion rules require pharmacy/accountant approval.
- Requested, picked, dispatched, accepted and discrepancy quantities are distinct facts. Do not overwrite one quantity with another.
- StockMovement records are append-only. Corrections use linked reversal or adjustment movements.
- No direct mutation of balance without a corresponding movement record in the same transaction.

## 4. State machine proposal

`Draft → Submitted → PendingApproval → Approved | Rejected`

`Approved → Picking → ReadyToDispatch → Dispatched → InTransit`

`InTransit → PartiallyReceived → Received → Closed`

Exceptional transitions: `Draft/Submitted/Approved → Cancelled`; dispatched transfers use `Discrepancy`, `ReturnInitiated`, `Returned` or approved closure paths. Exact states/transitions must be approved by operations. Do not infer that every state is mandatory or permit arbitrary status updates.

Commands, not generic status PATCH requests, drive transitions. Each command validates the current state and actor permission.

## 5. Domain services and responsibilities

- TransferRequestService: create draft, add/update lines before submission, submit.
- TransferApprovalService: approve/reject with reason and policy checks.
- TransferDispatchService: validate picked quantities and stock; create dispatch + in-transit movements atomically.
- TransferReceiptService: record accepted quantities, lot details and partial receipt.
- TransferDiscrepancyService: open, investigate and resolve exceptions with evidence and authorized decision.
- TransferReturnService: create linked return movement; never erase dispatch history.
- StockAvailabilityService: read eligible stock using concurrency-safe rules.
- TransferAuthorizationService: enforce user, sector, location and separation-of-duties policy.
- AuditPublisher: persist audit event in transaction; outbox may deliver external notifications.

## 6. Transaction boundaries

Dispatch transaction:
1. Load transfer and lines with concurrency token.
2. Re-check state, permissions, item/lot eligibility and available stock.
3. Lock or atomically condition-update affected balance rows in deterministic key order.
4. Create dispatch event and source-to-transit stock movements.
5. Update transfer state and append audit/outbox events.
6. Commit all or roll back all.

Receipt transaction:
1. Load transfer and outstanding in-transit quantities.
2. Validate receiver and lot/item/quantity.
3. Atomically move accepted quantity from in-transit to destination.
4. Record receipt and any discrepancy without silently clearing outstanding quantity.
5. Update state, audit and outbox records; commit atomically.

Isolation/locking strategy must be proven with concurrent integration tests on PostgreSQL. Do not rely on UI validation for stock protection.

## 7. Decisions still required

Operations: transfer state names, picking model, approval thresholds, custody, emergency process, discrepancy and return policy, controlled/temperature-sensitive products, units and lot rules.

Accountant: weighted-average valuation timing, treatment of in-transit goods, returns, losses, adjustments, precision, rounding and period close.

Owner/legal: verified entity/site register, location authority, role ownership and legal/pharmacy requirements.

Until these are approved, this model is a design artifact only; do not enable stock posting or production migrations.
