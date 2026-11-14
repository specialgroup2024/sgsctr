# Pharmacy inventory and stock-transfer implementation plan

- Status: Phase 0 and INV-00 completed. Generic INV-01 draft catalogue foundation is implemented on branch `feat/inv01-generic-product-catalogue`; Q38 remains open for family-specific fields/classification/activation. Branch is not merged or runtime-verified.
- Current master baseline: 7114e0cd499e371d2e08c71f8f86bcd6148c6deb (2026-11-14).
- Discovery: [inventory discovery](../delivery/pharmacy-inventory-discovery.md); [INV-00 requirements](../delivery/pharmacy-inventory-inv00-requirements.md); [costing examples](../delivery/pharmacy-inventory-costing-worked-examples.md); [Egypt scan](../governance/egypt-pharmacy-inventory-scan-2026-11-14.md); [INV-01 approval pack](../delivery/pharmacy-inventory-inv01-approval-pack.md).

## 1. Verified repository baseline

- ASP.NET Core 10 API, EF Core/Npgsql, PostgreSQL 18 Compose service and Next.js web shell.
- Master baseline has organization-location and EDA regulatory-intelligence DbSets. The feature branch adds CatalogueProducts, UnitsOfMeasure, ProductUnitConversions and CatalogueAuditEvents with an additive migration.
- PR #29 merged the non-posting UI route /pharmacies/inventory with Overview, Product Catalogue, Receiving, Stock Transfers, Batches & Expiry and Reports.
- UI location reference data uses the existing Organization API; API liveness and PostgreSQL readiness are displayed separately.
- Generic product identity, units and draft conversion references are implemented on the feature branch only. No family-specific fields, supplier purchasing, receiving, stock ledger/balances, lots, stock transfers or costing implementation exists.
- Existing transfer workflow, acceptance criteria, domain and persistence design are proposals only.

## 2. Owner-confirmed scope facts

- Locations: Mokattam main warehouse; Student Hospital, Qasr El-Aini and Manial Hospital branches.
- Owner confirmed 2026-11-14 that Mokattam is an EDA-licensed pharmaceutical warehouse under Chairman Decree 725/2024. Licence details and scope require documentary/regulatory verification; hospital branch classifications remain separate and unverified.
- Direct branch-to-branch transfers are required; routes must not be forced through Mokattam.
- Pharmacy categories named by owner: regular medicines, chemotherapy drugs, medical supplies and cosmetics.
- Weighted-average costing is requested; calculation pool, timing and transaction treatment are not approved.

## 3. Work packages and gates

| ID | Work package | Gate / deliverable |
|---|---|---|
| INV-00 | Discovery, requirements and UI foundation | Requirements, costing examples, regulatory scan and connected non-posting screens |
| INV-01 | Product, unit, location and supplier reference data | Q37 Mokattam licence verification + separate hospital-site classification; Q38/Q46 approvals; signed taxonomy/data dictionary, identifiers, units, supplier boundary and access policy |
| INV-02 | Receiving and quality status | Approved receiving SOP; supplier/document checks; lot/expiry and quarantine controls |
| INV-03 | Stock ledger and balances | Append-only movements, location/lot balances, reconciliation and physical-count controls |
| INV-04 | Transfers | Approved lifecycle/custody/roles; warehouse↔branch and direct branch↔branch; partial receipt and discrepancies |
| INV-05 | Quality and traceability | Expiry/FEFO, recall, returns, damage/expiry quarantine, temperature evidence and EDA track-and-trace applicability |
| INV-06 | Costing and reports | Accountant-approved moving weighted-average examples, valuation and reconciliation |
| INV-07 | Pilot and release | Opening-stock count/reconciliation, automated tests, user acceptance and signed release gate |

## 4. Remaining approvals before regulated catalogue extensions and release

- Owner: detailed internal-code/duplicate rules, final catalogue role matrix, audit retention/export, provenance/import authority and release acceptance. Generic draft foundation boundary is owner-authorized.
- Licensed pharmacist/pharmacy operations: product-family taxonomy, category-specific fields, regulated identifiers and product handling metadata before those are implemented or products are activated.
- Egyptian regulatory-affairs/legal reviewer: current instruments, site licences, product-class applicability and track-and-trace obligations before regulated extensions or operational use.
- Procurement: supplier master scope, evidence, eligibility and verification ownership.
- Accountant: unit precision/conversion consequences and future costing boundary; no valuation implementation in INV-01.
- Technical/security owner: resource authorization, audit, import controls and migration strategy.

## 5. Engineering quality gates after approval

- Pure domain validation tests before persistence; PostgreSQL integration tests for constraints, concurrency, duplicate detection, effective dates and rollback.
- Server-side sector/location authorization; audit history; no direct database access from clients.
- Product identity, external packaging identifiers and unit conversions remain distinct concepts.
- Imports are staged and human-reviewed; never overwrite verified records silently.
- Retired records remain resolvable for historical references.
- Review generated migration SQL and test upgrade without resetting existing data.
- No inventory movement, negative-stock policy, costing or GL posting in INV-01.

## 6. Current next action

Review the generic implementation branch, run CI/build/typecheck/tests, inspect the additive migration against a preserved PostgreSQL database, and verify the connected catalogue UI/API. Obtain owner acceptance and a separate merge/release decision. Complete Q38 with qualified reviewers before adding product-family fields, regulatory identifiers, classification or activation. Verify Q37 site licensing separately before adding pharmacy legal/site metadata. Supplier master and all transactional/financial workflows remain excluded.
