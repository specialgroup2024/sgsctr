# Pharmacy stock-transfer acceptance criteria

- Status: **Proposed; pending pharmacy-operations, accountant and owner approval**
- Related workflow: [pharmacy-stock-transfer-workflow.md](../domain/pharmacy-stock-transfer-workflow.md)
- Test level: domain/application, API authorization, persistence/concurrency and end-to-end.
- These criteria specify expected behavior; no implementation or test execution is claimed.

## Core routes

### AT-01 — Warehouse to branch
Given an approved transfer from Mokattam to an active branch, when an authorized dispatcher dispatches eligible quantities and the branch receiver confirms receipt, then source, in-transit and destination quantities reflect each event exactly once and the movement trail links all events.

### AT-02 — Branch to warehouse
Given an approved transfer from a branch to Mokattam, when it is dispatched and received, then the same controls apply in the reverse direction.

### AT-03 — Direct branch to branch
Given an approved transfer from Student Hospital to Qasr El-Aini or Manial Hospital, when dispatched and received, then it completes without creating an intermediate Mokattam movement. The same must work for any authorized branch pair.

### AT-04 — Distinct locations
Given a transfer whose source equals its destination, when submitted, then it is rejected with a validation error and no stock movement is created.

## Quantity, lots and receipt

### AT-05 — Insufficient stock
Given eligible source stock below the requested dispatch quantity, when dispatch is attempted, then dispatch is blocked unless an approved, permissioned exception policy explicitly allows it; no negative balance is created by default.

### AT-06 — Lot and expiry traceability
Given a lot-controlled item, when it is picked and dispatched, then lot/batch and expiry are mandatory and preserved through receipt and location ledger history.

### AT-07 — Partial receipt
Given 10 units dispatched and 7 accepted at destination, when the receiver confirms 7, then 7 enter destination stock and 3 remain explicitly in transit or in a pending discrepancy state. The transfer cannot close until the remainder is resolved under policy.

### AT-08 — Discrepancy
Given a shortage, overage, damage or wrong lot, when the receiver records it, then the system captures the actual accepted quantity, reason, actor, timestamp and evidence reference; unresolved quantity is not silently discarded or added.

### AT-09 — Return after dispatch
Given a dispatched transfer, when goods must return, then a linked return movement is recorded. The original dispatch and receipt events remain visible and immutable.

## Authorization and audit

### AT-10 — Unauthorized location
Given a user without access to the source or destination location, when they request, approve, dispatch, receive or inspect a restricted transfer, then the server denies the operation and records a security-relevant audit event without exposing protected stock details.

### AT-11 — Separation of duties
Given the approved role policy prohibits self-approval or self-receipt, when the same user attempts the prohibited combination, then the command is denied. The rule is configurable only through an approved policy decision.

### AT-12 — Immutable history
Given a completed movement, when a user attempts to edit or delete its historical quantities or actors, then the operation is denied; corrections require linked reversal/adjustment records.

### AT-13 — Audit completeness
Given each lifecycle command, then the audit trail records actor, action, timestamp, transfer reference and outcome, and links the resulting stock movement.

## Reliability and concurrency

### AT-14 — Idempotent dispatch
Given a dispatch command with an idempotency key, when the same command is retried, then it creates one dispatch and one stock effect only.

### AT-15 — Idempotent receipt
Given a receipt command with an idempotency key, when retried after a timeout, then destination stock is increased once only.

### AT-16 — Concurrent dispatch
Given two transfers competing for the same available stock, when both dispatch concurrently, then database concurrency controls prevent aggregate dispatch from exceeding eligible stock.

### AT-17 — Atomic failure
Given a failure during dispatch or receipt persistence, when the transaction rolls back, then neither a partial stock balance change nor a misleading completed transfer state remains.

### AT-18 — Reconciliation
Given a set of transfers, then opening balance plus receipts, accepted transfers in, returns in and approved adjustments, less issues, dispatches out, returns out and other approved movements reconciles to each location's closing quantity. In-transit quantity reconciles separately.

## Non-functional and safety checks

### AT-19 — Sensitive data minimization
Given transfer audit/log events, then no patient-identifying data or secrets are emitted in general logs or test fixtures.

### AT-20 — API boundary
Given a mobile or web client, then it can invoke transfer use cases only through authenticated, versioned server APIs; clients cannot write directly to PostgreSQL.

### AT-21 — Observability
Given a failed or rejected command, then logs/metrics expose a correlation reference and safe failure category without leaking sensitive data.

## Approval-dependent tests

Before implementation, pharmacy operations and the accountant must provide approved examples and expected results for:
- Weighted-average costing and valuation timing at dispatch/receipt.
- Partial receipt and unresolved in-transit valuation.
- Damage, expiry, recall, return, reversal and stock adjustment.
- Emergency transfer, negative-stock exception and separation-of-duties override.
- Period close and reconciliation between location, sector and company controls.

Do not mark these acceptance criteria as approved or passing until named approvers sign off and automated tests execute in CI.
