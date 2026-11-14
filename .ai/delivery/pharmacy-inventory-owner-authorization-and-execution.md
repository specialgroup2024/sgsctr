# Pharmacy Inventory — owner authorization and controlled execution

- Recorded: 2026-11-14
- Authority: project owner approval received in the ChatGPT project conversation.
- Scope authorized: proceed with Pharmacy Inventory implementation across PostgreSQL/EF Core, ASP.NET Core APIs, Next.js UI, automated tests, and repository governance.
- This record is an owner authorization to develop. It is not a pharmacist, regulatory-affairs, legal, quality, or accountant professional sign-off.

## Confirmed operational context

- Locations: Mokattam main warehouse; Student Hospital, Qasr El-Aini Hospital, and Manial Hospital branches.
- Branches are administratively connected and separately accountable for location stock reporting.
- Direct branch-to-branch transfers are required; transfers must not be forced through Mokattam.
- Product scope includes regular medicines, chemotherapy medicines, medical supplies, and cosmetics.
- Moving weighted-average costing is the requested method, but its valuation pool, timing, transfer/return/loss/expiry treatment, rounding, and period-close rules still require accountant approval.

## Execution authorization

Proceed with implementation in independently reviewable increments. Each increment must include persistence, API, UI, authorization, audit, migration, and automated tests as applicable. Do not report a capability as implemented until all applicable layers and tests exist.

## Mandatory professional and policy gates

1. Pharmacist / pharmacy-operations review: product-family applicability, lot/expiry/serial requirements, FEFO, receiving acceptance, quarantine/release, recall, returns, storage controls, and operational exception procedures.
2. Egyptian regulatory-affairs / legal review: site licensing and operator status, product-specific obligations, EDA/EPTTS applicability, record retention, and binding instrument interpretation.
3. Quality reviewer: inspection, temperature/storage evidence, deviations, rejected/quarantined stock, recall and disposition controls.
4. Accountant: moving weighted-average policy, valuation pool and event treatment, transfer valuation, returns, losses, expiry, adjustments, tax, period close and reconciliation.
5. Owner: supplier qualification policy, purchasing approval limits, separation of duties, stock adjustment authority, opening-stock/cutover and production release.

Owner authorization does not waive these gates. Until recorded, implement draft/non-posting capability only where the missing decision affects correctness or safety. No production stock posting, live opening balances, or financial posting may be enabled without the relevant signed approvals.

## Delivery sequence

- INV-A: complete technical discovery against current master; resolve domain model, existing organization/location and identity/audit conventions; update traceability and test matrix.
- INV-B: supplier register and supplier evidence, with draft status and review workflow.
- INV-C: purchase-order drafts, lines, document references and approval workflow; no financial commitment or supplier transmission until purchasing policy is approved.
- INV-D: receiving records, inspection evidence and accepted/rejected/quarantined dispositions; no available-stock release until pharmacist/quality policy is approved.
- INV-E: append-only stock movement ledger and location/lot balance projections with PostgreSQL transaction, idempotency and concurrency tests. Activate posting only after stock-state and authorization policies are signed.
- INV-F: batch/lot/expiry, FEFO candidates, quarantine, recall traceability, stock counts, controlled adjustments and reconciliation.
- INV-G: direct warehouse↔branch and branch↔branch transfers, including dispatch, in-transit, partial receipt and discrepancy resolution; posting remains gated by signed transfer SOP.
- INV-H: accountant-approved moving weighted-average costing and valuation reports. No GL posting in this scope without separate authorization.
- INV-I: reports, operational acceptance, security review, migration rehearsal, opening-stock reconciliation and controlled release.

## Non-negotiable engineering controls

- Preserve existing migrations and data; use forward-only additive migrations unless a reviewed safe correction is necessary.
- Never reset or delete database volumes or production data.
- All writes go through ASP.NET Core APIs; no browser-to-database access.
- Enforce server-side sector/location authorization and separation of duties; client-side hiding is not authorization.
- Use append-only movement/audit events; corrections are linked reversal/adjustment events, not destructive edits.
- Protect concurrent stock consumption with PostgreSQL transactions and concurrency controls; make commands idempotent.
- Keep in-transit, available, quarantined, rejected, expired, recalled and reserved quantities distinct.
- Do not infer EDA legal classifications or EPTTS applicability from UI labels.
- Do not introduce patient/dispensing, payer claims, patient balances, tax or general-ledger workflows as part of inventory delivery.
- Do not claim production readiness based only on build or CI smoke tests.

## Acceptance evidence required per increment

Record migration name and schema effect; API routes and authorization; UI routes and real API connectivity; domain invariants; unit and PostgreSQL integration tests; CI run; known limitations; outstanding owner/professional decisions; and whether the capability is draft-only, test-enabled, or approved for production.
