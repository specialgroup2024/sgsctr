# Pharmacy inventory discovery and implementation gate

> Historical baseline: this document records the discovery/INV-00 state before the generic INV-01 implementation branch. For current repository state, read [current-state](../memory/current-state.md), [INV-01 approval pack](pharmacy-inventory-inv01-approval-pack.md) and [ADR-0004](../architecture/ADR-0004-generic-pharmacy-catalogue.md). The generic branch is not merged or runtime-verified.

- Review date: 2026-11-14.
- Status: Phase 0 repository and regulatory discovery completed; business requirements and professional approvals remain open.
- Scope: Pharmacy inventory only. No authentication or Data Protection verification was performed.

## Dynamic role perspectives applied

- Architect: modular-monolith / .NET and PostgreSQL inventory boundary.
- Devil's Advocate: stock integrity, concurrency, traceability, unsafe release, role abuse and migration risk.
- Clueless Client: warehouse/branch operator needs clear receipts, stock availability, expiry warnings and simple transfers.
- Subject Matter Expert: pharmacy supply-chain, stock-control, product-quality and Egyptian regulatory requirements.
- Maestro: keep the next step within Phase 0; do not authorize stock-changing implementation.
These are analytical perspectives simulated in one assistant, not independent human reviews. No licensed pharmacist, accountant, regulatory professional or legal adviser participated.

## Verified repository baseline

- Master at review: `d448e996df45101ca90ff615d4cd06cac60df105`.
- API targets .NET 10; EF Core/Npgsql; PostgreSQL Compose image is 18-alpine.
- `src/Sgsctr.Api/Data/AppDbContext.cs` contains organization-location and EDA regulatory-intelligence DbSets only. No inventory item, lot, balance, movement, receipt, supplier or transfer DbSet exists.
- Current API migration tree contains organization, Identity and EDA migrations; no pharmacy-inventory migration exists.
- `web/app/pharmacies/page.tsx` is a foundation-only workspace and explicitly says inventory, purchasing, receiving, dispensing and branch transfers are not enabled.
- Repository has proposed transfer workflow, acceptance criteria, domain model, persistence design and implementation plan. They are drafts, not approved business rules.
- No inventory implementation, stock balances, product catalogue, stock movement ledger, supplier purchasing or inventory UI was found in the inspected master tree.

## Owner-confirmed facts

- Initial locations: Mokattam main warehouse; Student Hospital, Qasr El-Aini Hospital and Manial Hospital branches.
- Branches are administratively connected but separately accountable for stock/location reporting.
- Direct branch-to-branch transfer is required; a transfer must not be forced through Mokattam.
- Pharmacy handles regular medicines, chemotherapy drugs, medical supplies and cosmetics.
- Weighted-average costing is the requested costing method, but the accountant and pharmacy lead have not approved its level, timing or event treatment.

## Proposed inventory capability map — not approved requirements

1. Product and package catalogue: product identity, category, brand/generic attributes where lawful, dosage/form/strength where applicable, barcode/GTIN, supplier identifiers, unit and pack conversion.
2. Supplier and purchasing: approved supplier master, purchase request/order, contract/price evidence and supplier-document retention.
3. Receiving and quality gate: purchase-order matching, supplier/product verification, quantity, lot/batch, manufacture/expiry, packaging condition, temperature evidence and accepted/rejected/quarantined status.
4. Location stock: location- and lot-level ledger, available/quarantined/expired/recalled/in-transit status, movement history and reconciliation.
5. Transfers: warehouse↔branch and direct branch↔branch; request, approval, picking, dispatch, in-transit, partial receipt, discrepancy, return and closure, subject to signed SOP.
6. Stock control: FEFO candidate, expiry/retest alerts, cycle counts, physical counts, authorized adjustments, damaged/expired/recalled/returned quarantine and recall traceability.
7. Costing/reporting: weighted-average costing and valuation reports only after accountant-approved worked examples; no journal or financial posting in this phase.

## Egyptian regulatory evidence

See [Egypt pharmacy inventory regulatory scan — 2026-11-14](../governance/egypt-pharmacy-inventory-scan-2026-11-14.md). EDA GSDP v05/2025 describes stock records updated after each operation, periodic reconciliation, expiry checks, FEFO, segregation/quarantine, recall traceability, receiving checks and storage monitoring. EDA also publishes 2026 licensing and track-and-trace material. These sources require site-, product- and role-specific applicability review; they do not by themselves authorize an app workflow.

## Decisions required before coding

- Confirm legal entity, site list, site licence type/holder, operator, stock owner and custodian.
- Approve item categories and which products require lot, expiry, serial, temperature, controlled-item or track-and-trace controls.
- Approve units, pack conversion, barcode/identifier policy and duplicate-product matching.
- Approve supplier qualification, purchasing, receiving inspection and rejected/quarantined receipt procedures.
- Approve FEFO exceptions, expiry thresholds, recall blocking, returned-goods disposition and stock adjustment authority.
- Approve location roles, transfer lifecycle, approval limits, separation of duties, emergency path and discrepancy resolution.
- Accountant and pharmacy lead approve moving weighted-average costing level/timing and worked examples for purchase, supplier return, transfer, partial receipt, loss, expiry, adjustment and period close.
- Approve opening stock source, reconciliation, migration/cutover and physical count sign-off.

## Safe implementation sequence after approvals

- INV-00: signed requirements, legal/site register, product classification and worked examples.
- INV-01: approved product/unit/location/supplier reference data and validation tests; no on-hand stock posting.
- INV-02: receiving and append-only stock ledger with lot/expiry and quarantine controls.
- INV-03: location balances, stock counts, expiry/recall controls and reconciliation.
- INV-04: approved transfers including direct branch-to-branch, idempotency and PostgreSQL concurrency tests.
- INV-05: accountant-approved weighted-average costing and valuation reports.
- INV-06: controlled pilot, opening-stock reconciliation, user acceptance, security and release approval.

Each package requires tests, review and named approval. Production stock posting and migrations remain blocked until the applicable business/accounting/legal gates are recorded.

## INV-00 continuation

The next requirements package is drafted in [pharmacy-inventory-inv00-requirements.md](pharmacy-inventory-inv00-requirements.md), with illustrative arithmetic in [pharmacy-inventory-costing-worked-examples.md](pharmacy-inventory-costing-worked-examples.md). The regulatory scan was refreshed to include EDA warehouse licensing v05/2026 and EPTTS Phase 1 FAQ v03/2026. These are drafts and evidence, not approvals.

## Current outcome

Phase 0 discovery and INV-00 requirements preparation are documented. No application code, database schema, EF migration, seed data, stock balance, production record or business policy was changed. Next action is named owner and professional review of Q29–Q46 and signed decisions, not a guessed implementation.
