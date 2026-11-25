# Future 25 → SGSCTR Pharmacy reconciliation

- Status: **Phase 0 evidence baseline; field-level semantic reconciliation remains in progress.**
- Owner-selected Pharmacy model: **Option B — four independent operational modules** (Regular Medications, Chemotherapy Drugs, Medical Supplies, Cosmetics).
- Source corpus: `futher_md/` on merged `master`; read-only.
- SGSCTR code baseline: `master` inspected 2026-11-25.
- Governing instructions: root `AGENT.md`, `AGENTS.md`, and `.ai/`. The nested legacy `futher_md/AGENTS.md` is source evidence, not agent policy.

## 1. Executive result

The actual `futher_md/` directory contains **12 files**. Its recovered SQL Anywhere DDL contains **321 CREATE TABLE definitions, 475 foreign-key clauses, 36 indexes, one view and 833 extracted DDL statements**. The schema report classifies all 321 tables across nine functional areas.

The DDL was recovered from a translated transaction log, not an authenticated live catalog export: the database password was unavailable. The legacy app is a PowerBuilder 9 desktop ERP/POS application using compiled PBD libraries, Windows ODBC/DSN configuration and SQL Anywhere 9. MobiLink synchronization is inferred from metadata. No executable was launched, no original data file was modified, and PBD business logic was not decompiled.

## 2. Complete machine-readable inventories

The complete first-pass inventories are stored separately from this short decision/evidence record:

- [321-table inventory](future25-legacy-table-inventory.csv) — source name, reported column count, functional area, initial disposition and SGSCTR handling.
- [475 foreign-key inventory](future25-legacy-foreign-key-inventory.csv) — child/parent tables and columns, preserved from recovered DDL.
- [Workflow reconciliation matrix](future25-legacy-workflow-mapping.csv) — 17 major workflow/capability families mapped to legacy evidence and current SGSCTR evidence.

The table dispositions are deliberately preliminary heuristics based on the recovered table names and source report categories. They are not semantic equivalence claims and do not authorize migration.

## 3. Source inventory by functional area

| Source functional area | Tables |
|---|---:|
| Inventory / stores | 87 |
| Application / support | 83 |
| Accounting / finance | 45 |
| Setup / security | 26 |
| Payroll / HR | 27 |
| System / PowerBuilder / MobiLink support | 21 |
| Sales / customers | 14 |
| Purchasing | 12 |
| Fixed assets | 6 |
| **Total** | **321** |

The five `"backup".pbcat*` tables are correctly classified as PowerBuilder catalogue metadata, not business records. Preserve schema-qualified source names exactly.

## 4. Current SGSCTR implementation evidence

The inspected `AppDbContext` has 28 DbSet declarations covering:
- organization locations;
- generic catalogue products, units, conversions, identifiers, family proposals, regulatory evidence and lifecycle requests;
- supplier draft, evidence, declaration, contact, due-diligence, review and assurance records;
- receipt drafts and lines;
- stock movements and transfer requests/lines;
- regulatory sources, documents, alerts and scan runs;
- governance approvals and test-readiness records.

Relevant code exists under `src/Sgsctr.Api/PharmacyCatalogue/`, `PharmacyInventory/`, `PharmacySuppliers/`, and `RegulatoryIntelligence/`, with related web workspaces and tests.

These are partial foundations. The inspected model does **not** evidence complete purchasing/PO, accepted receiving and supplier-return workflows, pharmacy dispensing/sales, claims/remittance/patient balances, GL posting, cost-center/budget accounting, payroll, or fixed assets. Receipt and supplier records are explicitly draft/gated. Stock transfer approval creates draft movements; balance-affecting transfer policy remains approval-gated.

## 5. Four-module boundary

Legacy table names do not decide module ownership. Every Pharmacy workflow and transaction must be attributed to one of:
1. Regular Medications
2. Chemotherapy Drugs
3. Medical Supplies
4. Cosmetics

A shared Pharmacy capability is permitted only where its purpose, ownership and module attribution are explicit. Shared visibility does not imply shared stock ownership. A physical location may need to hold stock for more than one module, but ownership, custody, access, counts and reporting require decisions.

Do not infer:
- a fifth Pharmacy module from legacy categories;
- that generic legacy retail sales equal pharmacy dispensing;
- that four operational modules equal four legal entities or statutory ledgers;
- that legacy average-cost behavior overrides the owner's moving weighted-average requirement;
- that any legacy accounting, payer, clinical, quality or regulatory rule is approved for SGSCTR.

## 6. Workflow coverage and implementation gaps

The linked workflow matrix covers startup/configuration, company/location/fiscal context, product catalogue, suppliers, RFQ/requisition/PO, receiving/returns, stock ledger, transfers, sales/dispensing, claims, GL, cost centers/budgets/job costing, payroll, fixed assets, reports/devices, synchronization/backup and identity/audit.

Priority gaps confirmed by source inspection:
1. Four module workspaces, module ownership keys and module-scoped permissions are not evidenced end-to-end.
2. Product-family taxonomy and family-specific attributes remain under professional review.
3. Purchasing commitments, purchase orders, receipt matching, accepted stock and supplier returns are not complete.
4. Lot/expiry, quarantine/release, recall, stock counts, FEFO and traceability policies are not fully implemented.
5. No approved moving weighted-average valuation engine is evidenced.
6. Dispensing/sales, payer claims, remittance and patient balances are not implemented as operational workflows.
7. No Pharmacy GL, cost-center, budget or financial posting engine is evidenced.
8. Payroll and fixed assets are separate non-Pharmacy scope candidates, not automatic inclusions.

## 7. Evidence confidence

Preserve the legacy source labels:
- **[O] Observed** in static files, DDL, PE/shortcut metadata or object inventories.
- **[I] Inferred** from names, embedded SQL, relationships, configuration or static patterns.
- **[U] Unknown** without runtime traces, authenticated live DB access or PBD decompilation.

The REA evidence JSON contains 8 artifact records and 16 evidence records; no runtime scenarios or captures are recorded. Counts from different copies and different object-extraction methods must not be combined into one runtime census.

## 8. Approval gates still open

Existing questions remain open, including:
- Q11/Q30/Q32/Q38/Q47–Q50: product identity, family taxonomy, identifiers, batch/lot/expiry, storage and professional classification.
- Q31/Q39/Q43/Q51: supplier eligibility, purchasing, receipt acceptance, supplier returns, price and qualification policy.
- Q10/Q33: transfer lifecycle, custody, roles, counts and exceptions.
- Q12/Q34/Q44: moving weighted-average pool, timing, returns, transfers, losses, expiry, adjustments, negative stock, precision and period close.
- Q14–Q16: payer agreements, coverage, copay/exemption, claims, remittance and patient balances.
- Q01–Q04/Q17/Q29/Q37: legal entity, site operator/licence/stock ownership and statutory accounting.
- Q66: whether payroll/HR, fixed assets, general services, job costing and other non-pharmacy legacy capabilities belong to shared Special Group platform, contracting, future scope or out of scope.

No professional or owner approval is created by this reconciliation. No production posting, valuation, tax, claim settlement, supplier qualification, stock movement or migration is authorized.

## 9. Migration guardrails

If migration is later approved:
1. Profile an authorized, verified database snapshot; do not assume the recovered transaction-log DDL represents current live data.
2. Map each source field, key, relationship, default, nullability and transformation to a target field or explicit exclusion.
3. Preserve source lineage and document identity; stage and validate before production writes.
4. Reconcile row counts, duplicates, orphans, money precision, dates, quantities, codes and balances.
5. Never fabricate missing lots, expiry, conversions, cost layers, payer rules, legal entity ownership or account mappings.
6. Do not import PowerBuilder metadata, credentials, license/protection values, workstation/device secrets or irrelevant temporary tables.
7. Never execute the legacy SQL Anywhere DDL against the SGSCTR PostgreSQL database.

## 10. Reconciliation completion criteria

- [ ] Every source field and relationship has a target mapping or reasoned exclusion/unknown status.
- [ ] Every Pharmacy capability is assigned to one of the four modules or explicitly shared.
- [ ] Source module families, workflows, UI capability families and reports are mapped.
- [ ] Current entities, EF configuration, migrations, API, UI and tests are checked against each approved mapping.
- [ ] Professional accounting, pharmacy, quality, legal and regulatory approvals are recorded where required.
- [ ] Migration is separately approved, rehearsed and reconciled.

**Current completion state:** table-name and FK inventories are exhaustive for the recovered DDL; workflow mapping is a first-pass capability assessment. Field-level semantics, UI-to-SQL behavior, runtime validation and target implementation design remain open. This is not a claim that the legacy application has been rebuilt.
