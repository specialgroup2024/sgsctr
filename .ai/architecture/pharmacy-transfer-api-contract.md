# Pharmacy stock-transfer API contract

- Status: **Proposed contract — no endpoints implemented**
- API style: authenticated, versioned REST commands and read models.
- Base path proposal: `/api/v1/pharmacy/stock-transfers`.
- Domain model: [pharmacy-transfer-domain-model.md](pharmacy-transfer-domain-model.md)

## 1. API conventions

- Require authenticated identity and server-side authorization on every request.
- Derive user identity from validated authentication claims; never trust actor IDs supplied in request bodies.
- Use opaque IDs. Return stable error codes and correlation IDs.
- Use `ETag`/If-Match or an explicit expected version for concurrent edits and lifecycle commands.
- Require an `Idempotency-Key` for dispatch, receipt, return and other stock-affecting commands.
- Use UTC timestamps in ISO 8601; display localization belongs to clients.
- Use decimal strings in JSON for quantities where binary floating-point could alter exact values; publish item/unit precision rules after approval.
- Paginate list endpoints; enforce location/sector scope before returning data.
- Do not expose direct database access or generic balance-edit endpoints.
- Commands are explicit actions. No endpoint may set arbitrary status.

## 2. Proposed endpoints

| Method | Route | Purpose |
|---|---|---|
| GET | `/api/v1/pharmacy/stock-transfers` | Search transfers within authorized scope |
| POST | `/api/v1/pharmacy/stock-transfers` | Create draft |
| GET | `/api/v1/pharmacy/stock-transfers/{id}` | Transfer detail and event timeline |
| PUT | `/api/v1/pharmacy/stock-transfers/{id}` | Edit draft only, with expected version |
| POST | `/{id}/submit` | Submit for approval |
| POST | `/{id}/approve` | Approve with policy validation |
| POST | `/{id}/reject` | Reject with mandatory reason |
| POST | `/{id}/pick` | Record picked quantities/lots |
| POST | `/{id}/dispatch` | Commit dispatch and in-transit movements |
| POST | `/{id}/receipts` | Record full or partial receipt |
| POST | `/{id}/discrepancies` | Record discrepancy |
| POST | `/{id}/discrepancies/{discrepancyId}/resolve` | Resolve under approved authority |
| POST | `/{id}/returns` | Create linked return movement |
| POST | `/{id}/cancel` | Cancel only where policy permits |
| GET | `/{id}/events` | Read immutable lifecycle/movement timeline |

Exact endpoint naming and command granularity may change during implementation review.

## 3. Example create-draft request

```json
{
  "sourceLocationId": "uuid",
  "destinationLocationId": "uuid",
  "reasonCode": "REPLENISHMENT",
  "notes": "Branch replenishment",
  "lines": [
    {
      "stockItemId": "uuid",
      "unitOfMeasureId": "uuid",
      "requestedQuantity": "10",
      "lotAllocations": []
    }
  ]
}
```

The server assigns transfer ID/reference, requester, status and timestamps. The example is illustrative only; reason codes and whether lots are selected at request or picking require operations approval.

## 4. Example receipt command

```json
{
  "receivedAt": "2026-11-07T08:30:00Z",
  "lines": [
    {
      "transferLineId": "uuid",
      "stockLotId": "uuid",
      "acceptedQuantity": "7",
      "conditionCode": "ACCEPTED"
    }
  ],
  "notes": "Three units not received; discrepancy recorded separately"
}
```

Receiver identity is taken from the authenticated principal. Unreceived quantity remains in transit or follows an explicitly approved discrepancy state. A client cannot self-declare an unresolved balance as lost/closed.

## 5. Response and errors

Successful command responses return transfer ID, reference, current state, version, affected line quantities and correlation ID. Do not return unrelated location balances.

Stable error codes proposed:
- `TRANSFER_SOURCE_EQUALS_DESTINATION`
- `TRANSFER_LOCATION_NOT_AUTHORIZED`
- `TRANSFER_INVALID_STATE`
- `TRANSFER_APPROVAL_REQUIRED`
- `TRANSFER_INSUFFICIENT_STOCK`
- `TRANSFER_LOT_REQUIRED`
- `TRANSFER_QUANTITY_INVALID`
- `TRANSFER_VERSION_CONFLICT`
- `TRANSFER_IDEMPOTENCY_CONFLICT`
- `TRANSFER_SEPARATION_OF_DUTIES`
- `TRANSFER_DISCREPANCY_UNRESOLVED`

Map errors to appropriate HTTP semantics (400/401/403/404/409/422) without leaking whether unauthorized resources exist.

## 6. Authorization policy

Enforce policy at application service boundary and query boundary:
- Create/edit: transfer-request permission and source/destination location scope.
- Submit: submit permission and access to both locations.
- Approve/reject: approve permission, location scope, approval threshold and separation-of-duties checks.
- Pick/dispatch: dispatch permission at source location.
- Receive: receive permission at destination location and custody/separation checks.
- Resolve discrepancy/return/cancel: dedicated permission and approved limits.
- Read/list: permission for all requested locations; apply row-level filtering in server queries.

Use capabilities rather than hard-coded job titles. Deny by default. The final role-to-permission mapping and same-user restrictions require owner/operations approval.

## 7. Security and reliability

- Validate DTOs and business rules server-side.
- Protect state-changing requests against replay and duplicate delivery with durable idempotency records.
- Use optimistic concurrency for edits and lifecycle state; use database concurrency control for stock.
- Rate-limit authentication-sensitive and high-volume endpoints.
- Audit success and denial outcomes with actor, action, resource, timestamp, correlation ID and safe reason.
- Never log tokens, secrets, patient identifiers or full sensitive request payloads.
- Return generic authorization failures where resource enumeration is a concern.
- Publish OpenAPI only for implemented and reviewed endpoints; contract tests must verify authorization and error behavior.

## 8. Not yet specified

Authentication provider, token claims, exact role assignments, API hosting, request size limits, attachment storage, reason-code catalogue, quantity precision, versioning policy and approval limits remain open. No endpoint should be considered live until implemented, tested and documented.
