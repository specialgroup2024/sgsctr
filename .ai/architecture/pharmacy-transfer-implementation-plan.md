# Pharmacy inventory and stock-transfer implementation plan

- Status: Phase 0 discovery documented; implementation blocked pending business, pharmacy, regulatory/site and accounting approvals.
- Current baseline: master commit d448e996df45101ca90ff615d4cd06cac60df105 (2026-11-14).
- Discovery: [pharmacy inventory discovery](../delivery/pharmacy-inventory-discovery.md); [Egypt inventory regulatory scan](../governance/egypt-pharmacy-inventory-scan-2026-11-14.md).

## 1. Verified repository baseline

- ASP.NET Core 10 API, EF Core/Npgsql, PostgreSQL 18 Compose service and Next.js web shell.
- `src/Sgsctr.Api/Data/AppDbContext.cs` currently exposes organization-location and EDA regulatory-intelligence DbSets only.
- The inspected API migration tree contains organization, Identity and EDA migrations; no inventory migration was found.
- `web/app/pharmacies/page.tsx` explicitly marks operational features as not enabled.
- No product catalogue, supplier purchasing, receiving, stock ledger/balances, lots, stock transfers, inventory UI or costing implementation was found in the inspected master tree.
- Existing transfer workflow, acceptance criteria, domain and persistence design are proposals only.

## 2. Owner-confirmed scope facts

- Locations: Mokattam main warehouse; Student Hospital, Qasr El-Aini and Manial Hospital branches.
- Direct branch-to-branch transfers are required; routes must not be forced through Mokattam.
- Pharmacy categories include regular medicines, chemotherapy drugs, medical supplies and cosmetics.
- Weighted-average costing is the requested method; its calculation level, timing and transaction treatment are not approved.

## 3. Work packages and gates

| ID | Work package | Gate / deliverable |
|---|---|---|
| INV-00 | Discovery and approvals | Verified entity/site/licence register; signed workflow, product classification and owner/professional decisions |
| INV-01 | Product, unit, location and supplier reference data | Approved taxonomy, barcode policy, pack conversions, supplier qualification and access tests |
| INV-02 | Receiving and quality status | Approved receiving SOP; supplier/document checks; lot/expiry and quarantine controls |
| INV-03 | Stock ledger and balances | Append-only movements, location/lot balances, reconciliation and physical-count controls |
| INV-04 | Transfers | Approved lifecycle/custody/roles; warehouse↔branch and direct branch↔branch; partial receipt and discrepancies |
| INV-05 | Quality and traceability | Expiry/FEFO, recall, returns, damaged/expired quarantine, temperature evidence and EDA track-and-trace applicability |
| INV-06 | Costing and reports | Accountant-approved moving weighted-average worked examples, valuation and reconciliation |
| INV-07 | Pilot and release | Opening-stock count/reconciliation, automated tests, user acceptance and signed release gate |

## 4. Required approvals before schema or feature code

- Business owner: legal entity, sites, operating scope, role authority, approval limits and release priority.
- Pharmacy operations/licensed pharmacist: product categories, units, receiving, storage, lot/expiry, FEFO, counts, adjustments, transfer lifecycle, custody, returns and exceptions.
- Regulatory-affairs/legal professional: current Egyptian instruments, site licences, product-class applicability and track-and-trace obligations.
- Accountant: moving weighted-average level/timing, returns, transfers, in-transit stock, losses, expiry, adjustments, rounding, period close and reconciliation examples.
- Technical/security owner: resource authorization, audit, migration, data import and recovery controls.

## 5. Engineering quality gates after approval

- Pure domain tests before persistence; real PostgreSQL integration tests for constraints, concurrency, idempotency and rollback.
- Server-side sector/location authorization; immutable movement/audit history; no direct database access from clients.
- Lot/expiry traceability and quality status must not be bypassed by transfer, receipt or retry.
- Review generated migration SQL and test upgrade against representative data; never reset or overwrite production history.
- No negative stock by default; any exception requires explicit approved policy and audit.
- No valuation or GL posting until accountant-approved examples and policy are implemented and tested.

## 6. Next action

Obtain the decisions listed in .ai/memory/open-questions.md (Q29–Q36) and approvals in the discovery document. Until then, only repository discovery, documentation, mockups and non-posting prototypes are in scope. No schema migration, seed data, stock movement or production record is authorized.
