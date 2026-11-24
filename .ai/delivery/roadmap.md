# Delivery roadmap

This is an execution sequence, not business approval. Re-select specialist profiles
and re-check the approval register whenever a phase crosses a new boundary.
Pharmacy delivery authorization is recorded as PHARM-OWN-001. Reserved professional,
security, owner-policy and release gates remain independently binding.

## Phase 0: Evidence and control baseline

Reconcile current code, migrations, API/BFF/UI routes, tests, CI and runtime evidence.
Keep repository facts separate from owner facts and unresolved decisions. Confirm
the exact first operational sites, user populations, legal operator and data scope.

Exit: dated capability matrix, dependencies, risks, test baseline and named
approval evidence for the next implementation slice.

## Phase 1: Pharmacy master data and product catalogue

Complete generic product identity, controlled draft lifecycle, product-family
review proposals, source-qualified identifiers/evidence, unit and packaging
conversion references, search, audit and authorized review workflow. Add
medicine, chemotherapy, medical-supply/device and cosmetics fields only after
Q38 pharmacist, quality and regulatory review. Do not activate products from
unverified source data.

Exit: approved data dictionary, duplicate/SKU policy, permissions, import
provenance, audit requirements and tested catalogue lifecycle.

## Phase 2: Supplier assurance and procurement foundation

Reconcile existing supplier intake and assurance code. Complete approved
verification/review capability, then purchase requisition/order workflows only
after supplier qualification, procurement limits, delegation and eligibility
criteria are approved. Preserve the INV-01 exclusion of supplier master from
its original scope; use the later supplier approvals and conditions.

Exit: approved supplier and procurement policies; no supplier becomes eligible
merely because a draft, evidence reference or review request exists.

## Phase 3: Receiving and inventory ledger

Design and implement controlled receiving, accepted/rejected/quarantined goods,
stock ledger, balances, stock counts and adjustments. Connect receipt drafts
only after their source and technical acceptance are verified. Do not infer
stock from catalogue, purchase or receipt drafts.

Exit: pharmacist/quality-approved receiving and stock controls, database
invariants, idempotency/concurrency tests and reconciled opening-stock method.

## Phase 4: Batch, expiry, storage, recall and quality controls

Implement product-family-specific lot, serial, expiry, storage, temperature,
quarantine, recall and disposition behavior only to the extent approved by
qualified reviewers and applicable verified requirements.

Exit: approved family applicability matrix, evidence trail, exception handling
and tested traceability/recall exercises.

## Phase 5: Warehouse and branch transfers

Support Mokattam ↔ each branch and direct branch ↔ branch routes. Reconcile the
existing proposed transfer lifecycle and acceptance criteria with pharmacy
operations, security and accounting before enabling dispatch/receipt postings.

Exit: approved custody, roles, separation of duties, discrepancy, return,
in-transit and valuation treatment; PostgreSQL concurrency/idempotency tests
and end-to-end route tests pass.

## Phase 6: Costing and pharmacy financial controls

Implement moving weighted-average costing only after the accountant approves
valuation pool, timing, returns, transfers, losses, expiry, rounding, negative
stock and period-close examples. Establish pharmacy/location dimensions and
the boundary to Special Group administration without mixing sector books.

Exit: worked examples reconcile to inventory and approved accounting outputs;
no GL posting until chart of accounts, tax and posting policy are approved.

## Phase 7: Dispensing and patient workflow

Implement prescription intake, validation, dispensing, partial fulfilment,
returns and patient account handling only after pharmacy leadership approves
procedures and security/privacy approves the patient-data purpose, access,
retention and audit controls. No autonomous diagnosis, prescribing or medicine
substitution is permitted.

Exit: qualified operational sign-off, privacy/security acceptance and tested
authorization, traceability, reversal and patient-safety controls.

## Phase 8: Payer agreements, reimbursement and claims

Model agreement versions, covered categories, effective dates, eligibility,
claim submission, rejection, resubmission, remittance and collection. Keep
payer coverage, payer discount, patient copay/exemption, claim receivable and
collection distinct. Configure patient 0%/10% examples only from signed
agreements and approved calculation order; never hardcode a universal rate.

Exit: signed agreement evidence and accountant-approved worked examples cover
full exemption, patient contribution, rejection, partial approval and remittance.

## Phase 9: Pricing and Special Group employee discounts

Implement retail/contract price history, employee eligibility, discount
authorization and conflict/stacking rules separately from payer coverage and
patient contribution.

Exit: owner-approved policy, authorized eligibility source, effective dates,
audit and accounting examples.

## Phase 10: Pharmacy accounting, reporting and operational acceptance

Complete payables, receivables, inventory valuation, dispensing revenue, cost
of goods sold, branch dimensions, reconciliations, period close and approved
financial statements. Deliver operational dashboards and exception reports.
Regulatory intelligence is cross-cutting: preserve source provenance, human
review and impact assessment; detected updates must never silently alter
product, dispensing, stock, price or accounting rules.

Exit: all approved end-to-end scenarios pass, security/privacy and professional
sign-offs are recorded, migrations are rehearsed, backup/restore is tested,
opening balances reconcile and the owner separately authorizes a controlled
pilot/release.

## Delivery rules

- Work in small, reviewable branches/PRs; do not combine unrelated phases.
- Each phase records implemented, partial, absent and approval-blocked items.
- Tests must include denial paths, persistence, audit, concurrency, idempotency,
  failure rollback, English/Arabic UI and supported browser sizes as applicable.
- Use fixed-precision decimal and explicit currency for money; UTC timestamps
  with source timezone where needed.
- No destructive migration, data reset, synthetic business data, stock movement,
  supplier transmission, patient-data use or financial posting without explicit
  authorization and all applicable approvals.
- CI, merge and technical acceptance do not constitute professional approval
  or production release.
