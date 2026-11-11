# Pharmacy workflow draft

Status: discovery model only; pharmacy leadership and accountant must approve procedures.

## Inventory lifecycle
1. Maintain product identity, classification, unit/pack conversions and supplier references.
2. Create purchase request and approval under delegated authority.
3. Issue purchase order with supplier terms and expected delivery.
4. Receive delivery; verify quantity, product, batch/lot, expiry and required quality documents.
5. Quarantine discrepancies or items requiring pharmacist/quality release.
6. Release accepted stock to an authorized branch/location.
7. Record transfers, dispensing, returns, recalls, expiry and adjustments as traceable stock movements.
8. Perform cycle counts/full counts; investigate variances and approve adjustments.
9. Reconcile stock quantities and valuation with the relevant accounting records.

## Claims and patient balances
1. Identify applicable payer agreement and version for the patient/service/item.
2. Validate eligibility and covered items using approved contract rules.
3. Capture the dispensing/sale record and required supporting evidence.
4. Prepare claim; retain submitted payload and submission identifier.
5. Record payer response: accepted, rejected, partially approved or pending.
6. Route discrepancies for review; resubmit only with traceable revisions.
7. Record remittance against the payer receivable and reconcile differences.
8. Record approved patient responsibility as a separate receivable.
9. Collect later payments, issue receipts, handle refunds/disputes and reconcile balances.

## Required distinctions
Price discount, payer coverage, patient copay/share, exemption, submitted claim, approved claim, remittance and remaining receivable are different facts. Never infer one from another. No clinical recommendation or substitution workflow is in scope.

## Safety and audit controls
- Preserve batch/expiry traceability where required by product and regulation.
- Apply pharmacist/quality release controls to products requiring them.
- Prevent unauthorized stock issue, backdating and silent edits.
- Keep patient and health data access restricted and out of general logs.
- Record actor, timestamp, source document, reason and approval for adjustments.

## Egypt regulatory and market change gate

Every pharmacy workflow must be checked against the current Egypt pharmacy market/regulatory monitoring policy before approval and again before release. Map applicable EDA/MOHP/Official Gazette and other competent-authority updates to product category, location, workflow and test cases. Keep market signals separate from verified legal requirements. Regulatory changes must be reviewed by the relevant qualified professional and owner before operational rules or code are changed. The agent must not autonomously change clinical, dispensing, licensing, pricing, inventory, reimbursement or accounting behavior.

## Acceptance scenarios
- A receipt with a missing/invalid required lot or expiry attribute is held for review.
- A quarantined batch cannot be issued until authorized release.
- A transfer records source, destination, quantity, lot and both-side acknowledgement.
- A recalled/expired batch is blocked from dispensing and appears in an exception queue.
- A claim uses the agreement version effective for the transaction date.
- A rejected claim remains traceable and does not silently become approved.
- Patient responsibility remains separate from payer receivable and collection status.
