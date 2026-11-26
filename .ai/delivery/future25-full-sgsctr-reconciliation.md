# Future 25 — full SGSCTR reconciliation

- Status: **Phase 0 source and current-code reconciliation; semantic approval and implementation remain gated.**
- Source: owner-designated, read-only `futher_md/` on `master`; owner-selected Pharmacy model: **Option B — four independent operational modules**.
- This record supersedes the earlier first-pass-only status in the 2026-11-25 baseline. It does not claim a runtime reconstruction or completed field-by-field semantic approval.

## 1. Corpus coverage

The verified folder contains 12 files: nested `AGENTS.md`, recovered `future25_schema.sql`, schema report, AI build specification, module catalogue, UI map, workflow map, architecture, cost-control analysis, how-it-works guide, REA evidence JSON and static-analysis report. All were fetched and inspected as legacy evidence. The nested agent file and its WPF/.NET 8/9/SQLite recommendations are not SGSCTR policy.

## 2. Source evidence and limits

- Recovered DDL: 321 tables, 5,068 columns, 475 foreign keys, 297 primary-key clauses, 36 indexes, one view and 833 extracted DDL statements.
- The SQL Anywhere 9.0.2 schema was recovered from a translated transaction log. It is not an authenticated live catalog export; no live legacy database was queried or modified.
- Module catalog: 114 PBD libraries across inventory, payroll, accounting, fixed assets, sales, purchasing, general/setup, shell/shared, menus, maintenance variants and support. Its object census reports 874 windows and 3,091 DataWindows.
- Separate UI inventory reports 826 unique windows and 2,925 DataWindows, including 405 Arabic, 327 English and 94 language-neutral windows. These counts use different extraction methods and must not be summed.
- REA JSON: 8 artifact records, 5 providers and 16 evidence records; zero runtime captures, environment records or scenario records. Static observations do not prove runtime behavior.
- Preserve `[O]` observed, `[I]` inferred and `[U]` unknown. PBD business logic was not decompiled; ODBC DSN endpoints and MobiLink endpoint/schedule remain unknown.

## 3. Exhaustive structured registers added

- [321-table semantic disposition](future25-legacy-table-disposition.csv)
- [2,103 Pharmacy/inventory/procurement/sales column dispositions](future25-column-disposition-pharmacy-operations.csv)
- [811 accounting column dispositions](future25-column-disposition-accounting.csv)
- [1,369 application/setup/platform column dispositions](future25-column-disposition-platform-support.csv)
- [594 payroll/fixed-asset column dispositions](future25-column-disposition-people-assets.csv)
- [191 legacy technical column dispositions](future25-column-disposition-legacy-technical.csv)
- [475 FK relationship dispositions](future25-legacy-relationship-disposition.csv)
- [22 workflow reconciliation rows](future25-legacy-workflow-reconciliation.csv)
- Existing [46-row source-to-target candidate field map](future25-sgsctr-target-field-mapping.csv), [36-index inventory](future25-legacy-index-inventory.csv), [view inventory](future25-legacy-view-inventory.csv) and source table/column inventories remain available.

Every recovered column and FK now has a first-pass disposition, candidate context and explicit review note. A disposition is not a semantic field mapping: most columns still require source UI/DataWindow lineage, domain meaning, transformation, target-field and owner/professional review. No unknown field is silently declared mapped. Source functional-area labels are preserved but not treated as authoritative when names conflict (including claims, company cost-center organization, salary/holiday tables, security templates and food-drug interaction); those rows are explicitly flagged for source-lineage review.

## 4. Current SGSCTR implementation inspected

### Persisted model and migrations

Current `AppDbContext` includes organization locations; generic catalogue products, units/conversions, family assignments, identifiers, regulatory evidence, lifecycle/audit; supplier drafts, evidence, declarations, business contacts, due-diligence and assurance/review cases; receipt drafts/lines; stock movements; transfer requests/lines; regulatory sources/documents/alerts/scan runs; and governance approvals/test readiness. The current EF snapshot contains explicit Draft-only and pending-review/verification constraints for several of these aggregates.

### API and UI

- Catalogue: product/unit CRUD, conversions, audit, family proposals, identifier proposals, regulatory evidence and lifecycle requests.
- Supplier: Draft register, evidence/declarations/business contacts, due-diligence intake, assurance and review requests.
- Receiving: receipt draft create/read only; response explicitly states no stock movement or balance is created.
- Inventory: stock movement create/read/reverse and Posted-only balance query. The create/reverse paths create Draft records; inspected routes do not expose a posting action.
- Transfers: Draft request, submit, send-for-approval, approve, reject and cancel. Approval creates paired Draft TransferOut/TransferIn movements and explicitly returns `stockPosted=false`; no dispatch/receipt/in-transit posting lifecycle is implemented.
- Regulatory intelligence: source scans, document retrieval/content and alert acknowledgement.
- Web screens exist for catalogue, supplier register/assurance, receiving drafts, inventory workspace, approvals, test readiness and regulatory intelligence.

### Tests and verification evidence

Rule tests exist for catalogue, supplier, stock movements and transfer state transitions. PostgreSQL integration tests assert migrations, constraints and persistence behavior. On PR #108, GitHub Actions documentation integrity passed (governance, isolated integrity tests, line limit, generated catalogue and relative links); .NET Release build passed with one existing obsolete-API warning; automated tests passed 164/164; both AuthDbContext and AppDbContext `has-pending-model-changes` checks passed. The Compose smoke-start step then failed before containers launched because BuildKit rejected the VM-specific `network: host` entitlement on the hosted runner. A CI-only step was added to remove those two build-network overrides in the ephemeral runner workspace; that follow-up has not yet been verified. The separate model-parity diagnostic uploaded an artifact but its probe name collided with the existing `AppDbContextModelParityProbe` migration, so it does not establish a model diff. No local VM runtime test was executed.

## 5. Option B boundary finding

The selected operational modules remain:
1. Regular Medications
2. Chemotherapy Drugs
3. Medical Supplies
4. Cosmetics

The current implementation is a generic Pharmacy foundation, **not four independent operational modules yet**. The catalogue has five provisional family codes (`RegularMedicine`, `Chemotherapy`, `MedicalDevice`, `MedicalSupply`, `Cosmetic`) and a pending-review family assignment; that does not resolve Q61 or establish the four operational boundaries. Stock movements and transfer requests do not carry an approved module ownership dimension. Locations are generic and do not establish legal site, licence holder, operator or stock owner. These gaps must be resolved before module-specific operational workflows or cross-module data access are enabled.

## 6. Capability conclusions

- **Partial foundations:** location reference data, generic Draft catalogue, units/conversions, pending family/identifier/evidence/lifecycle proposals, supplier Draft intake/assurance, receipt drafts, stock movement ledger scaffolding, transfer request/approval scaffolding, EDA regulatory intelligence, governance and bilingual web foundation.
- **Not evidenced as operationally implemented:** purchase orders/requisitions, accepted receiving/inspection/quarantine/release, supplier returns, posted stock movements, dispatch/receipt/in-transit transfer, lot master/FEFO/recall/cycle count, dispensing/POS/patient records, pricing/discount adjudication, payer claims/remittance/patient balances, GL/journal posting, cost centers/budgets/job costing, payroll and fixed assets.
- **Reports/devices:** the legacy contains extensive DataWindow/report/print/label and POS peripheral evidence. SGSCTR has web workspaces but no complete report-by-report or device parity implementation.
- **Sync/recovery:** MobiLink is inferred from metadata; endpoint and schedule are unknown. Do not reproduce it without an approved, independently designed synchronization and conflict policy.

## 7. Decisions remain pending

Existing Q10–Q18, Q29–Q55 and Q58–Q66 remain authoritative. In particular: Q38/Q47–Q50 product taxonomy and regulatory fields; Q51 supplier qualification; Q52–Q55 procurement, receipt, transfers, dispensing, claims and costing; Q58–Q65 four-module sharing, locations, inter-module transfer, financial boundaries, costing, permissions and payer/discount interaction; Q66 ownership of non-Pharmacy legacy capabilities. The legacy cost-control and AI build-spec rules are evidence/proposals, not approved accounting or professional policy.

## 8. Safe implementation sequence after decisions

1. Approve the module/domain ownership matrix, location ownership, shared reference-data policy and role/SoD model.
2. Approve product-family taxonomy and family-specific fields with pharmacist, quality and regulatory reviewers.
3. Approve supplier eligibility, purchasing authority, PO and receiving/inspection lifecycles.
4. Approve lot/expiry/recall, stock ledger, transfer dispatch/receipt and count workflows.
5. Approve dispensing, provider claims, patient contribution/discount rules and reports.
6. Approve module management accounting, costing, statutory GL/tax integration and period-close with accountant/legal reviewers.
7. Implement one bounded slice at a time with migrations, API/UI, authorization, audit, automated tests and verified runtime evidence.
8. Only then design and rehearse migration from an authorized, verified legacy data snapshot.

## 9. Completion statement

**Completed:** verified 12-file corpus inventory; recovered-schema totals; table, column and FK dispositions for all 321/5,068/475 source records; 22 workflow capability comparisons; current EF/API/UI/test source inspection; Option B implementation gap identification.

**Still incomplete by design:** semantic approval of each source field and relationship, exhaustive individual screen/DataWindow/report lineage, runtime reconstruction, legal/professional policy decisions, full four-module operational implementation, migration and runtime acceptance. These cannot be honestly marked complete from static artifacts alone.
