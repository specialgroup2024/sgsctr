# Pharmacy transfer persistence design

- Status: **Logical proposal — not a migration or approved schema**
- Target: PostgreSQL; EF Core/Npgsql candidate.
- Domain: [pharmacy-transfer-domain-model.md](pharmacy-transfer-domain-model.md)

## 1. Relational model

| Table | Important columns | Notes |
|---|---|---|
| `legal_entities` | id, code, registered_name, status | Seed only after legal verification |
| `business_sectors` | id, legal_entity_id, code, name | Pharmacies sector ownership |
| `inventory_locations` | id, legal_entity_id, sector_id, code, name, type, active | Warehouse/branch; unique code per scope |
| `stock_items` | id, sector_id, sku, name, tracking_policy, active | Product master reference |
| `units_of_measure` | id, code, name, scale | Approved unit catalogue |
| `stock_lots` | id, stock_item_id, lot_code, expiry_date, status | Lot/expiry traceability |
| `stock_balances` | id, location_id, stock_item_id, lot_id, on_hand, reserved, version | Balance projection; unique location/item/lot |
| `stock_transfers` | id, reference, legal_entity_id, sector_id, source_location_id, destination_location_id, status, version, requested_by, created_at | Aggregate root |
| `stock_transfer_lines` | id, transfer_id, stock_item_id, unit_id, requested_qty | Requested line quantities |
| `stock_transfer_dispatches` | id, transfer_id, dispatched_by, dispatched_at, idempotency_key | Dispatch event header |
| `stock_transfer_dispatch_lines` | id, dispatch_id, transfer_line_id, lot_id, quantity | Lot-specific shipped quantities |
| `stock_transfer_receipts` | id, transfer_id, received_by, received_at, idempotency_key | Receipt event header |
| `stock_transfer_receipt_lines` | id, receipt_id, transfer_line_id, lot_id, accepted_qty, condition_code | Accepted quantities |
| `stock_transfer_discrepancies` | id, transfer_id, line_id, type, quantity, reason, status, resolved_by | Open/resolve trail |
| `stock_movements` | id, location_id, item_id, lot_id, movement_type, quantity_delta, transfer_id, occurred_at | Append-only ledger |
| `idempotency_records` | id, scope, key, request_hash, response_ref, created_at | Unique key per principal/operation scope |
| `audit_events` | id, actor_id, action, resource_type, resource_id, occurred_at, correlation_id, safe_metadata | Append-only audit |

This is a logical inventory only. Existing repository schema and naming conventions must be rechecked before implementation.

## 2. Constraints and indexes

- Primary keys on all entities; foreign keys for every ownership and lifecycle relationship.
- Unique `(legal_entity_id, sector_id, location_code)` or an equivalent approved location-code scope.
- Check `source_location_id <> destination_location_id`.
- Check quantities are positive for requested/dispatch/accepted facts; movement sign is determined by movement type and constrained separately.
- Unique balance key `(location_id, stock_item_id, lot_id)`; define null-lot uniqueness correctly (for example, use a normalized non-null lot key or PostgreSQL NULLS NOT DISTINCT where supported by pinned version).
- Index transfers by `(sector_id, status, created_at)`, source/destination plus status, reference, and line item.
- Unique idempotency key across principal + operation + key; store request hash to detect key reuse with different payload.
- Unique dispatch/receipt idempotency keys within their documented scope.
- Restrict deletes for referenced stock items, lots, locations, transfers and movements; use inactive/archived states.
- Enforce positive stock and allowed negative-stock exceptions in transaction logic plus database safeguards; a simple CHECK on a projection alone is insufficient for concurrent operations.
- Use FK constraints to ensure source and destination are in same legal entity/sector; consider composite keys or trigger/domain validation where standard FKs cannot express this.
- Add concurrency token (row version integer or xmin strategy after review) to mutable aggregate and balance projections.

## 3. Stock movement model

Represent movement events with explicit types, for example:
- `TRANSFER_OUT`: source location quantity decreases at dispatch.
- `TRANSFER_IN_TRANSIT`: quantity is held in transit under transfer custody.
- `TRANSFER_RECEIPT`: in-transit quantity decreases and destination quantity increases for accepted quantity.
- `TRANSFER_RETURN_OUT/IN`: controlled return movements.
- `TRANSFER_REVERSAL`: linked correction with reason and authorization.

Choose either a dedicated in-transit location/bucket per transfer or a transfer-custody ledger account. Do not count in-transit quantity as available stock at either physical location. Final representation must be selected with operations/accountant and tested for reconciliation.

## 4. Atomicity and concurrency

- Dispatch transaction writes dispatch event, movement ledger, balance projection, transfer state, audit event and outbox record together.
- Receipt transaction writes receipt, movement ledger, source in-transit reduction, destination balance increase, transfer state, audit and outbox together.
- Use PostgreSQL row locks or atomic conditional updates to protect available quantity; acquire balance locks in stable order to reduce deadlocks.
- Use aggregate version checks for stale commands.
- Enforce idempotency using unique constraints and persisted result references, not in-memory caches.
- Retry only transient database failures; do not automatically retry business conflicts.
- Build integration tests against real PostgreSQL for contention, rollback, idempotency and constraint behavior.

## 5. Data governance

- Tenant/entity and sector dimensions must be included in relevant queries and constraints.
- Avoid patient-identifying data in transfer records and audit metadata.
- Keep audit/movement tables append-only for application roles; privileged maintenance must be separately controlled and logged.
- Define retention, archival, backup, restore and period-close policy before production.
- Do not persist derived weighted-average cost or create GL journal entries until accountant-approved costing design exists.

## 6. Migration gates

Before writing EF Core migrations:
1. Confirm current repository code/schema and migration conventions.
2. Verify legal entity and authorized location register.
3. Approve transfer lifecycle and stock custody model.
4. Approve item/unit/lot/expiry rules.
5. Approve stock balance and in-transit representation.
6. Approve costing and financial boundary with accountant.
7. Approve authorization and separation-of-duties matrix.
8. Review migration, rollback/forward-fix and seed-data plan.

No schema migration or production data mutation is authorized by this proposal.
