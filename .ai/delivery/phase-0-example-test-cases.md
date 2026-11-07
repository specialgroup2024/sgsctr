# Phase 0 example test cases

These are scenario outlines, not executable tests or approved calculation specifications. Expected numeric results remain intentionally undefined until reviewed worked examples are signed off.

## Contracting
- CT-01: Draft estimate cannot become an approved project baseline without required scope, version and approval evidence.
- CT-02: Unapproved variation does not alter the signed contract or approved baseline.
- CT-03: Purchase request above a user's authority is routed to an authorized approver.
- CT-04: Progress evidence, review and certification remain separately traceable.
- CT-05: Project close is blocked while required supplier, subcontractor or customer reconciliations remain open.

## Pharmacy inventory
- PH-01: Receiving captures product, quantity, supplier, location and required batch/expiry data.
- PH-02: A quarantined item cannot be made available for dispensing before authorized release.
- PH-03: Transfer records preserve source, destination, lot identity and acknowledgement.
- PH-04: Expired or recalled stock is blocked from issue and appears in exception reporting.
- PH-05: Returns and adjustments require reason, source reference and approval according to policy.

## Weighted-average costing
- WA-01: A receipt changes the applicable average only according to the accountant-approved timing and valuation basis.
- WA-02: Supplier return treatment follows the approved original-cost/return policy.
- WA-03: Branch transfer preserves approved source valuation and does not create an unauthorized gain or loss.
- WA-04: Stock adjustment records the approved valuation treatment and reason.
- WA-05: Historical valuation can be reconstructed from immutable movements and policy version.
- WA-06: Precision, rounding, negative stock and late-dated corrections follow explicitly approved examples.
- Expected numeric values: **blocked pending accountant-approved worked examples**.

## Claims and payer agreements
- CL-01: Claim selects the correct agreement version and eligible-item rules for the service date.
- CL-02: Discount, payer coverage, patient copay and exemption are stored as distinct rule inputs.
- CL-03: Rejection preserves the original submission and reason; resubmission creates a traceable revision.
- CL-04: Partial approval and adjustment preserve submitted and approved amounts separately.
- CL-05: Remittance is matched to the relevant payer receivable; unmatched differences enter review.
- Numeric claim outcomes: **blocked pending signed agreement examples and accountant approval**.

## Patient balances and collections
- PB-01: Patient responsibility is recorded separately from payer receivable.
- PB-02: Full exemption is applied only when an effective approved agreement explicitly authorizes it.
- PB-03: A later collection reduces the correct patient balance and creates a receipt/audit event.
- PB-04: Partial payment leaves a traceable residual balance under approved policy.
- PB-05: Refund, reversal, dispute and write-off require the configured authority and evidence.
- Numeric balances, allocations, aging and write-off outcomes: **blocked pending approved policy examples**.

## Test governance
Every eventual executable test must cite the approved example ID, agreement/policy version, currency, precision, rounding rule, expected result and approving owner. Use synthetic data only. No test fixture may be treated as authority for a production rule.
