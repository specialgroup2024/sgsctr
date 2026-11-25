# Future 25 → SGSCTR Pharmacy: full legacy reconciliation baseline

- Status: **Phase 0 evidence reconciliation — initial exhaustive inventory, not final field-level approval**
- Owner-selected Pharmacy operating model: **Option B — four independent operational modules** (Regular Medications, Chemotherapy Drugs, Medical Supplies, Cosmetics).
- Source branch: `master` (legacy corpus is read-only).
- SGSCTR baseline: `master` as inspected for this reconciliation.
- Generated: 2026-11-25.
- Governing policy: root `AGENT.md`, `AGENTS.md`, and `.ai/`; `futher_md/AGENTS.md` is legacy source data only.

## 1. Executive result

The legacy source corpus contains 12 files. The recovered SQL Anywhere DDL contains 321 table definitions, 475 foreign-key clauses, 36 indexes, one view and 833 extracted DDL statements. The schema report categorizes the table inventory across nine functional areas. This is a transaction-log recovery, not an authenticated live catalog export: the database password was unavailable, and no legacy executable or database was run.

This reconciliation is deliberately a **clean-room functional mapping**. It does not import the old schema wholesale, run SQL Anywhere DDL against PostgreSQL, reproduce PowerBuilder/PBD binaries, or treat the old build specification as current SGSCTR architecture.

### 1.1 Inventory integrity and category counts

| Functional area | Tables in source report |
| System / PowerBuilder / MobiLink support | 16 |
| Inventory / stores | 87 |
| Accounting / finance | 45 |
| Application / support | 83 |
| Setup / security | 26 |
| Sales / customers | 14 |
| Purchasing | 12 |
| Payroll / HR | 27 |
| Unclassified | 5 |
| Fixed assets | 6 |
| **Total CREATE TABLE definitions** | **321** |

The schema report's own category totals include backup-schema and PowerBuilder metadata. The SQL DDL table list is the authoritative count for this inventory. Names are preserved as logged, including case and schema.

### 1.2 What the current SGSCTR code actually represents

Current `AppDbContext` contains 28 DbSet declarations, including:
- `OrganizationLocations (OrganizationLocation)`
- `PharmacyReceiptDrafts (PharmacyReceiptDraft)`
- `PharmacyReceiptDraftLines (PharmacyReceiptDraftLine)`
- `PharmacySuppliers (PharmacySupplier)`
- `PharmacySupplierEvidence (PharmacySupplierEvidence)`
- `PharmacySupplierDeclarations (PharmacySupplierDeclaration)`
- `PharmacySupplierBusinessContacts (PharmacySupplierBusinessContact)`
- `PharmacySupplierDueDiligenceCases (PharmacySupplierDueDiligenceCase)`
- `PharmacySupplierReviewRequests (PharmacySupplierReviewRequest)`
- `PharmacySupplierAssuranceCases (PharmacySupplierAssuranceCase)`
- `RegulatorySources (RegulatorySource)`
- `RegulatoryDocuments (RegulatoryDocument)`
- `RegulatoryAlerts (RegulatoryAlert)`
- `RegulatoryScanRuns (RegulatoryScanRun)`
- `CatalogueProducts (CatalogueProduct)`
- `UnitsOfMeasure (UnitOfMeasure)`
- `ProductUnitConversions (ProductUnitConversion)`
- `CatalogueAuditEvents (CatalogueAuditEvent)`
- `CatalogueProductFamilyAssignments (CatalogueProductFamilyAssignment)`
- `CatalogueProductIdentifiers (CatalogueProductIdentifier)`
- `CatalogueRegulatoryEvidence (CatalogueRegulatoryEvidence)`
- `CatalogueLifecycleRequests (CatalogueLifecycleRequest)`
- `GovernanceApprovals (GovernanceApproval)`
- `GovernanceTestCases (GovernanceTestCase)`
- `GovernanceTestExecutions (GovernanceTestExecution)`
- `StockMovements (StockMovement)`
- `StockTransferRequests (StockTransferRequest)`
- `StockTransferRequestLines (StockTransferRequestLine)`

Relevant API/UI/test areas found in the repository include:
- Catalogue and generic product governance: `src/Sgsctr.Api/PharmacyCatalogue/`, `web/app/pharmacies/inventory/CatalogueManager.tsx`, `ProductGovernanceManager.tsx`.
- Locations, units and product conversions: `OrganizationLocation`, `UnitOfMeasure`, `ProductUnitConversion`.
- Draft supplier intake and assurance records: `src/Sgsctr.Api/PharmacySuppliers/`, `SupplierRegister.tsx`, `SupplierOnboardingIntake.tsx`, `SupplierAssuranceWorkflows.tsx`.
- Draft receipt intake: `PharmacyReceiptDraft`, `PharmacyReceiptDraftLine`, `ReceivingDraftManager.tsx`.
- Stock movement ledger and transfer requests: `StockMovement`, `StockTransferRequest`, `StockTransferRequestLine`, inventory API extensions and rule tests.
- Regulatory intelligence: `RegulatorySource`, `RegulatoryDocument`, `RegulatoryAlert`, `RegulatoryScanRun`.

These are partial foundations and gated workflows, not evidence that the full Future 25 functional scope already exists. In particular, no Pharmacy GL posting, approved valuation/costing engine, patient dispensing/sales, claims settlement, payroll, fixed assets, or complete purchasing/PO workflow was found in the inspected AppDbContext/API inventory.

## 2. Source confidence and limitations

Confidence labels from the legacy analysis must be preserved:
- **[O] Observed** in static files, SQL text, PE/shortcut metadata, or object inventories.
- **[I] Inferred** from names, embedded SQL, relationships, configuration, or static patterns.
- **[U] Unknown** without runtime traces, live DB access, or PBD decompilation.

Source method and limits:
1. The legacy database is identified as Adaptive Server Anywhere / SQL Anywhere 9.0.2.2451.
2. DDL was recovered from a translated transaction log; it was not exported from an authenticated live catalog.
3. The legacy program is a PowerBuilder 9 desktop ERP/POS system with compiled PBD libraries, Windows ODBC/DSN configuration and a PowerBuilder runtime. A VB6 launcher exists in some copies; other copies start the PB executable directly.
4. MobiLink is inferred from SQL Anywhere metadata. Exact sync topology, conflicts and runtime behavior are not proven.
5. No executable was launched; no original file was modified. PBD business logic was not decompiled. UI maps are static object inventories, not verified click-by-click user journeys.
6. The REA evidence JSON contains 8 artifact records and 16 evidence records; it has no captured runtime scenarios. Its binary hashes and static metadata are not proof of business behavior or current production state.
7. Some source documents report different object totals because they use different copies, object extraction methods, or unique-object counting. Treat each count in its source context; do not combine them as if they were one runtime census.

## 3. Legacy functional-to-SGSCTR workflow reconciliation

| Legacy capability / workflow | Legacy evidence | Current SGSCTR evidence | Reconciliation / disposition |
|---|---|---|---|
| **Application startup / launcher / PowerBuilder runtime / INI / ODBC** | Legacy confirmed static architecture [O] | Not applicable to new stack; current SGSCTR uses ASP.NET Core API + PostgreSQL + Next.js web client | Rebuild operational intent, not launcher/INI/ODBC implementation. |
| **Company, branch, store and fiscal context** | Company/store/company-store hierarchy in schema; fiscal period and cost-center setup | OrganizationLocation exists; current app model has location metadata, not full company/store/fiscal hierarchy | Map legal entity, sector, site, licence holder, stock owner and operational location separately; approvals/documents pending. |
| **Product and item master** | ITEM_MASTER, ITEM_* families, unit, alternate/replacement, vendor/price and category tables | CatalogueProduct, UnitOfMeasure, ProductUnitConversion and governance entities; generic Draft-only UI/API | Candidate conceptual mapping only; product taxonomy, category-specific attributes, identifiers and professional classification remain pending. |
| **Supplier master and qualification** | VENDOR, COMPANY_VENDORS, ITEM_COMPANY_VENDOR and quotation/terms tables | PharmacySupplier + declaration/evidence/contact/due-diligence/review/assurance draft records | Supplier records remain Draft/Unverified/Pending; no approval or purchasing eligibility implied. |
| **RFQ, requisition, demand, purchase order** | REQUEST_FOR_QUOTATION, VENDOR_QUOTATION*, REQUISITION*, PURCHASE_ORDER* | No approved PO/RFQ aggregate or supplier commitment/posting flow | Not implemented as operational purchasing; needs owner/procurement/accountant/pharmacist approval. |
| **Receiving and supplier returns** | RATR_TRANSACTION*, balance_recieve*, balance_ret_rec*, purchase order store lines | PharmacyReceiptDraft + lines (Draft-only); StockMovement types include receipt/return | Draft intake is not receiving acceptance, lot release, supplier return or valuation. |
| **Stock ledger, balances, issues, counts, adjustments** | ITEM_STORE_COMPANY, system_balance, issue_trans*, balance_issue*, balance_adjustment, count/trace tables | StockMovement ledger and rules; posted movements contribute to balance; API/test coverage exists | Current model is a technical baseline; product family, lot/expiry, negative stock, custody and valuation rules remain unapproved. |
| **Inter-branch transfers** | balance_transf_in/out, reference_for_transfer_between_branches, organize_follow_up_transfers, branch/store tables | StockTransferRequest + lines; draft/submission/approval states; approval creates draft movements | Owner confirmed direct branch-to-branch capability; workflow/policy approval pending; no cost transfer policy inferred. |
| **Sales / dispensing / customer orders** | sales_order*, SALES*, CUSTOMER*, price/promotion and item-customer tables | No pharmacy dispensing or patient-sale aggregate/workflow found in current AppDbContext/API | Do not equate legacy retail sales with dispensing; four module flows and dispensing scope need owner/pharmacist decisions. |
| **Claims and payer settlement** | claim_header/detail, prepare_claim, financial_claim_setup, contract and customer contract objects | No claim/payer aggregate, submission, remittance or patient-balance API found | Not implemented; agreement-specific coverage/copay/discount order and professional approval remain pending. |
| **GL, journals, chart of accounts, periods, banks** | GL_*, CHART_OF_ACCOUNTS, COMPANY_CHART_OF_ACCOUNT, GL_PERIOD, bank tables | No pharmacy GL/financial posting entities in AppDbContext | No posting/valuation/tax/accounting implementation authorized; separate operational modules must not be treated as four legal entities. |
| **Cost centers, budgets and job costing** | COST_CENTERS, COMPANY_COST_CENTERS, GL_COST_CENTER_*, GL_BUDGET, CST_JOB_ORDER_* | No cost-center/budget/job-cost entities in current AppDbContext | Cross-cutting framework candidate; accounting owner must approve dimensions, allocation and reporting. |
| **Payroll / HR** | EMPLOYEE, attendance, PAYSLIP, salary, benefits, deductions, medical insurance | No Pharmacy payroll entities | Non-pharmacy/ shared platform question Q66; not part of the four pharmacy modules by default. |
| **Fixed assets** | fa_asset_* and depreciation journal objects | No fixed-asset entities | Non-pharmacy/shared platform question Q66; defer. |
| **Reports, printing, barcode, POS devices** | PowerBuilder report/DataWindow libraries, printer/device configuration and SQL reports | Current web workspaces for catalogue, inventory, supplier, governance and regulatory intelligence | Rebuild required business reports with verified outputs; device integrations not evidenced as implemented. |
| **Branch synchronization, backup and recovery** | MobiLink inferred from metadata; transaction log and backup INI settings | Current deployment/backup foundations documented separately; no legacy MobiLink port | Do not copy MobiLink; define API/outbox only if approved; test backup/restore separately. |
| **Identity, permissions and audit** | SECURITY_USERS, SECURITY_GROUPINGS, USER_COMPANY, USER_COMPANY_STORE and security templates | Native identity/security foundations; pharmacy endpoints use authorization policies; domain audit entities | Map roles and scopes to SGSCTR policy; no legacy password/hash/session equivalence asserted. |

## 4. Four-module boundary application

Option B remains the owner-selected Pharmacy model. Legacy table names do not decide which pharmacy module owns a record. Every pharmacy-owned concept must be assigned explicitly to one or more of the four operational modules, or to a shared Pharmacy capability with a documented reason.

| Legacy concept family | Permitted mapping direction | Boundary rule |
|---|---|---|
| Item/product master and product attributes | Shared Pharmacy catalogue foundation, with module-specific classification only after approval | One product identity model may serve the four modules; do not assume common mandatory attributes or regulatory classifications. |
| Stock/location/lot/expiry | Module-owned stock records and shared location/reference capability, subject to approved ownership model | Every movement and balance must retain its owning module; shared visibility does not mean shared stock ownership. |
| Purchasing and receiving | Candidate shared procurement service with module-attributed lines, only after owner approval | Do not combine procurement commitments, receipt acceptance, lot release and financial posting into one unreviewed action. |
| Dispensing/sales | Module-specific operational workflow | Do not reuse generic legacy retail sales rules without pharmacist-approved workflow and payer/patient requirements. |
| Claims/contracts | Shared contract/payer capability only if explicitly approved; transactions attributable to module | Contract discount, payer coverage, patient copay, exemption, claim amount and remittance are distinct events. |
| Costing/accounting | Cross-cutting finance capability with module attribution | Four modules do not imply four legal entities, four statutory ledgers or independent statutory companies. No accounting policy is approved by this mapping. |
| Regulatory evidence | Shared regulatory intelligence with product/module applicability recorded | Regulatory applicability must be reviewed by qualified Egyptian professionals; AI/source ingestion is evidence intake, not legal determination. |
| Payroll/fixed assets/general ERP | Shared platform / other sector / future scope decision | These are not automatically Pharmacy modules. See Q66 and owner decision gate. |

## 5. Exhaustive legacy table inventory and first-pass disposition

This section includes every CREATE TABLE name recovered from `future25_schema.sql`. Column counts and functional-area labels are copied from the schema report where available. The mapping classification is a first-pass disposition based on table naming and source functional area; it is **not** a claim of semantic equivalence. The full field-level mapping must inspect column definitions, keys, indexes, all relationships, source SQL and UI evidence before any migration design is approved.

| Legacy table | Columns | Source area | Initial target disposition | SGSCTR handling / constraint |
|---|---:|---|---|---|
| `DBA.pbcatcol` | 20 | System / PowerBuilder / MobiLink support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.pbcatfmt` | 4 | System / PowerBuilder / MobiLink support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.pbcatvld` | 5 | System / PowerBuilder / MobiLink support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.pbcatedt` | 7 | System / PowerBuilder / MobiLink support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.DW_SPECS` | 2 | System / PowerBuilder / MobiLink support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.CHOICE_TYPES` | 2 | System / PowerBuilder / MobiLink support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.CHOICE_SPECS` | 4 | System / PowerBuilder / MobiLink support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.DW_COLUMN_SPECS` | 5 | System / PowerBuilder / MobiLink support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.CHOICE_DWO` | 3 | System / PowerBuilder / MobiLink support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.CHOICE_MODIFIED_COLUMNS` | 7 | System / PowerBuilder / MobiLink support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.COLUMN_DEPENDENCIES` | 4 | System / PowerBuilder / MobiLink support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.STORE_TYPES` | 8 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.CURRENCY` | 8 | Accounting / finance | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.COUNTRY` | 21 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.ITEM_GROUPS` | 21 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.COST_CENTERS` | 22 | Accounting / finance | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.ORGANIZATION_CHART` | 22 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.COMPANY_TYPE` | 7 | Setup / security | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.COMPANY_NATURE` | 9 | Setup / security | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.PRICE_TYPE` | 8 | Sales / customers | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.ITEM_UNIT` | 8 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.ITEM_NATURE` | 8 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.ITEM_MODEL` | 9 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.ITEM_COLOR` | 9 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.ITEM_SIZE` | 9 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.INDUSTRY` | 7 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.SECTORS` | 7 | Setup / security | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.LANGUAGE` | 8 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.STORES` | 20 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.VENDOR` | 40 | Purchasing | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.COMPANY` | 66 | Setup / security | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.COMPANY_STORES` | 16 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.COMPANY_VENDORS` | 42 | Purchasing | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.CUSTOMER_COMAPNY` | 48 | Sales / customers | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.COMPANY_SALESMAN` | 12 | Sales / customers | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.ITEM_STORE_COMPANY` | 53 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.ITEM_COMPANY_VENDOR` | 14 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.ITEM_MASTER` | 104 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.CUSTOMER` | 71 | Sales / customers | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.CURRENCY_EXCHANGE` | 11 | Accounting / finance | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.COMPANY_COST_CENTERS_ORG` | 20 | System / PowerBuilder / MobiLink support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.ITEM_UNITS_CONVERSION` | 8 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.ITEM_COMPANY_PRICE` | 20 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.ALTERNATE_ITEM` | 8 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.DRUG_INTERACTION_ITEM` | 7 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.CUR_DETAIL_TABLE` | 37 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.ORDERS_QUANTITY_TABLE` | 9 | System / PowerBuilder / MobiLink support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.COMPANY_STORES_SERIALS` | 11 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.SYSTEM_MESSAGES` | 8 | Setup / security | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.SERIALS` | 2 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.TABLE_SPECS` | 5 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.SALESMAN` | 33 | Sales / customers | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.TABLE_COLUMNS_SPECS` | 8 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.UNIQUE_COLUMNS` | 8 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.ORDERS_HEADER_TABEL` | 15 | System / PowerBuilder / MobiLink support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.ORDER_LINES_TABLE` | 17 | Purchasing | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.ITEM_STORE_COMPANY_EXPIRY` | 9 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.REQUEST_FOR_QUOTATION` | 14 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.VENDOR_QUOTATION` | 17 | Purchasing | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.REQUISITION_HEADER` | 18 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.PURCHASE_ORDER_HEADER` | 44 | Purchasing | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.DEMAND_REPORT_HEADER` | 9 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.ITEM_RFQ` | 13 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.VENDOR_QUOTATION_ITEMS` | 15 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.REQUISITION_ITEMS` | 14 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.PURCHASE_ORDER_ITEMS` | 35 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.DEMAND_REPORT_VENDORS` | 14 | Purchasing | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.DEMAND_REPORT_REQ` | 9 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.DEMAND_REPORT_ITEMS` | 13 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.MODULES` | 8 | Setup / security | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.MODULE_LANGUAGE` | 7 | Setup / security | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.MODULE_LANG_TRAN_TYPE_1` | 9 | Setup / security | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.MODULE_TRANSACTIONS` | 11 | Setup / security | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.MODULE_LANG_TRAN_TYPE_2` | 9 | Setup / security | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.RATR_TRANSACTION_HEADER` | 46 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.RATR_TRANSACTION_HEADER_PO` | 13 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.RATR_TRANSACTION_HEADER_COST` | 14 | Accounting / finance | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.SHIFTS` | 8 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.LAST_SHIFT` | 9 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.SHIFTS_MONEY` | 75 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.COMPANY_SERIALS` | 10 | Setup / security | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.SECURITY_USERS` | 6 | Setup / security | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.USER_COMPANY` | 3 | Setup / security | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.SECURITY_GROUPINGS` | 2 | Setup / security | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.RATR_TRANSACTION_ITEMS` | 44 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.YEAR_COMPANY_VENDOR` | 16 | Purchasing | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.YEAR_ITEM_STORE_COMPANY` | 17 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.YEAR_CUSTOMER_COMPANY` | 16 | Sales / customers | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.CURRENT_SETTINGS` | 16 | Setup / security | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.ITEM_COMPANY` | 58 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.ITEM_TYPE` | 9 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.CUSTOMER_ITEM_GROUP_DISCOUNT` | 18 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.GL_LABEL` | 6 | Accounting / finance | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.BANKS` | 8 | Accounting / finance | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.BANK_ACCOUNT_TYPES` | 8 | Accounting / finance | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.ACCOUNT_CHART_TREE` | 22 | Accounting / finance | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.COMPANY_COST_CENTERS` | 19 | Accounting / finance | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.COMPANY_CHART_OF_ACCOUNT` | 33 | Accounting / finance | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.COMPANY_ACCOUNT_CHART_TREE` | 12 | Accounting / finance | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.GL_JOURNAL_VOUCHER_HEADER` | 37 | Accounting / finance | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.GL_PAPAER` | 35 | Accounting / finance | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.GL_INTEGERATION_ACCOUNTS` | 15 | Accounting / finance | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.GL_COST_CENTER_SUMMERY` | 15 | Accounting / finance | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.CHART_OF_ACCOUNTS` | 24 | Accounting / finance | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.GL_NOTES_MODIFICATIONS` | 13 | Accounting / finance | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.GL_JV_SUMMERY` | 15 | Accounting / finance | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.GL_COST_CENTER_DETAIL` | 18 | Accounting / finance | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.GL_PERIOD` | 8 | Accounting / finance | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.MODULE_TRANSACTIONS_GL_ACCOUNT` | 27 | Accounting / finance | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.WORK_STATION_COMPANY` | 9 | Setup / security | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.COMPANY_MODULES` | 4 | Setup / security | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.COMPANY_BANK_ACCOUNTS` | 10 | Accounting / finance | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.BANK_ACCOUNT_TRANSACTION` | 16 | Accounting / finance | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.GL_BANK_DETAIL_SUMMARY` | 17 | Accounting / finance | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.GL_JOURNAL_VOUCHER_DETAIL` | 45 | Accounting / finance | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.GL_VOUCHER_DETAIL_DIST` | 30 | Accounting / finance | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.CUR_FACILITY_TABLE` | 34 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.PROMOTION_HEADER` | 14 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.FOOD` | 7 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.REPLACEMENT_ITEM` | 9 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.SALES_TAX_TRANSACTION` | 15 | Accounting / finance | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.FOOD_DRUG_INTERACTION` | 7 | Payroll / HR | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.ITEM_CUSTOMER` | 7 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.ITEM_COMPANY_VENDOR_PRICE` | 14 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.ITEM_COMPANY_CUSTOMER_PRICE` | 14 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.GROUP_CUSTOMER_PRICE` | 16 | Sales / customers | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.PROMOTION_ITEMS_DETAIL` | 8 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.PROMOTION_GROUB_DETAIL` | 13 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.CUR_FACILITY_ITEM_DISCOUNT` | 14 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.CUR_FACILITY_GROUP_DISCOUNT` | 19 | Sales / customers | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.CUSTOMER_OPEN_BAL` | 9 | Sales / customers | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.VENDOR_OPEN_BAL` | 9 | Purchasing | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.CHART_OPEN_BAL` | 9 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.EDUCATION_SEPC` | 22 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.BENEFIT` | 7 | Payroll / HR | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.JOB_TITLE` | 7 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.SOCIAL_STATUS` | 9 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.NATIONALITY` | 7 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.CAUSE` | 8 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.ALLOWAN_DEDUC_GROUP` | 7 | Payroll / HR | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.EMPLOYEE` | 68 | Payroll / HR | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.WORKING_CALENDER` | 27 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.ATTENDANCE_SHEET` | 19 | Payroll / HR | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.ALLOWAN_DEDUCTION` | 21 | Payroll / HR | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.SALARY_TIME_EFFECT` | 14 | Sales / customers | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.INSURANCE_TAX` | 30 | Accounting / finance | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.GENERAL_RULE` | 57 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.HOLIDAY` | 10 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.EMP_WORKING_CALENDER` | 8 | Payroll / HR | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.GL_BALANCE_SHEET_SETUP` | 31 | Accounting / finance | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.GL_BALANCE_SHEET_CALC` | 16 | Accounting / finance | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.ITEM_STORE_OPEN_BAL` | 17 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.MANUAL_IN_OUT` | 8 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.COMP_HOLIDAY_RULE_MASTER` | 8 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.COMP_HOLIDAY_RULE_DETAIL` | 10 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.TIME_DESIGNATOR_DAILY` | 15 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.LIVELS_CODES` | 7 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.GL_PAPER_COLLECTION_HEADER` | 13 | Accounting / finance | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.GL_PAPER_COLLECTION_DETAIL` | 18 | Accounting / finance | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.EMP_HOLIDAY_BALANCE` | 8 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.EMP_HOLIDAY_OB` | 8 | Payroll / HR | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.SECURITY_INFO` | 4 | Setup / security | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.SYSTEM_PARAMETER` | 12 | Setup / security | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA."WINDOW"` | 3 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.SECURITY_TEMPLATE` | 4 | Payroll / HR | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.ALLOWANCES_ACCUMULATION_HEADER` | 14 | Accounting / finance | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.GIFTS_AND_BONUS` | 22 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.TIME_SHEET_TRANSACTION` | 24 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.ALLOWANCES_ACCUMULATION_DETAIL` | 9 | Accounting / finance | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.EMP_ALL_DED` | 9 | Payroll / HR | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.REPEATED_TRANSACTION` | 18 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.EMP_ALL_DED_EDIT_VALUE` | 10 | Payroll / HR | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.FIAT_TABLE` | 7 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.EMP_BANKS` | 11 | Accounting / finance | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.EMP_BENEFITS` | 10 | Payroll / HR | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.EMP_TEMP_TABLE2` | 16 | Payroll / HR | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.PAYSLIP_CALC_MONTH` | 9 | Payroll / HR | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.PAYSLIP_MONTHLY` | 11 | Payroll / HR | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.payslip_monthly_copy` | 17 | Payroll / HR | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.PAYSLIP_REPORT_TEMP_TABLE` | 26 | Payroll / HR | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.WORK_STATION` | 7 | Setup / security | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.PAYSLIP_SHEET_SETUP` | 8 | Payroll / HR | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.ITEM_STORE_OPEN_BAL_DETAIL` | 11 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.MEDICAL_INS_TREE` | 22 | Payroll / HR | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.COM_MEDICAL_INS` | 20 | Payroll / HR | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.EMP_MEDICAL_INS` | 8 | Payroll / HR | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.USER_COMPANY_STORE` | 4 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.payroll_jv_acc_header_setup` | 15 | Accounting / finance | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.PAYROLL_JV_ACC_LINES_SETUP` | 10 | Accounting / finance | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.OPEN_BAL_ITEM_COMPANY` | 8 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.GL_BUDGET` | 10 | Accounting / finance | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.ITEM_PURCHASE_HIST` | 14 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.PAY_SLIP_SETUP` | 15 | Payroll / HR | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.YEARLY_INCREASE_HEADER` | 11 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.YEARLY_INCREASE_DETAIL` | 10 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.PAY_SLIP_CALC` | 11 | Payroll / HR | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.PURCHASE_ORDER_STORE_ITEMS` | 19 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.CST_JOB_ORDER_HEADER` | 33 | Accounting / finance | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.CST_JOB_ORDER_DETAIL` | 16 | Accounting / finance | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.ITEM_SEASON` | 9 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.ITEM_GENDER` | 9 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.ITEM_CATEGORY` | 9 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.STORE_DATE_SERIAL` | 7 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.ITEM_COMPANY_STORE_PRICE` | 17 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `"backup".pbcattbl` | not reported | Unclassified in report | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `"backup".pbcatcol` | not reported | Unclassified in report | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `"backup".pbcatfmt` | not reported | Unclassified in report | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `"backup".pbcatvld` | not reported | Unclassified in report | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `"backup".pbcatedt` | not reported | Unclassified in report | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.ITEM_BOUNS_HEADER` | 22 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.ITEM_BOUNS_DETAIL` | 13 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.ISSUE_TRANS_HEADER_EXT` | 39 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.fa_asset_class` | 51 | Fixed assets | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.fa_asset_card` | 34 | Fixed assets | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.fa_asset_serials` | 3 | Fixed assets | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.fa_asset_setup` | 17 | Fixed assets | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.fa_asset_trans_header` | 20 | Fixed assets | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.fa_asset_trans_detail` | 53 | Fixed assets | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.fa_dep_journal_voucher_detail` | 25 | Accounting / finance | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.equation_in_parameters` | 13 | Setup / security | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.equation_setup` | 19 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.equation_setup_journal` | 14 | Accounting / finance | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.matrix_setup` | 19 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.gl_balance_sheet_setup_detail` | 6 | Accounting / finance | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.hire_type` | 4 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.ins_off_table` | 10 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.characteristic_def` | 11 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.balance_adjustment` | 18 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.balance_issue_rm` | 18 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.balance_issue` | 18 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.balance_recieve` | 18 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.balance_ret_issue` | 18 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.balance_ret_rec` | 18 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.balance_transf_in` | 18 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.balance_transf_out` | 18 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.system_balance` | 38 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.issue_trans_header` | 61 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.issue_transaction_items` | 38 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.account_autogenerator_case` | 8 | Accounting / finance | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.balance_issue1` | 21 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.balance_recieve1` | 21 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.balance_ret_issue1` | 21 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.balance_ret_rec1` | 21 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.issue_trans_items_ext` | 29 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.store_date_serial_ext` | 9 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.issue_types` | 5 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.company_trans_type3` | 18 | Setup / security | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.characteristic_def_table` | 4 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.Future_menus` | 26 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.vendor_b2b` | 3 | Purchasing | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.item_new` | 19 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.updated_items` | 15 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.manufactures` | 5 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.item_matched` | 4 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.ITEM_COMPANY_VENDOR_1` | 14 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.characteristic_rep_form_h` | 11 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.characteristic_rep_form_i` | 9 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.purchase_order_send` | 3 | Purchasing | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.shortcut_setup` | 12 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.customer_ext` | 21 | Sales / customers | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.diseases` | 10 | Payroll / HR | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.cus_diseases` | 9 | Payroll / HR | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.class` | 1 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.script_status` | 4 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.sales_order_header` | 24 | Purchasing | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.sales_order_items` | 16 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.customer_complain_inquire` | 14 | Sales / customers | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.b2b_settings` | 2 | Setup / security | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.branch_items` | 8 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.branch_items_temp` | 6 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.ip_settings` | 2 | Setup / security | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.lupdate` | 4 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.newcodes` | 7 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.promotion` | 12 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.promotion_temp` | 9 | Payroll / HR | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.quta` | 13 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.item_store_comp_ven_followup` | 9 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.item_vendor_dowload` | 34 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.branches` | 5 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.sales_order_followup` | 21 | Purchasing | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.item_vendor_dowload_temp` | 34 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.item_cus_issue_hist` | 10 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.datawindow_character` | 16 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.contract_master` | 26 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.contract_detail` | 23 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.cus_contract` | 14 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.item_lacks` | 13 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.foad` | 9 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.trans_details` | 5 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.t_db` | 2 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.apsent_dates` | 3 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.salary_transaction_header` | 14 | Sales / customers | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.salary_transaction_detail` | 15 | Sales / customers | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.item_lacks_local` | 10 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.item_chek_qty` | 10 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.update_item_balance` | 8 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.isc_from_transaction` | 12 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.item_exp_errors_from_issue_and_ratr` | 11 | System / PowerBuilder / MobiLink support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.isc_exp_from_transaction` | 13 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.item_errors_from_issue_and_ratr` | 12 | System / PowerBuilder / MobiLink support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.licenses_modules` | 8 | Setup / security | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.reference_for_transfer_between_branches` | 14 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.ratr_transaction_header_temp` | 46 | Payroll / HR | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.ratr_transaction_items_temp` | 44 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.sysuserperm` | 8 | Setup / security | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.organize_follow_up_transfers` | 8 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.bal_trace` | 12 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.print_foter_txt` | 5 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.financial_claim_setup` | 29 | Accounting / finance | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.claim_header` | 16 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.claim_detail` | 17 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.prepare_claim` | 9 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.organize_prepare_claim` | 7 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.menus_tabes` | 3 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.claim_print_followup` | 5 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.iss_header_print_followup` | 8 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.com_job` | 15 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.trans_items` | 2 | Inventory / stores | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.alico` | 7 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.credit_report` | 5 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |
| `DBA.shift_report` | 12 | Application / support | Application/support; ownership unresolved | Determine whether pharmacy, shared platform, other sector, reporting, or obsolete support before implementation. |

## 6. Recovered foreign-key relationship inventory

The following 475 foreign-key clauses are included as recovered. They are structural evidence only; do not assume each relation represents a valid business invariant in the new domain. Source database naming, nullable behavior, delete/update rules and transaction semantics must be reviewed before modeling.

| # | Child table | Child columns | Referenced table | Referenced columns |
|---:|---|---|---|---|
| 1 | `DBA.CHOICE_SPECS` | `DS_DWO_NAME` | `DBA.DW_SPECS` | `DS_DWO_NAME` |
| 2 | `DBA.CHOICE_SPECS` | `CHT_TYPE_NAME` | `DBA.CHOICE_TYPES` | `CHT_TYPE_NAME` |
| 3 | `DBA.DW_COLUMN_SPECS` | `DS_DWO_NAME` | `DBA.DW_SPECS` | `DS_DWO_NAME` |
| 4 | `DBA.DW_COLUMN_SPECS` | `CHO_DS_DWO_NAME,CHS_CHOICE_CODE` | `DBA.CHOICE_SPECS` | `DS_DWO_NAME,CHS_CHOICE_CODE` |
| 5 | `DBA.CHOICE_DWO` | `DS_DWO_NAME,CHS_CHOICE_CODE` | `DBA.CHOICE_SPECS` | `DS_DWO_NAME,CHS_CHOICE_CODE` |
| 6 | `DBA.CHOICE_MODIFIED_COLUMNS` | `DS_DWO_NAME,CHS_CHOICE_CODE` | `DBA.CHOICE_SPECS` | `DS_DWO_NAME,CHS_CHOICE_CODE` |
| 7 | `DBA.CHOICE_MODIFIED_COLUMNS` | `CHO_DS_DWO_NAME,CHO_CHS_CHOICE_CODE,CDW_DWO_NAME` | `DBA.CHOICE_DWO` | `DS_DWO_NAME,CHS_CHOICE_CODE,CDW_DWO_NAME` |
| 8 | `DBA.COLUMN_DEPENDENCIES` | `DS_DWO_NAME,DCS_COLUMN_NAME` | `DBA.DW_COLUMN_SPECS` | `DS_DWO_NAME,DCS_COLUMN_NAME` |
| 9 | `DBA.COLUMN_DEPENDENCIES` | `DW__DS_DWO_NAME,DW__DCS_COLUMN_NAME` | `DBA.DW_COLUMN_SPECS` | `DS_DWO_NAME,DCS_COLUMN_NAME` |
| 10 | `DBA.COUNTRY` | `COU_PARENT_CODE_L1,COU_PARENT_CODE_L2,COU_PARENT_CODE_L3,COU_PARENT_CODE_L4,COU_PARENT_CODE_L5,COU_PARENT_CODE_L6` | `DBA.COUNTRY` | `COU_CODE_L1,COU_CODE_L2,COU_CODE_L3,COU_CODE_L4,COU_CODE_L5,COU_CODE_L6` |
| 11 | `DBA.ITEM_GROUPS` | `ITG_CODE_L1,ITG_CODE_L2,ITG_CODE_L3,ITG_CODE_L4,ITG_CODE_L5,ITG_CODE_L6` | `DBA.ITEM_GROUPS` | `ITG_CODE_L1,ITG_CODE_L2,ITG_CODE_L3,ITG_CODE_L4,ITG_CODE_L5,ITG_CODE_L6` |
| 12 | `DBA.COST_CENTERS` | `COC_PARENT_CODE_L1,COC_PARENT_CODE_L2,COC_PARENT_CODE_L3,COC_PARENT_CODE_L4,COC_PARENT_CODE_L5,COC_PARENT_CODE_L6` | `DBA.COST_CENTERS` | `COC_CODE_L1,COC_CODE_L2,COC_CODE_L3,COC_CODE_L4,COC_CODE_L5,COC_CODE_L6` |
| 13 | `DBA.ORGANIZATION_CHART` | `ORG_PARENT_CODE_L1,ORG_PARENT_CODE_L2,ORG_PARENT_CODE_L3,ORG_PARENT_CODE_L4,ORG_PARENT_CODE_L5,ORG_PARENT_CODE_L6` | `DBA.ORGANIZATION_CHART` | `ORG_CODE_L1,ORG_CODE_L2,ORG_CODE_L3,ORG_CODE_L4,ORG_CODE_L5,ORG_CODE_L6` |
| 14 | `DBA.STORES` | `STT_CODE` | `DBA.STORE_TYPES` | `STT_CODE` |
| 15 | `DBA.STORES` | `COU_CODE_L1,COU_CODE_L2,COU_CODE_L3,COU_CODE_L4,COU_CODE_L5,COU_CODE_L6` | `DBA.COUNTRY` | `COU_CODE_L1,COU_CODE_L2,COU_CODE_L3,COU_CODE_L4,COU_CODE_L5,COU_CODE_L6` |
| 16 | `DBA.STORES` | `CHRT_SERIAL` | `DBA.CHART_OF_ACCOUNTS` | `CHRT_SERIAL` |
| 17 | `DBA.STORES` | `br_serial` | `DBA.branches` | `br_serial` |
| 18 | `DBA.VENDOR` | `CUR_CODE` | `DBA.CURRENCY` | `CUR_CODE` |
| 19 | `DBA.VENDOR` | `COU_CODE_L1,COU_CODE_L2,COU_CODE_L3,COU_CODE_L4,COU_CODE_L5,COU_CODE_L6` | `DBA.COUNTRY` | `COU_CODE_L1,COU_CODE_L2,COU_CODE_L3,COU_CODE_L4,COU_CODE_L5,COU_CODE_L6` |
| 20 | `DBA.VENDOR` | `HOLDING_VEN_SERIAL` | `DBA.VENDOR` | `VEN_SERIAL` |
| 21 | `DBA.VENDOR` | `CHRT_SERIAL` | `DBA.CHART_OF_ACCOUNTS` | `CHRT_SERIAL` |
| 22 | `DBA.COMPANY` | `CUR_CODE` | `DBA.CURRENCY` | `CUR_CODE` |
| 23 | `DBA.COMPANY` | `CTY_CODE` | `DBA.COMPANY_TYPE` | `CTY_CODE` |
| 24 | `DBA.COMPANY` | `CNA_CODE` | `DBA.COMPANY_NATURE` | `CNA_CODE` |
| 25 | `DBA.COMPANY` | `COM_HOLDING_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 26 | `DBA.COMPANY_STORES` | `STO_CODE` | `DBA.STORES` | `STO_CODE` |
| 27 | `DBA.COMPANY_STORES` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 28 | `DBA.COMPANY_STORES` | `COM_CODE,CCC_COST_SERIAL` | `DBA.COMPANY_COST_CENTERS` | `COM_CODE,CCC_COST_SERIAL` |
| 29 | `DBA.COMPANY_STORES` | `COM_CODE,SAFE_CHRT_SERIAL` | `DBA.COMPANY_CHART_OF_ACCOUNT` | `COM_CODE,CHRT_SERIAL` |
| 30 | `DBA.COMPANY_STORES` | `COM_CODE,CHRT_SERIAL` | `DBA.COMPANY_CHART_OF_ACCOUNT` | `COM_CODE,CHRT_SERIAL` |
| 31 | `DBA.COMPANY_STORES` | `m_change_item` | `DBA.ITEM_MASTER` | `ITM_SERIAL` |
| 32 | `DBA.COMPANY_VENDORS` | `COM_CODE,CHRT_SERIAL` | `DBA.COMPANY_CHART_OF_ACCOUNT` | `COM_CODE,CHRT_SERIAL` |
| 33 | `DBA.COMPANY_VENDORS` | `VEN_SERIAL` | `DBA.VENDOR` | `VEN_SERIAL` |
| 34 | `DBA.COMPANY_VENDORS` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 35 | `DBA.COMPANY_VENDORS` | `COM_CODE,CUS_SERIAL` | `DBA.CUSTOMER_COMAPNY` | `COM_CODE,CUS_SERIAL` |
| 36 | `DBA.CUSTOMER_COMAPNY` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 37 | `DBA.CUSTOMER_COMAPNY` | `COM_CODE,VEN_SERIAL` | `DBA.COMPANY_VENDORS` | `COM_CODE,VEN_SERIAL` |
| 38 | `DBA.CUSTOMER_COMAPNY` | `CUS_SERIAL` | `DBA.CUSTOMER` | `CUS_SERIAL` |
| 39 | `DBA.CUSTOMER_COMAPNY` | `SAL_SAL_SERIAL,COM_CODE` | `DBA.SALESMAN` | `SAL_SERIAL,COM_CODE` |
| 40 | `DBA.CUSTOMER_COMAPNY` | `DIST_SAL_SERIAL,COM_CODE` | `DBA.SALESMAN` | `SAL_SERIAL,COM_CODE` |
| 41 | `DBA.CUSTOMER_COMAPNY` | `COM_CODE,CHRT_SERIAL` | `DBA.COMPANY_CHART_OF_ACCOUNT` | `COM_CODE,CHRT_SERIAL` |
| 42 | `DBA.COMPANY_SALESMAN` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 43 | `DBA.ITEM_STORE_COMPANY` | `COM_CODE,STO_CODE` | `DBA.COMPANY_STORES` | `COM_CODE,STO_CODE` |
| 44 | `DBA.ITEM_STORE_COMPANY` | `ITM_SERIAL,COM_CODE` | `DBA.ITEM_COMPANY` | `ITM_SERIAL,COM_CODE` |
| 45 | `DBA.ITEM_STORE_COMPANY` | `ITT_CODE` | `DBA.ITEM_TYPE` | `ITT_CODE` |
| 46 | `DBA.ITEM_STORE_COMPANY` | `COM_CODE,CHRT_SERIAL` | `DBA.COMPANY_CHART_OF_ACCOUNT` | `COM_CODE,CHRT_SERIAL` |
| 47 | `DBA.ITEM_COMPANY_VENDOR` | `COM_CODE,VEN_SERIAL` | `DBA.COMPANY_VENDORS` | `COM_CODE,VEN_SERIAL` |
| 48 | `DBA.ITEM_COMPANY_VENDOR` | `ITM_SERIAL,COM_CODE` | `DBA.ITEM_COMPANY` | `ITM_SERIAL,COM_CODE` |
| 49 | `DBA.ITEM_COMPANY_VENDOR` | `ITU_CODE` | `DBA.ITEM_UNIT` | `ITU_CODE` |
| 50 | `DBA.ITEM_MASTER` | `ITG_CODE_L1,ITG_CODE_L2,ITG_CODE_L3,ITG_CODE_L4,ITG_CODE_L5,ITG_CODE_L6` | `DBA.ITEM_GROUPS` | `ITG_CODE_L1,ITG_CODE_L2,ITG_CODE_L3,ITG_CODE_L4,ITG_CODE_L5,ITG_CODE_L6` |
| 51 | `DBA.ITEM_MASTER` | `ITU_PURCHASE_CODE` | `DBA.ITEM_UNIT` | `ITU_CODE` |
| 52 | `DBA.ITEM_MASTER` | `ITU_STORED_CODE` | `DBA.ITEM_UNIT` | `ITU_CODE` |
| 53 | `DBA.ITEM_MASTER` | `ITU_SMALL_ISSUE_CODE` | `DBA.ITEM_UNIT` | `ITU_CODE` |
| 54 | `DBA.ITEM_MASTER` | `ITU_MEDIUM_ISSUE_CODE` | `DBA.ITEM_UNIT` | `ITU_CODE` |
| 55 | `DBA.ITEM_MASTER` | `ITU_LARGE_ISSUE_CODE` | `DBA.ITEM_UNIT` | `ITU_CODE` |
| 56 | `DBA.ITEM_MASTER` | `ITN_CODE` | `DBA.ITEM_NATURE` | `ITN_CODE` |
| 57 | `DBA.ITEM_MASTER` | `IMO_CODE` | `DBA.ITEM_MODEL` | `IMO_CODE` |
| 58 | `DBA.ITEM_MASTER` | `ITC_CODE` | `DBA.ITEM_COLOR` | `ITC_CODE` |
| 59 | `DBA.ITEM_MASTER` | `ITS_CODE` | `DBA.ITEM_SIZE` | `ITS_CODE` |
| 60 | `DBA.ITEM_MASTER` | `ITT_CODE` | `DBA.ITEM_TYPE` | `ITT_CODE` |
| 61 | `DBA.ITEM_MASTER` | `CHRT_SERIAL` | `DBA.CHART_OF_ACCOUNTS` | `CHRT_SERIAL` |
| 62 | `DBA.ITEM_MASTER` | `IS_CODE` | `DBA.ITEM_SEASON` | `IS_CODE` |
| 63 | `DBA.ITEM_MASTER` | `IG_CODE` | `DBA.ITEM_GENDER` | `IG_CODE` |
| 64 | `DBA.ITEM_MASTER` | `IC_CODE` | `DBA.ITEM_CATEGORY` | `IC_CODE` |
| 65 | `DBA.CUSTOMER` | `CUR_CODE_2` | `DBA.CURRENCY` | `CUR_CODE` |
| 66 | `DBA.CUSTOMER` | `CUR_CODE_3` | `DBA.CURRENCY` | `CUR_CODE` |
| 67 | `DBA.CUSTOMER` | `CUR_CODE_1` | `DBA.CURRENCY` | `CUR_CODE` |
| 68 | `DBA.CUSTOMER` | `COU_CODE_L1,COU_CODE_L2,COU_CODE_L3,COU_CODE_L4,COU_CODE_L5,COU_CODE_L6` | `DBA.COUNTRY` | `COU_CODE_L1,COU_CODE_L2,COU_CODE_L3,COU_CODE_L4,COU_CODE_L5,COU_CODE_L6` |
| 69 | `DBA.CUSTOMER` | `INDUSTRY_CODE` | `DBA.INDUSTRY` | `INDUSTRY_CODE` |
| 70 | `DBA.CUSTOMER` | `SECTOR_CODE` | `DBA.SECTORS` | `SECTOR_CODE` |
| 71 | `DBA.CUSTOMER` | `CUS_HOLDING_SERIAL` | `DBA.CUSTOMER` | `CUS_SERIAL` |
| 72 | `DBA.CUSTOMER` | `CHRT_SERIAL` | `DBA.CHART_OF_ACCOUNTS` | `CHRT_SERIAL` |
| 73 | `DBA.CURRENCY_EXCHANGE` | `CUR_EXCHANGE_CODE` | `DBA.CURRENCY` | `CUR_CODE` |
| 74 | `DBA.CURRENCY_EXCHANGE` | `CUR_BASE_CODE` | `DBA.CURRENCY` | `CUR_CODE` |
| 75 | `DBA.COMPANY_COST_CENTERS_ORG` | `COC_CODE_L1,COC_CODE_L2,COC_CODE_L3,COC_CODE_L4,COC_CODE_L5,COC_CODE_L6` | `DBA.ORGANIZATION_CHART` | `ORG_CODE_L1,ORG_CODE_L2,ORG_CODE_L3,ORG_CODE_L4,ORG_CODE_L5,ORG_CODE_L6` |
| 76 | `DBA.ITEM_UNITS_CONVERSION` | `ITU_CONVERSION_CODE` | `DBA.ITEM_UNIT` | `ITU_CODE` |
| 77 | `DBA.ITEM_UNITS_CONVERSION` | `ITU_BASE_CODE` | `DBA.ITEM_UNIT` | `ITU_CODE` |
| 78 | `DBA.ITEM_COMPANY_PRICE` | `ITM_SERIAL,COM_CODE` | `DBA.ITEM_COMPANY` | `ITM_SERIAL,COM_CODE` |
| 79 | `DBA.ITEM_COMPANY_PRICE` | `PRT_CODE` | `DBA.PRICE_TYPE` | `PRT_CODE` |
| 80 | `DBA.ALTERNATE_ITEM` | `ITM_ALTERNATE_SERIAL` | `DBA.ITEM_MASTER` | `ITM_SERIAL` |
| 81 | `DBA.ALTERNATE_ITEM` | `ITM_BASE_SERIAL` | `DBA.ITEM_MASTER` | `ITM_SERIAL` |
| 82 | `DBA.DRUG_INTERACTION_ITEM` | `ITM_INTERACTION_SERIAL` | `DBA.ITEM_MASTER` | `ITM_SERIAL` |
| 83 | `DBA.DRUG_INTERACTION_ITEM` | `ITM_BASE_SERIAL` | `DBA.ITEM_MASTER` | `ITM_SERIAL` |
| 84 | `DBA.CUR_DETAIL_TABLE` | `CUR_CODE` | `DBA.CURRENCY` | `CUR_CODE` |
| 85 | `DBA.SYSTEM_MESSAGES` | `LNG_ID` | `DBA.LANGUAGE` | `LNG_ID` |
| 86 | `DBA.SALESMAN` | `COM_CODE,CHRT_SERIAL` | `DBA.COMPANY_CHART_OF_ACCOUNT` | `COM_CODE,CHRT_SERIAL` |
| 87 | `DBA.SALESMAN` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 88 | `DBA.SALESMAN` | `COU_CODE_L1,COU_CODE_L2,COU_CODE_L3,COU_CODE_L4,COU_CODE_L5,COU_CODE_L6` | `DBA.COUNTRY` | `COU_CODE_L1,COU_CODE_L2,COU_CODE_L3,COU_CODE_L4,COU_CODE_L5,COU_CODE_L6` |
| 89 | `DBA.TABLE_COLUMNS_SPECS` | `TS_TABLE_NAME` | `DBA.TABLE_SPECS` | `TS_TABLE_NAME` |
| 90 | `DBA.UNIQUE_COLUMNS` | `TS_TABLE_NAME` | `DBA.TABLE_SPECS` | `TS_TABLE_NAME` |
| 91 | `DBA.UNIQUE_COLUMNS` | `TAB_TS_TABLE_NAME,TCS_COLUMN_NAME` | `DBA.TABLE_COLUMNS_SPECS` | `TS_TABLE_NAME,TCS_COLUMN_NAME` |
| 92 | `DBA.ORDERS_HEADER_TABEL` | `COM_CODE,CUS_SERIAL` | `DBA.CUSTOMER_COMAPNY` | `COM_CODE,CUS_SERIAL` |
| 93 | `DBA.ORDERS_HEADER_TABEL` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 94 | `DBA.ORDERS_HEADER_TABEL` | `SAL_SERIAL,SAL_COM_CODE` | `DBA.SALESMAN` | `SAL_SERIAL,COM_CODE` |
| 95 | `DBA.ORDER_LINES_TABLE` | `ORD_SERIAL,COM_CODE` | `DBA.ORDERS_HEADER_TABEL` | `ORD_SERIAL,COM_CODE` |
| 96 | `DBA.ORDER_LINES_TABLE` | `ITM_SERIAL,COM_CODE` | `DBA.ITEM_COMPANY` | `ITM_SERIAL,COM_CODE` |
| 97 | `DBA.ITEM_STORE_COMPANY_EXPIRY` | `COM_CODE,STO_CODE,ITM_SERIAL` | `DBA.ITEM_STORE_COMPANY` | `COM_CODE,STO_CODE,ITM_SERIAL` |
| 98 | `DBA.REQUEST_FOR_QUOTATION` | `COM_CODE,VEN_SERIAL` | `DBA.COMPANY_VENDORS` | `COM_CODE,VEN_SERIAL` |
| 99 | `DBA.REQUEST_FOR_QUOTATION` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 100 | `DBA.VENDOR_QUOTATION` | `COM_CODE,RFQ_SERIAL,RFQ_FISCAL_YEAR` | `DBA.REQUEST_FOR_QUOTATION` | `COM_CODE,RFQ_SERIAL,RFQ_FISCAL_YEAR` |
| 101 | `DBA.VENDOR_QUOTATION` | `COM_CODE,VEN_SERIAL` | `DBA.COMPANY_VENDORS` | `COM_CODE,VEN_SERIAL` |
| 102 | `DBA.VENDOR_QUOTATION` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 103 | `DBA.REQUISITION_HEADER` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 104 | `DBA.REQUISITION_HEADER` | `ORG_CODE_L1,ORG_CODE_L2,ORG_CODE_L3,ORG_CODE_L4,ORG_CODE_L5,ORG_CODE_L6` | `DBA.ORGANIZATION_CHART` | `ORG_CODE_L1,ORG_CODE_L2,ORG_CODE_L3,ORG_CODE_L4,ORG_CODE_L5,ORG_CODE_L6` |
| 105 | `DBA.PURCHASE_ORDER_HEADER` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 106 | `DBA.PURCHASE_ORDER_HEADER` | `COM_CODE,VEN_SERIAL` | `DBA.COMPANY_VENDORS` | `COM_CODE,VEN_SERIAL` |
| 107 | `DBA.PURCHASE_ORDER_HEADER` | `COM_CODE,STO_CODE` | `DBA.COMPANY_STORES` | `COM_CODE,STO_CODE` |
| 108 | `DBA.DEMAND_REPORT_HEADER` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 109 | `DBA.ITEM_RFQ` | `COM_CODE,VEN_SERIAL,ITM_SERIAL` | `DBA.ITEM_COMPANY_VENDOR` | `COM_CODE,VEN_SERIAL,ITM_SERIAL` |
| 110 | `DBA.ITEM_RFQ` | `RFQ_SERIAL,COM_CODE,RFQ_FISCAL_YEAR` | `DBA.REQUEST_FOR_QUOTATION` | `RFQ_SERIAL,COM_CODE,RFQ_FISCAL_YEAR` |
| 111 | `DBA.VENDOR_QUOTATION_ITEMS` | `COM_CODE,VEQ_SERIAL,VEQ_FISCAL_YEAR` | `DBA.VENDOR_QUOTATION` | `COM_CODE,VEQ_SERIAL,VEQ_FISCAL_YEAR` |
| 112 | `DBA.VENDOR_QUOTATION_ITEMS` | `COM_CODE,VEN_SERIAL,ITM_SERIAL` | `DBA.ITEM_COMPANY_VENDOR` | `COM_CODE,VEN_SERIAL,ITM_SERIAL` |
| 113 | `DBA.REQUISITION_ITEMS` | `COM_CODE,REQ_SERIAL,REQ_FISICAL_YEAR` | `DBA.REQUISITION_HEADER` | `COM_CODE,REQ_SERIAL,REQ_FISICAL_YEAR` |
| 114 | `DBA.REQUISITION_ITEMS` | `COM_CODE,ITM_SERIAL` | `DBA.ITEM_COMPANY` | `COM_CODE,ITM_SERIAL` |
| 115 | `DBA.PURCHASE_ORDER_ITEMS` | `COM_CODE,PO_SERIAL,PO_FISCAL_YEAR` | `DBA.PURCHASE_ORDER_HEADER` | `COM_CODE,PO_SERIAL,PO_FISCAL_YEAR` |
| 116 | `DBA.PURCHASE_ORDER_ITEMS` | `VEN_SERIAL,ITM_SERIAL,COM_CODE` | `DBA.ITEM_COMPANY_VENDOR` | `VEN_SERIAL,ITM_SERIAL,COM_CODE` |
| 117 | `DBA.PURCHASE_ORDER_ITEMS` | `ISP_CODE` | `DBA.ITEM_UNIT` | `ITU_CODE` |
| 118 | `DBA.DEMAND_REPORT_VENDORS` | `COM_CODE,PO_SERIAL,PO_FISCAL_YEAR` | `DBA.PURCHASE_ORDER_HEADER` | `COM_CODE,PO_SERIAL,PO_FISCAL_YEAR` |
| 119 | `DBA.DEMAND_REPORT_VENDORS` | `COM_CODE,DEM_DEMAND_SERIAL,DEM_FISCAL_YEAR` | `DBA.DEMAND_REPORT_HEADER` | `COM_CODE,DEM_DEMAND_SERIAL,DEM_FISCAL_YEAR` |
| 120 | `DBA.DEMAND_REPORT_VENDORS` | `COM_CODE,VEN_SERIAL` | `DBA.COMPANY_VENDORS` | `COM_CODE,VEN_SERIAL` |
| 121 | `DBA.DEMAND_REPORT_REQ` | `COM_CODE,DEM_DEMAND_SERIAL,DEM_FISCAL_YEAR` | `DBA.DEMAND_REPORT_HEADER` | `COM_CODE,DEM_DEMAND_SERIAL,DEM_FISCAL_YEAR` |
| 122 | `DBA.DEMAND_REPORT_REQ` | `COM_CODE,REQ_SERIAL,REQ_FISICAL_YEAR` | `DBA.REQUISITION_HEADER` | `COM_CODE,REQ_SERIAL,REQ_FISICAL_YEAR` |
| 123 | `DBA.DEMAND_REPORT_ITEMS` | `DEM_DEMAND_SERIAL,COM_CODE,DEM_FISCAL_YEAR` | `DBA.DEMAND_REPORT_HEADER` | `DEM_DEMAND_SERIAL,COM_CODE,DEM_FISCAL_YEAR` |
| 124 | `DBA.DEMAND_REPORT_ITEMS` | `ITM_SERIAL,COM_CODE` | `DBA.ITEM_COMPANY` | `ITM_SERIAL,COM_CODE` |
| 125 | `DBA.MODULE_LANGUAGE` | `MOD_MODULE_ID` | `DBA.MODULES` | `MOD_MODULE_ID` |
| 126 | `DBA.MODULE_LANGUAGE` | `LNG_ID` | `DBA.LANGUAGE` | `LNG_ID` |
| 127 | `DBA.MODULE_LANG_TRAN_TYPE_1` | `LNG_ID,MOD_MODULE_ID` | `DBA.MODULE_LANGUAGE` | `LNG_ID,MOD_MODULE_ID` |
| 128 | `DBA.MODULE_TRANSACTIONS` | `TS_TABLE_NAME,TCS_COLUMN_NAME` | `DBA.TABLE_COLUMNS_SPECS` | `TS_TABLE_NAME,TCS_COLUMN_NAME` |
| 129 | `DBA.MODULE_TRANSACTIONS` | `MOD_MODULE_ID` | `DBA.MODULES` | `MOD_MODULE_ID` |
| 130 | `DBA.MODULE_LANG_TRAN_TYPE_2` | `LNG_ID,MOD_MODULE_ID,MLTT1_TYPE_1` | `DBA.MODULE_LANG_TRAN_TYPE_1` | `LNG_ID,MOD_MODULE_ID,MLTT1_TYPE_1` |
| 131 | `DBA.RATR_TRANSACTION_HEADER` | `CUR_CODE` | `DBA.CURRENCY` | `CUR_CODE` |
| 132 | `DBA.RATR_TRANSACTION_HEADER` | `COM_CODE,STO_CODE` | `DBA.COMPANY_STORES` | `COM_CODE,STO_CODE` |
| 133 | `DBA.RATR_TRANSACTION_HEADER` | `COM_CODE,VEN_SERIAL` | `DBA.COMPANY_VENDORS` | `COM_CODE,VEN_SERIAL` |
| 134 | `DBA.RATR_TRANSACTION_HEADER` | `COM_CODE,STO_CODE,RETURN_TRANSACTION_TYPE_CODE_LEVEL1,RETURN_TRANSACTION_TYPE_CODE_LEVEL2,RETURN_TRANSACTION_NUMBER,RETURN_FISICAL_YEAR` | `DBA.RATR_TRANSACTION_HEADER` | `COM_CODE,STO_CODE,TRANSACTION_TYPE_CODE_LEVEL1,TRANSACTION_TYPE_CODE_LEVEL2,TRANSACTION_NUMBER,RATR_FISICAL_YEAR` |
| 135 | `DBA.RATR_TRANSACTION_HEADER_PO` | `STO_CODE,TRANSACTION_TYPE_CODE_LEVEL1,TRANSACTION_TYPE_CODE_LEVEL2,TRANSACTION_NUMBER,RATR_FISICAL_YEAR,COM_CODE` | `DBA.RATR_TRANSACTION_HEADER` | `STO_CODE,TRANSACTION_TYPE_CODE_LEVEL1,TRANSACTION_TYPE_CODE_LEVEL2,TRANSACTION_NUMBER,RATR_FISICAL_YEAR,COM_CODE` |
| 136 | `DBA.RATR_TRANSACTION_HEADER_PO` | `PO_SERIAL,PO_FISCAL_YEAR,COM_CODE` | `DBA.PURCHASE_ORDER_HEADER` | `PO_SERIAL,PO_FISCAL_YEAR,COM_CODE` |
| 137 | `DBA.RATR_TRANSACTION_HEADER_COST` | `COM_CODE,STO_CODE,TRANSACTION_TYPE_CODE_LEVEL1,TRANSACTION_TYPE_CODE_LEVEL2,TRANSACTION_NUMBER,RATR_FISICAL_YEAR` | `DBA.RATR_TRANSACTION_HEADER` | `COM_CODE,STO_CODE,TRANSACTION_TYPE_CODE_LEVEL1,TRANSACTION_TYPE_CODE_LEVEL2,TRANSACTION_NUMBER,RATR_FISICAL_YEAR` |
| 138 | `DBA.RATR_TRANSACTION_HEADER_COST` | `COM_CODE,CHRT_SERIAL` | `DBA.COMPANY_CHART_OF_ACCOUNT` | `COM_CODE,CHRT_SERIAL` |
| 139 | `DBA.SHIFTS` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 140 | `DBA.LAST_SHIFT` | `COM_CODE,SHFT_CODE` | `DBA.SHIFTS` | `COM_CODE,SHFT_CODE` |
| 141 | `DBA.LAST_SHIFT` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 142 | `DBA.LAST_SHIFT` | `COM_CODE,CASH_SERIAL` | `DBA.WORK_STATION_COMPANY` | `COM_CODE,CASH_SERIAL` |
| 143 | `DBA.SHIFTS_MONEY` | `COM_CODE,SHFT_CODE` | `DBA.SHIFTS` | `COM_CODE,SHFT_CODE` |
| 144 | `DBA.SHIFTS_MONEY` | `COM_CODE,CASH_SERIAL` | `DBA.WORK_STATION_COMPANY` | `COM_CODE,CASH_SERIAL` |
| 145 | `DBA.COMPANY_SERIALS` | `MOD_MODULE_ID` | `DBA.MODULES` | `MOD_MODULE_ID` |
| 146 | `DBA.COMPANY_SERIALS` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 147 | `DBA.USER_COMPANY` | `USER_CODE` | `DBA.SECURITY_USERS` | `USER_CODE` |
| 148 | `DBA.USER_COMPANY` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 149 | `DBA.USER_COMPANY` | `COM_CODE,sal_serial` | `DBA.SALESMAN` | `COM_CODE,SAL_SERIAL` |
| 150 | `DBA.SECURITY_GROUPINGS` | `USER_CODE` | `DBA.SECURITY_USERS` | `USER_CODE` |
| 151 | `DBA.SECURITY_GROUPINGS` | `SEC_USER_CODE` | `DBA.SECURITY_USERS` | `USER_CODE` |
| 152 | `DBA.RATR_TRANSACTION_ITEMS` | `TRX_MEASURE_UNIT` | `DBA.ITEM_UNIT` | `ITU_CODE` |
| 153 | `DBA.RATR_TRANSACTION_ITEMS` | `REQUESTED_UNIT` | `DBA.ITEM_UNIT` | `ITU_CODE` |
| 154 | `DBA.RATR_TRANSACTION_ITEMS` | `COM_CODE,OTHER_STO_CODE` | `DBA.COMPANY_STORES` | `COM_CODE,STO_CODE` |
| 155 | `DBA.RATR_TRANSACTION_ITEMS` | `STO_CODE,ITM_SERIAL,COM_CODE` | `DBA.ITEM_STORE_COMPANY` | `STO_CODE,ITM_SERIAL,COM_CODE` |
| 156 | `DBA.RATR_TRANSACTION_ITEMS` | `COM_CODE,PO_SERIAL,POI_ITEM_SERIAL,PO_FISCAL_YEAR` | `DBA.PURCHASE_ORDER_ITEMS` | `COM_CODE,PO_SERIAL,POI_ITEM_SERIAL,PO_FISCAL_YEAR` |
| 157 | `DBA.RATR_TRANSACTION_ITEMS` | `COM_CODE,STO_CODE,TRANSACTION_TYPE_CODE_LEVEL1,TRANSACTION_TYPE_CODE_LEVEL2,TRANSACTION_NUMBER,RATR_FISICAL_YEAR` | `DBA.RATR_TRANSACTION_HEADER` | `COM_CODE,STO_CODE,TRANSACTION_TYPE_CODE_LEVEL1,TRANSACTION_TYPE_CODE_LEVEL2,TRANSACTION_NUMBER,RATR_FISICAL_YEAR` |
| 158 | `DBA.YEAR_COMPANY_VENDOR` | `VEN_SERIAL,COM_CODE` | `DBA.COMPANY_VENDORS` | `VEN_SERIAL,COM_CODE` |
| 159 | `DBA.YEAR_ITEM_STORE_COMPANY` | `STO_CODE,COM_CODE,ITM_SERIAL` | `DBA.ITEM_STORE_COMPANY` | `STO_CODE,COM_CODE,ITM_SERIAL` |
| 160 | `DBA.YEAR_CUSTOMER_COMPANY` | `CUS_SERIAL,COM_CODE` | `DBA.CUSTOMER_COMAPNY` | `CUS_SERIAL,COM_CODE` |
| 161 | `DBA.CURRENT_SETTINGS` | `USER_CODE` | `DBA.SECURITY_USERS` | `USER_CODE` |
| 162 | `DBA.ITEM_COMPANY` | `ITM_SERIAL` | `DBA.ITEM_MASTER` | `ITM_SERIAL` |
| 163 | `DBA.ITEM_COMPANY` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 164 | `DBA.ITEM_COMPANY` | `COM_CODE,CHRT_SERIAL` | `DBA.COMPANY_CHART_OF_ACCOUNT` | `COM_CODE,CHRT_SERIAL` |
| 165 | `DBA.ITEM_COMPANY` | `ITU_SMALL_ISSUE_CODE` | `DBA.ITEM_UNIT` | `ITU_CODE` |
| 166 | `DBA.ITEM_COMPANY` | `ITU_STORED_ISSUE_CODE` | `DBA.ITEM_UNIT` | `ITU_CODE` |
| 167 | `DBA.ITEM_COMPANY` | `ITU_PURCHASE_ISSUE_CODE` | `DBA.ITEM_UNIT` | `ITU_CODE` |
| 168 | `DBA.ITEM_COMPANY` | `ITU_MEDIUM_ISSUE_CODE` | `DBA.ITEM_UNIT` | `ITU_CODE` |
| 169 | `DBA.ITEM_COMPANY` | `ITU_LARGE_ISSUE_CODE` | `DBA.ITEM_UNIT` | `ITU_CODE` |
| 170 | `DBA.ITEM_COMPANY` | `ITT_CODE` | `DBA.ITEM_TYPE` | `ITT_CODE` |
| 171 | `DBA.CUSTOMER_ITEM_GROUP_DISCOUNT` | `MLV_CODE_L1,MLV_CODE_L2,MLV_CODE_L3,MLV_CODE_L4,MLV_CODE_L5,MLV_CODE_L6` | `DBA.ITEM_GROUPS` | `ITG_CODE_L1,ITG_CODE_L2,ITG_CODE_L3,ITG_CODE_L4,ITG_CODE_L5,ITG_CODE_L6` |
| 172 | `DBA.CUSTOMER_ITEM_GROUP_DISCOUNT` | `CUS_SERIAL,COM_CODE` | `DBA.CUSTOMER_COMAPNY` | `CUS_SERIAL,COM_CODE` |
| 173 | `DBA.CUSTOMER_ITEM_GROUP_DISCOUNT` | `PRT_CODE` | `DBA.PRICE_TYPE` | `PRT_CODE` |
| 174 | `DBA.ACCOUNT_CHART_TREE` | `PARENT_TREE_CODE_L1,PARENT_TREE_CODE_L2,PARENT_TREE_CODE_L3,PARENT_TREE_CODE_L4,PARENT_TREE_CODE_L5,PARENT_TREE_CODE_L6` | `DBA.ACCOUNT_CHART_TREE` | `TREE_CODE_L1,TREE_CODE_L2,TREE_CODE_L3,TREE_CODE_L4,TREE_CODE_L5,TREE_CODE_L6` |
| 175 | `DBA.COMPANY_COST_CENTERS` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 176 | `DBA.COMPANY_COST_CENTERS` | `MLV_CODE_L1,MLV_CODE_L2,MLV_CODE_L3,MLV_CODE_L4,MLV_CODE_L5,MLV_CODE_L6` | `DBA.COST_CENTERS` | `COC_CODE_L1,COC_CODE_L2,COC_CODE_L3,COC_CODE_L4,COC_CODE_L5,COC_CODE_L6` |
| 177 | `DBA.COMPANY_CHART_OF_ACCOUNT` | `CUR_CODE` | `DBA.CURRENCY` | `CUR_CODE` |
| 178 | `DBA.COMPANY_CHART_OF_ACCOUNT` | `COST_CODE_L1,COST_CODE_L2,COST_CODE_L3,COST_CODE_L4,COST_CODE_L5,COST_CODE_L6` | `DBA.COST_CENTERS` | `COC_CODE_L1,COC_CODE_L2,COC_CODE_L3,COC_CODE_L4,COC_CODE_L5,COC_CODE_L6` |
| 179 | `DBA.COMPANY_CHART_OF_ACCOUNT` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 180 | `DBA.COMPANY_CHART_OF_ACCOUNT` | `COM_CODE,CCC_COST_SERIAL` | `DBA.COMPANY_COST_CENTERS` | `COM_CODE,CCC_COST_SERIAL` |
| 181 | `DBA.COMPANY_CHART_OF_ACCOUNT` | `COM_CODE,TREE_CODE_L1,TREE_CODE_L2,TREE_CODE_L3,TREE_CODE_L4,TREE_CODE_L5,TREE_CODE_L6` | `DBA.COMPANY_ACCOUNT_CHART_TREE` | `COM_CODE,TREE_CODE_L1,TREE_CODE_L2,TREE_CODE_L3,TREE_CODE_L4,TREE_CODE_L5,TREE_CODE_L6` |
| 182 | `DBA.COMPANY_CHART_OF_ACCOUNT` | `CHRT_SERIAL` | `DBA.CHART_OF_ACCOUNTS` | `CHRT_SERIAL` |
| 183 | `DBA.COMPANY_CHART_OF_ACCOUNT` | `COM_CODE,CASH_SERIAL` | `DBA.WORK_STATION_COMPANY` | `COM_CODE,CASH_SERIAL` |
| 184 | `DBA.COMPANY_ACCOUNT_CHART_TREE` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 185 | `DBA.COMPANY_ACCOUNT_CHART_TREE` | `TREE_CODE_L1,TREE_CODE_L2,TREE_CODE_L3,TREE_CODE_L4,TREE_CODE_L5,TREE_CODE_L6` | `DBA.ACCOUNT_CHART_TREE` | `TREE_CODE_L1,TREE_CODE_L2,TREE_CODE_L3,TREE_CODE_L4,TREE_CODE_L5,TREE_CODE_L6` |
| 186 | `DBA.GL_JOURNAL_VOUCHER_HEADER` | `CUR_CODE` | `DBA.CURRENCY` | `CUR_CODE` |
| 187 | `DBA.GL_JOURNAL_VOUCHER_HEADER` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 188 | `DBA.GL_JOURNAL_VOUCHER_HEADER` | `COM_CODE,PREV_JVH_DOC_FISCAL_YEAR,PREV_JVH_TRANS_TYPE1,PREV_JVH_TRANS_TYPE2,PREV_JVH_DOC_SERIAL` | `DBA.GL_JOURNAL_VOUCHER_HEADER` | `COM_CODE,JVH_DOC_FISCAL_YEAR,JVH_TRANS_TYPE1,JVH_TRANS_TYPE2,JVH_DOC_SERIAL` |
| 189 | `DBA.GL_JOURNAL_VOUCHER_HEADER` | `COM_CODE,NEXT_JVH_DOC_FISCAL_YEAR,NEXT_JVH_TRANS_TYPE1,NEXT_JVH_TRANS_TYPE2,NEXT_JVH_DOC_SERIAL` | `DBA.GL_JOURNAL_VOUCHER_HEADER` | `COM_CODE,JVH_DOC_FISCAL_YEAR,JVH_TRANS_TYPE1,JVH_TRANS_TYPE2,JVH_DOC_SERIAL` |
| 190 | `DBA.GL_PAPAER` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 191 | `DBA.GL_PAPAER` | `COM_CODE,JVH_DOC_FISCAL_YEAR,JVH_TRANS_TYPE1,JVH_TRANS_TYPE2,JVH_DOC_SERIAL` | `DBA.GL_JOURNAL_VOUCHER_HEADER` | `COM_CODE,JVH_DOC_FISCAL_YEAR,JVH_TRANS_TYPE1,JVH_TRANS_TYPE2,JVH_DOC_SERIAL` |
| 192 | `DBA.GL_PAPAER` | `CUR_CODE` | `DBA.CURRENCY` | `CUR_CODE` |
| 193 | `DBA.GL_INTEGERATION_ACCOUNTS` | `COM_CODE,MLV_CODE_L1,MLV_CODE_L2,MLV_CODE_L3,MLV_CODE_L4,MLV_CODE_L5,MLV_CODE_L6` | `DBA.COMPANY_ACCOUNT_CHART_TREE` | `COM_CODE,TREE_CODE_L1,TREE_CODE_L2,TREE_CODE_L3,TREE_CODE_L4,TREE_CODE_L5,TREE_CODE_L6` |
| 194 | `DBA.GL_INTEGERATION_ACCOUNTS` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 195 | `DBA.GL_INTEGERATION_ACCOUNTS` | `COM_CODE,CHRT_SERIAL` | `DBA.COMPANY_CHART_OF_ACCOUNT` | `COM_CODE,CHRT_SERIAL` |
| 196 | `DBA.GL_COST_CENTER_SUMMERY` | `CUR_CODE` | `DBA.CURRENCY` | `CUR_CODE` |
| 197 | `DBA.GL_COST_CENTER_SUMMERY` | `COM_CODE,CCC_COST_SERIAL` | `DBA.COMPANY_COST_CENTERS` | `COM_CODE,CCC_COST_SERIAL` |
| 198 | `DBA.CHART_OF_ACCOUNTS` | `TREE_CODE_L1,TREE_CODE_L2,TREE_CODE_L3,TREE_CODE_L4,TREE_CODE_L5,TREE_CODE_L6` | `DBA.ACCOUNT_CHART_TREE` | `TREE_CODE_L1,TREE_CODE_L2,TREE_CODE_L3,TREE_CODE_L4,TREE_CODE_L5,TREE_CODE_L6` |
| 199 | `DBA.CHART_OF_ACCOUNTS` | `CUR_CODE` | `DBA.CURRENCY` | `CUR_CODE` |
| 200 | `DBA.GL_NOTES_MODIFICATIONS` | `COM_CODE,P_FISCAL_YEAR,PAPER_TYPE,PAPER_IN_OUT,PAPER_SERIAL` | `DBA.GL_PAPAER` | `COM_CODE,P_FISCAL_YEAR,PAPER_TYPE,PAPER_IN_OUT,PAPER_SERIAL` |
| 201 | `DBA.GL_JV_SUMMERY` | `CHRT_SERIAL,COM_CODE` | `DBA.COMPANY_CHART_OF_ACCOUNT` | `CHRT_SERIAL,COM_CODE` |
| 202 | `DBA.GL_JV_SUMMERY` | `CUR_CODE` | `DBA.CURRENCY` | `CUR_CODE` |
| 203 | `DBA.GL_COST_CENTER_DETAIL` | `MOD_MODULE_ID,MTT_TRANS_TYPE_1,MTT_TRANS_TYPE_2` | `DBA.MODULE_TRANSACTIONS` | `MOD_MODULE_ID,MTT_TRANS_TYPE_1,MTT_TRANS_TYPE_2` |
| 204 | `DBA.GL_COST_CENTER_DETAIL` | `COM_CODE,CUR_CODE,GLCC_FISCAL_YEAR,GLCC_MONTH,CCC_COST_SERIAL` | `DBA.GL_COST_CENTER_SUMMERY` | `COM_CODE,CUR_CODE,GLCC_FISCAL_YEAR,GLCC_MONTH,CCC_COST_SERIAL` |
| 205 | `DBA.GL_PERIOD` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 206 | `DBA.MODULE_TRANSACTIONS_GL_ACCOUNT` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 207 | `DBA.MODULE_TRANSACTIONS_GL_ACCOUNT` | `MOD_MODULE_ID,MTT_TRANS_TYPE_1,MTT_TRANS_TYPE_2` | `DBA.MODULE_TRANSACTIONS` | `MOD_MODULE_ID,MTT_TRANS_TYPE_1,MTT_TRANS_TYPE_2` |
| 208 | `DBA.MODULE_TRANSACTIONS_GL_ACCOUNT` | `COM_CODE,CHRT_SERIAL` | `DBA.COMPANY_CHART_OF_ACCOUNT` | `COM_CODE,CHRT_SERIAL` |
| 209 | `DBA.MODULE_TRANSACTIONS_GL_ACCOUNT` | `COM_CODE,MLV_CODE_L1,MLV_CODE_L2,MLV_CODE_L3,MLV_CODE_L4,MLV_CODE_L5,MLV_CODE_L6` | `DBA.COMPANY_ACCOUNT_CHART_TREE` | `COM_CODE,TREE_CODE_L1,TREE_CODE_L2,TREE_CODE_L3,TREE_CODE_L4,TREE_CODE_L5,TREE_CODE_L6` |
| 210 | `DBA.MODULE_TRANSACTIONS_GL_ACCOUNT` | `COM_CODE,GIA_SERIAL` | `DBA.GL_INTEGERATION_ACCOUNTS` | `COM_CODE,GIA_SERIAL` |
| 211 | `DBA.WORK_STATION_COMPANY` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 212 | `DBA.WORK_STATION_COMPANY` | `CASH_SERIAL` | `DBA.WORK_STATION` | `CASH_SERIAL` |
| 213 | `DBA.WORK_STATION_COMPANY` | `COM_CODE,CHRT_SERIAL` | `DBA.COMPANY_CHART_OF_ACCOUNT` | `COM_CODE,CHRT_SERIAL` |
| 214 | `DBA.COMPANY_MODULES` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 215 | `DBA.COMPANY_MODULES` | `MOD_MODULE_ID` | `DBA.MODULES` | `MOD_MODULE_ID` |
| 216 | `DBA.COMPANY_BANK_ACCOUNTS` | `CUR_CODE` | `DBA.CURRENCY` | `CUR_CODE` |
| 217 | `DBA.COMPANY_BANK_ACCOUNTS` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 218 | `DBA.COMPANY_BANK_ACCOUNTS` | `BNK_CODE` | `DBA.BANKS` | `BNK_CODE` |
| 219 | `DBA.COMPANY_BANK_ACCOUNTS` | `BAT_CODE` | `DBA.BANK_ACCOUNT_TYPES` | `BAT_CODE` |
| 220 | `DBA.COMPANY_BANK_ACCOUNTS` | `COM_CODE,CHRT_SERIAL` | `DBA.COMPANY_CHART_OF_ACCOUNT` | `COM_CODE,CHRT_SERIAL` |
| 221 | `DBA.BANK_ACCOUNT_TRANSACTION` | `COM_CODE,BAT_CODE,BNK_CODE,CUR_CODE,CHB_BANK_ACCOUNT_NUMBER` | `DBA.COMPANY_BANK_ACCOUNTS` | `COM_CODE,BAT_CODE,BNK_CODE,CUR_CODE,CHB_BANK_ACCOUNT_NUMBER` |
| 222 | `DBA.GL_BANK_DETAIL_SUMMARY` | `BAT_CODE,BNK_CODE,COM_CODE,CUR_CODE,CHB_BANK_ACCOUNT_NUMBER` | `DBA.COMPANY_BANK_ACCOUNTS` | `BAT_CODE,BNK_CODE,COM_CODE,CUR_CODE,CHB_BANK_ACCOUNT_NUMBER` |
| 223 | `DBA.GL_JOURNAL_VOUCHER_DETAIL` | `COM_CODE,CCC_COST_SERIAL` | `DBA.COMPANY_COST_CENTERS` | `COM_CODE,CCC_COST_SERIAL` |
| 224 | `DBA.GL_JOURNAL_VOUCHER_DETAIL` | `COM_CODE,RIGHT_CCC_COST_SERIAL` | `DBA.COMPANY_COST_CENTERS` | `COM_CODE,CCC_COST_SERIAL` |
| 225 | `DBA.GL_JOURNAL_VOUCHER_DETAIL` | `COM_CODE,DEBIT_CHRT_SERIAL` | `DBA.COMPANY_CHART_OF_ACCOUNT` | `COM_CODE,CHRT_SERIAL` |
| 226 | `DBA.GL_JOURNAL_VOUCHER_DETAIL` | `COM_CODE,CREDIT_CHRT_SERIAL` | `DBA.COMPANY_CHART_OF_ACCOUNT` | `COM_CODE,CHRT_SERIAL` |
| 227 | `DBA.GL_JOURNAL_VOUCHER_DETAIL` | `COM_CODE,OLD_CHRT_SERIAL` | `DBA.COMPANY_CHART_OF_ACCOUNT` | `COM_CODE,CHRT_SERIAL` |
| 228 | `DBA.GL_JOURNAL_VOUCHER_DETAIL` | `COM_CODE,JVH_DOC_FISCAL_YEAR,JVH_TRANS_TYPE1,JVH_TRANS_TYPE2,JVH_DOC_SERIAL` | `DBA.GL_JOURNAL_VOUCHER_HEADER` | `COM_CODE,JVH_DOC_FISCAL_YEAR,JVH_TRANS_TYPE1,JVH_TRANS_TYPE2,JVH_DOC_SERIAL` |
| 229 | `DBA.GL_JOURNAL_VOUCHER_DETAIL` | `COM_CODE,P_FISCAL_YEAR,PAPER_TYPE,PAPER_IN_OUT,PAPER_SERIAL` | `DBA.GL_PAPAER` | `COM_CODE,P_FISCAL_YEAR,PAPER_TYPE,PAPER_IN_OUT,PAPER_SERIAL` |
| 230 | `DBA.GL_JOURNAL_VOUCHER_DETAIL` | `COM_CODE,ORG_JVH_DOC_FISCAL_YEAR,ORG_JVH_TRANS_TYPE1,ORG_JVH_TRANS_TYPE2,ORG_JVH_DOC_SERIAL,ORG_JVD_SERIAL` | `DBA.GL_JOURNAL_VOUCHER_DETAIL` | `COM_CODE,JVH_DOC_FISCAL_YEAR,JVH_TRANS_TYPE1,JVH_TRANS_TYPE2,JVH_DOC_SERIAL,JVD_SERIAL` |
| 231 | `DBA.GL_VOUCHER_DETAIL_DIST` | `COM_CODE,JVH_DOC_FISCAL_YEAR,JVH_TRANS_TYPE1,JVH_TRANS_TYPE2,JVH_DOC_SERIAL,JVD_SERIAL` | `DBA.GL_JOURNAL_VOUCHER_DETAIL` | `COM_CODE,JVH_DOC_FISCAL_YEAR,JVH_TRANS_TYPE1,JVH_TRANS_TYPE2,JVH_DOC_SERIAL,JVD_SERIAL` |
| 232 | `DBA.CUR_FACILITY_TABLE` | `PRT_CODE` | `DBA.PRICE_TYPE` | `PRT_CODE` |
| 233 | `DBA.CUR_FACILITY_TABLE` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 234 | `DBA.CUR_FACILITY_TABLE` | `COM_CODE,CUS_SERIAL` | `DBA.CUSTOMER_COMAPNY` | `COM_CODE,CUS_SERIAL` |
| 235 | `DBA.CUR_FACILITY_TABLE` | `CUS_SERIAL` | `DBA.CUSTOMER` | `CUS_SERIAL` |
| 236 | `DBA.PROMOTION_HEADER` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 237 | `DBA.PROMOTION_HEADER` | `PRT_CODE` | `DBA.PRICE_TYPE` | `PRT_CODE` |
| 238 | `DBA.PROMOTION_HEADER` | `COM_CODE,STO_CODE` | `DBA.COMPANY_STORES` | `COM_CODE,STO_CODE` |
| 239 | `DBA.REPLACEMENT_ITEM` | `COM_CODE,BASE_ITM_SERIAL` | `DBA.ITEM_COMPANY` | `COM_CODE,ITM_SERIAL` |
| 240 | `DBA.REPLACEMENT_ITEM` | `COM_CODE,REPLACMENT_ITM_SERIAL` | `DBA.ITEM_COMPANY` | `COM_CODE,ITM_SERIAL` |
| 241 | `DBA.SALES_TAX_TRANSACTION` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 242 | `DBA.FOOD_DRUG_INTERACTION` | `ITM_SERIAL` | `DBA.ITEM_MASTER` | `ITM_SERIAL` |
| 243 | `DBA.FOOD_DRUG_INTERACTION` | `FOOD_CODE` | `DBA.FOOD` | `FOOD_CODE` |
| 244 | `DBA.ITEM_CUSTOMER` | `COM_CODE,ITM_SERIAL` | `DBA.ITEM_COMPANY` | `COM_CODE,ITM_SERIAL` |
| 245 | `DBA.ITEM_CUSTOMER` | `COM_CODE,CUS_SERIAL` | `DBA.CUSTOMER_COMAPNY` | `COM_CODE,CUS_SERIAL` |
| 246 | `DBA.ITEM_COMPANY_VENDOR_PRICE` | `ITU_CODE` | `DBA.ITEM_UNIT` | `ITU_CODE` |
| 247 | `DBA.ITEM_COMPANY_VENDOR_PRICE` | `COM_CODE,VEN_SERIAL,ITM_SERIAL` | `DBA.ITEM_COMPANY_VENDOR` | `COM_CODE,VEN_SERIAL,ITM_SERIAL` |
| 248 | `DBA.ITEM_COMPANY_CUSTOMER_PRICE` | `COM_CODE,CUS_SERIAL,ITM_SERIAL` | `DBA.ITEM_CUSTOMER` | `COM_CODE,CUS_SERIAL,ITM_SERIAL` |
| 249 | `DBA.ITEM_COMPANY_CUSTOMER_PRICE` | `ISP_CODE` | `DBA.ITEM_UNIT` | `ITU_CODE` |
| 250 | `DBA.GROUP_CUSTOMER_PRICE` | `CUS_SERIAL,COM_CODE` | `DBA.CUSTOMER_COMAPNY` | `CUS_SERIAL,COM_CODE` |
| 251 | `DBA.GROUP_CUSTOMER_PRICE` | `MLV_CODE_L1,MLV_CODE_L2,MLV_CODE_L3,MLV_CODE_L4,MLV_CODE_L5,MLV_CODE_L6` | `DBA.ITEM_GROUPS` | `ITG_CODE_L1,ITG_CODE_L2,ITG_CODE_L3,ITG_CODE_L4,ITG_CODE_L5,ITG_CODE_L6` |
| 252 | `DBA.PROMOTION_ITEMS_DETAIL` | `COM_CODE,ITM_SERIAL` | `DBA.ITEM_COMPANY` | `COM_CODE,ITM_SERIAL` |
| 253 | `DBA.PROMOTION_GROUB_DETAIL` | `MLV_CODE_L1,MLV_CODE_L2,MLV_CODE_L3,MLV_CODE_L4,MLV_CODE_L5,MLV_CODE_L6` | `DBA.ITEM_GROUPS` | `ITG_CODE_L1,ITG_CODE_L2,ITG_CODE_L3,ITG_CODE_L4,ITG_CODE_L5,ITG_CODE_L6` |
| 254 | `DBA.CUR_FACILITY_ITEM_DISCOUNT` | `CUS_SERIAL,DOC_DATE,COM_CODE` | `DBA.CUR_FACILITY_TABLE` | `CUS_SERIAL,DOC_DATE,COM_CODE` |
| 255 | `DBA.CUR_FACILITY_ITEM_DISCOUNT` | `COM_CODE,ITM_SERIAL` | `DBA.ITEM_COMPANY` | `COM_CODE,ITM_SERIAL` |
| 256 | `DBA.CUR_FACILITY_ITEM_DISCOUNT` | `PRT_CODE` | `DBA.PRICE_TYPE` | `PRT_CODE` |
| 257 | `DBA.CUR_FACILITY_GROUP_DISCOUNT` | `CUS_SERIAL,COM_CODE,DOC_DATE` | `DBA.CUR_FACILITY_TABLE` | `CUS_SERIAL,COM_CODE,DOC_DATE` |
| 258 | `DBA.CUR_FACILITY_GROUP_DISCOUNT` | `MLV_CODE_L1,MLV_CODE_L2,MLV_CODE_L3,MLV_CODE_L4,MLV_CODE_L5,MLV_CODE_L6` | `DBA.ITEM_GROUPS` | `ITG_CODE_L1,ITG_CODE_L2,ITG_CODE_L3,ITG_CODE_L4,ITG_CODE_L5,ITG_CODE_L6` |
| 259 | `DBA.CUR_FACILITY_GROUP_DISCOUNT` | `PRT_CODE` | `DBA.PRICE_TYPE` | `PRT_CODE` |
| 260 | `DBA.CUSTOMER_OPEN_BAL` | `COM_CODE,CHRT_SERIAL` | `DBA.COMPANY_CHART_OF_ACCOUNT` | `COM_CODE,CHRT_SERIAL` |
| 261 | `DBA.CUSTOMER_OPEN_BAL` | `CUS_SERIAL,COM_CODE` | `DBA.CUSTOMER_COMAPNY` | `CUS_SERIAL,COM_CODE` |
| 262 | `DBA.VENDOR_OPEN_BAL` | `VEN_SERIAL,COM_CODE` | `DBA.COMPANY_VENDORS` | `VEN_SERIAL,COM_CODE` |
| 263 | `DBA.VENDOR_OPEN_BAL` | `COM_CODE,CHRT_SERIAL` | `DBA.COMPANY_CHART_OF_ACCOUNT` | `COM_CODE,CHRT_SERIAL` |
| 264 | `DBA.CHART_OPEN_BAL` | `CHRT_SERIAL,COM_CODE` | `DBA.COMPANY_CHART_OF_ACCOUNT` | `CHRT_SERIAL,COM_CODE` |
| 265 | `DBA.EDUCATION_SEPC` | `EDU_PARENT_CODE_L1,EDU_PARENT_CODE_L2,EDU_PARENT_CODE_L3,EDU_PARENT_CODE_L4,EDU_PARENT_CODE_L5,EDU_PARENT_CODE_L6` | `DBA.EDUCATION_SEPC` | `EDU_CODE_L1,EDU_CODE_L2,EDU_CODE_L3,EDU_CODE_L4,EDU_CODE_L5,EDU_CODE_L6` |
| 266 | `DBA.EMPLOYEE` | `CUR_CODE` | `DBA.CURRENCY` | `CUR_CODE` |
| 267 | `DBA.EMPLOYEE` | `ORG_CODE_L1,ORG_CODE_L2,ORG_CODE_L3,ORG_CODE_L4,ORG_CODE_L5,ORG_CODE_L6` | `DBA.ORGANIZATION_CHART` | `ORG_CODE_L1,ORG_CODE_L2,ORG_CODE_L3,ORG_CODE_L4,ORG_CODE_L5,ORG_CODE_L6` |
| 268 | `DBA.EMPLOYEE` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 269 | `DBA.EMPLOYEE` | `COM_CODE,CCC_COST_SERIAL` | `DBA.COMPANY_COST_CENTERS` | `COM_CODE,CCC_COST_SERIAL` |
| 270 | `DBA.EMPLOYEE` | `EDU_CODE_L1,EDU_CODE_L2,EDU_CODE_L3,EDU_CODE_L4,EDU_CODE_L5,EDU_CODE_L6` | `DBA.EDUCATION_SEPC` | `EDU_CODE_L1,EDU_CODE_L2,EDU_CODE_L3,EDU_CODE_L4,EDU_CODE_L5,EDU_CODE_L6` |
| 271 | `DBA.EMPLOYEE` | `JT_CODE` | `DBA.JOB_TITLE` | `JT_CODE` |
| 272 | `DBA.EMPLOYEE` | `SS_CODE` | `DBA.SOCIAL_STATUS` | `SS_CODE` |
| 273 | `DBA.EMPLOYEE` | `N_CODE` | `DBA.NATIONALITY` | `N_CODE` |
| 274 | `DBA.EMPLOYEE` | `COM_CODE,IT_CODE` | `DBA.INSURANCE_TAX` | `COM_CODE,IT_CODE` |
| 275 | `DBA.EMPLOYEE` | `COM_CODE,GR_CODE` | `DBA.GENERAL_RULE` | `COM_CODE,GR_CODE` |
| 276 | `DBA.EMPLOYEE` | `COM_CODE,CHRM_CODE` | `DBA.COMP_HOLIDAY_RULE_MASTER` | `COM_CODE,CHRM_CODE` |
| 277 | `DBA.EMPLOYEE` | `LC_CODE` | `DBA.LIVELS_CODES` | `LC_CODE` |
| 278 | `DBA.WORKING_CALENDER` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 279 | `DBA.ATTENDANCE_SHEET` | `COM_CODE,EM_CODE` | `DBA.EMPLOYEE` | `COM_CODE,EM_CODE` |
| 280 | `DBA.ATTENDANCE_SHEET` | `C_CODE` | `DBA.CAUSE` | `C_CODE` |
| 281 | `DBA.ALLOWAN_DEDUCTION` | `ADG_CODE` | `DBA.ALLOWAN_DEDUC_GROUP` | `ADG_CODE` |
| 282 | `DBA.ALLOWAN_DEDUCTION` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 283 | `DBA.ALLOWAN_DEDUCTION` | `COM_CODE,CHRT_SERIAL` | `DBA.COMPANY_CHART_OF_ACCOUNT` | `COM_CODE,CHRT_SERIAL` |
| 284 | `DBA.SALARY_TIME_EFFECT` | `ADG_CODE` | `DBA.ALLOWAN_DEDUC_GROUP` | `ADG_CODE` |
| 285 | `DBA.SALARY_TIME_EFFECT` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 286 | `DBA.INSURANCE_TAX` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 287 | `DBA.GENERAL_RULE` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 288 | `DBA.HOLIDAY` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 289 | `DBA.EMP_WORKING_CALENDER` | `COM_CODE,EM_CODE` | `DBA.EMPLOYEE` | `COM_CODE,EM_CODE` |
| 290 | `DBA.EMP_WORKING_CALENDER` | `COM_CODE,WC_CODE` | `DBA.WORKING_CALENDER` | `COM_CODE,WC_CODE` |
| 291 | `DBA.GL_BALANCE_SHEET_SETUP` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 292 | `DBA.GL_BALANCE_SHEET_SETUP` | `COM_CODE,MLV_CODE_L1,MLV_CODE_L2,MLV_CODE_L3,MLV_CODE_L4,MLV_CODE_L5,MLV_CODE_L6` | `DBA.COMPANY_ACCOUNT_CHART_TREE` | `COM_CODE,TREE_CODE_L1,TREE_CODE_L2,TREE_CODE_L3,TREE_CODE_L4,TREE_CODE_L5,TREE_CODE_L6` |
| 293 | `DBA.GL_BALANCE_SHEET_CALC` | `COM_CODE,CHRT_SERIAL` | `DBA.COMPANY_CHART_OF_ACCOUNT` | `COM_CODE,CHRT_SERIAL` |
| 294 | `DBA.GL_BALANCE_SHEET_CALC` | `COM_CODE,BSS_SERIAL,BSS_TYPE` | `DBA.GL_BALANCE_SHEET_SETUP` | `COM_CODE,BSS_SERIAL,BSS_TYPE` |
| 295 | `DBA.GL_BALANCE_SHEET_CALC` | `COM_CODE,MLV_CODE_L1,MLV_CODE_L2,MLV_CODE_L3,MLV_CODE_L4,MLV_CODE_L5,MLV_CODE_L6` | `DBA.COMPANY_ACCOUNT_CHART_TREE` | `COM_CODE,TREE_CODE_L1,TREE_CODE_L2,TREE_CODE_L3,TREE_CODE_L4,TREE_CODE_L5,TREE_CODE_L6` |
| 296 | `DBA.ITEM_STORE_OPEN_BAL` | `COM_CODE,CHRT_SERIAL` | `DBA.COMPANY_CHART_OF_ACCOUNT` | `COM_CODE,CHRT_SERIAL` |
| 297 | `DBA.ITEM_STORE_OPEN_BAL` | `ISP_CODE` | `DBA.ITEM_UNIT` | `ITU_CODE` |
| 298 | `DBA.ITEM_STORE_OPEN_BAL` | `PRICE_ISP_CODE` | `DBA.ITEM_UNIT` | `ITU_CODE` |
| 299 | `DBA.ITEM_STORE_OPEN_BAL` | `COM_CODE,STO_CODE,ITM_SERIAL` | `DBA.ITEM_STORE_COMPANY` | `COM_CODE,STO_CODE,ITM_SERIAL` |
| 300 | `DBA.MANUAL_IN_OUT` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 301 | `DBA.MANUAL_IN_OUT` | `COM_CODE,CASH_SERIAL` | `DBA.WORK_STATION_COMPANY` | `COM_CODE,CASH_SERIAL` |
| 302 | `DBA.COMP_HOLIDAY_RULE_MASTER` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 303 | `DBA.COMP_HOLIDAY_RULE_DETAIL` | `COM_CODE,CHRM_CODE` | `DBA.COMP_HOLIDAY_RULE_MASTER` | `COM_CODE,CHRM_CODE` |
| 304 | `DBA.TIME_DESIGNATOR_DAILY` | `COM_CODE,EM_CODE` | `DBA.EMPLOYEE` | `COM_CODE,EM_CODE` |
| 305 | `DBA.TIME_DESIGNATOR_DAILY` | `COM_CODE,ADG_CODE,STE_CODE` | `DBA.SALARY_TIME_EFFECT` | `COM_CODE,ADG_CODE,STE_CODE` |
| 306 | `DBA.GL_PAPER_COLLECTION_HEADER` | `BNK_CODE` | `DBA.BANKS` | `BNK_CODE` |
| 307 | `DBA.GL_PAPER_COLLECTION_HEADER` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 308 | `DBA.GL_PAPER_COLLECTION_DETAIL` | `COM_CODE,CHRT_SERIAL` | `DBA.COMPANY_CHART_OF_ACCOUNT` | `COM_CODE,CHRT_SERIAL` |
| 309 | `DBA.GL_PAPER_COLLECTION_DETAIL` | `COM_CODE,EXPENS_CHRT_SERIAL` | `DBA.COMPANY_CHART_OF_ACCOUNT` | `COM_CODE,CHRT_SERIAL` |
| 310 | `DBA.GL_PAPER_COLLECTION_DETAIL` | `COM_CODE,P_FISCAL_YEAR,PAPER_TYPE,PAPER_IN_OUT,PAPER_SERIAL` | `DBA.GL_PAPAER` | `COM_CODE,P_FISCAL_YEAR,PAPER_TYPE,PAPER_IN_OUT,PAPER_SERIAL` |
| 311 | `DBA.GL_PAPER_COLLECTION_DETAIL` | `COM_CODE,BNK_CODE,PCH_SERIAL,PCH_FISCAL_YEAR` | `DBA.GL_PAPER_COLLECTION_HEADER` | `COM_CODE,BNK_CODE,PCH_SERIAL,PCH_FISCAL_YEAR` |
| 312 | `DBA.EMP_HOLIDAY_BALANCE` | `COM_CODE,EM_CODE` | `DBA.EMPLOYEE` | `COM_CODE,EM_CODE` |
| 313 | `DBA.EMP_HOLIDAY_OB` | `COM_CODE,EM_CODE` | `DBA.EMPLOYEE` | `COM_CODE,EM_CODE` |
| 314 | `DBA.SECURITY_INFO` | `USER_CODE,COM_CODE` | `DBA.USER_COMPANY` | `USER_CODE,COM_CODE` |
| 315 | `DBA.SYSTEM_PARAMETER` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 316 | `DBA."WINDOW"` | `MOD_MODULE_ID` | `DBA.MODULES` | `MOD_MODULE_ID` |
| 317 | `DBA.SECURITY_TEMPLATE` | `"WINDOW"` | `DBA."WINDOW"` | `"WINDOW"` |
| 318 | `DBA.ALLOWANCES_ACCUMULATION_HEADER` | `COM_CODE,EM_CODE` | `DBA.EMPLOYEE` | `COM_CODE,EM_CODE` |
| 319 | `DBA.ALLOWANCES_ACCUMULATION_HEADER` | `ORG_CODE_L1,ORG_CODE_L2,ORG_CODE_L3,ORG_CODE_L4,ORG_CODE_L5,ORG_CODE_L6` | `DBA.ORGANIZATION_CHART` | `ORG_CODE_L1,ORG_CODE_L2,ORG_CODE_L3,ORG_CODE_L4,ORG_CODE_L5,ORG_CODE_L6` |
| 320 | `DBA.GIFTS_AND_BONUS` | `COM_CODE,ADG_CODE,AD_CODE` | `DBA.ALLOWAN_DEDUCTION` | `COM_CODE,ADG_CODE,AD_CODE` |
| 321 | `DBA.GIFTS_AND_BONUS` | `ORG_CODE_L1,ORG_CODE_L2,ORG_CODE_L3,ORG_CODE_L4,ORG_CODE_L5,ORG_CODE_L6` | `DBA.ORGANIZATION_CHART` | `ORG_CODE_L1,ORG_CODE_L2,ORG_CODE_L3,ORG_CODE_L4,ORG_CODE_L5,ORG_CODE_L6` |
| 322 | `DBA.TIME_SHEET_TRANSACTION` | `COM_CODE,EM_CODE` | `DBA.EMPLOYEE` | `COM_CODE,EM_CODE` |
| 323 | `DBA.TIME_SHEET_TRANSACTION` | `COC_CODE_L1,COC_CODE_L2,COC_CODE_L3,COC_CODE_L4,COC_CODE_L5,COC_CODE_L6` | `DBA.COST_CENTERS` | `COC_CODE_L1,COC_CODE_L2,COC_CODE_L3,COC_CODE_L4,COC_CODE_L5,COC_CODE_L6` |
| 324 | `DBA.ALLOWANCES_ACCUMULATION_DETAIL` | `COM_CODE,ADG_CODE,AD_CODE` | `DBA.ALLOWAN_DEDUCTION` | `COM_CODE,ADG_CODE,AD_CODE` |
| 325 | `DBA.ALLOWANCES_ACCUMULATION_DETAIL` | `AAH_SERIAL` | `DBA.ALLOWANCES_ACCUMULATION_HEADER` | `AAH_SERIAL` |
| 326 | `DBA.EMP_ALL_DED` | `COM_CODE,ADG_CODE,AD_CODE` | `DBA.ALLOWAN_DEDUCTION` | `COM_CODE,ADG_CODE,AD_CODE` |
| 327 | `DBA.EMP_ALL_DED` | `COM_CODE,EM_CODE` | `DBA.EMPLOYEE` | `COM_CODE,EM_CODE` |
| 328 | `DBA.REPEATED_TRANSACTION` | `COM_CODE,EM_CODE` | `DBA.EMPLOYEE` | `COM_CODE,EM_CODE` |
| 329 | `DBA.REPEATED_TRANSACTION` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 330 | `DBA.REPEATED_TRANSACTION` | `COM_CODE,ADG_CODE,AD_CODE` | `DBA.ALLOWAN_DEDUCTION` | `COM_CODE,ADG_CODE,AD_CODE` |
| 331 | `DBA.EMP_ALL_DED_EDIT_VALUE` | `COM_CODE,EM_CODE` | `DBA.EMPLOYEE` | `COM_CODE,EM_CODE` |
| 332 | `DBA.EMP_BANKS` | `COM_CODE,EM_CODE` | `DBA.EMPLOYEE` | `COM_CODE,EM_CODE` |
| 333 | `DBA.EMP_BANKS` | `BNK_CODE` | `DBA.BANKS` | `BNK_CODE` |
| 334 | `DBA.EMP_BANKS` | `CUR_CODE` | `DBA.CURRENCY` | `CUR_CODE` |
| 335 | `DBA.EMP_BENEFITS` | `COM_CODE,EM_CODE` | `DBA.EMPLOYEE` | `COM_CODE,EM_CODE` |
| 336 | `DBA.EMP_BENEFITS` | `B_CODE` | `DBA.BENEFIT` | `B_CODE` |
| 337 | `DBA.EMP_TEMP_TABLE2` | `COM_CODE,EM_CODE` | `DBA.EMPLOYEE` | `COM_CODE,EM_CODE` |
| 338 | `DBA.EMP_TEMP_TABLE2` | `CUR_CODE` | `DBA.CURRENCY` | `CUR_CODE` |
| 339 | `DBA.PAYSLIP_CALC_MONTH` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 340 | `DBA.PAYSLIP_MONTHLY` | `COM_CODE,EM_CODE` | `DBA.EMPLOYEE` | `COM_CODE,EM_CODE` |
| 341 | `DBA.PAYSLIP_MONTHLY` | `ADG_CODE` | `DBA.ALLOWAN_DEDUC_GROUP` | `ADG_CODE` |
| 342 | `DBA.payslip_monthly_copy` | `COM_CODE,EM_CODE` | `DBA.EMPLOYEE` | `COM_CODE,EM_CODE` |
| 343 | `DBA.payslip_monthly_copy` | `ADG_CODE` | `DBA.ALLOWAN_DEDUC_GROUP` | `ADG_CODE` |
| 344 | `DBA.PAYSLIP_REPORT_TEMP_TABLE` | `COM_CODE,EM_CODE` | `DBA.EMPLOYEE` | `COM_CODE,EM_CODE` |
| 345 | `DBA.PAYSLIP_SHEET_SETUP` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 346 | `DBA.PAYSLIP_SHEET_SETUP` | `ADG_CODE` | `DBA.ALLOWAN_DEDUC_GROUP` | `ADG_CODE` |
| 347 | `DBA.ITEM_STORE_OPEN_BAL_DETAIL` | `COM_CODE,STO_CODE,ITM_SERIAL` | `DBA.ITEM_STORE_OPEN_BAL` | `COM_CODE,STO_CODE,ITM_SERIAL` |
| 348 | `DBA.MEDICAL_INS_TREE` | `MI_PARENT_CODE_L1,MI_PARENT_CODE_L2,MI_PARENT_CODE_L3,MI_PARENT_CODE_L4,MI_PARENT_CODE_L5,MI_PARENT_CODE_L6` | `DBA.MEDICAL_INS_TREE` | `MI_CODE_L1,MI_CODE_L2,MI_CODE_L3,MI_CODE_L4,MI_CODE_L5,MI_CODE_L6` |
| 349 | `DBA.COM_MEDICAL_INS` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 350 | `DBA.COM_MEDICAL_INS` | `MI_CODE_L1,MI_CODE_L2,MI_CODE_L3,MI_CODE_L4,MI_CODE_L5,MI_CODE_L6` | `DBA.MEDICAL_INS_TREE` | `MI_CODE_L1,MI_CODE_L2,MI_CODE_L3,MI_CODE_L4,MI_CODE_L5,MI_CODE_L6` |
| 351 | `DBA.EMP_MEDICAL_INS` | `COM_CODE,EM_CODE` | `DBA.EMPLOYEE` | `COM_CODE,EM_CODE` |
| 352 | `DBA.EMP_MEDICAL_INS` | `COM_CODE,CMI_SERIAL` | `DBA.COM_MEDICAL_INS` | `COM_CODE,CMI_SERIAL` |
| 353 | `DBA.USER_COMPANY_STORE` | `COM_CODE,USER_CODE` | `DBA.USER_COMPANY` | `COM_CODE,USER_CODE` |
| 354 | `DBA.USER_COMPANY_STORE` | `COM_CODE,STO_CODE` | `DBA.COMPANY_STORES` | `COM_CODE,STO_CODE` |
| 355 | `DBA.payroll_jv_acc_header_setup` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 356 | `DBA.payroll_jv_acc_header_setup` | `COM_CODE,CCC_COST_SERIAL` | `DBA.COMPANY_COST_CENTERS` | `COM_CODE,CCC_COST_SERIAL` |
| 357 | `DBA.PAYROLL_JV_ACC_LINES_SETUP` | `COM_CODE,PJVHS_SERIAL` | `DBA.payroll_jv_acc_header_setup` | `COM_CODE,PJVHS_SERIAL` |
| 358 | `DBA.OPEN_BAL_ITEM_COMPANY` | `COM_CODE,ITM_SERIAL` | `DBA.ITEM_COMPANY` | `COM_CODE,ITM_SERIAL` |
| 359 | `DBA.GL_BUDGET` | `COM_CODE,CHRT_SERIAL` | `DBA.COMPANY_CHART_OF_ACCOUNT` | `COM_CODE,CHRT_SERIAL` |
| 360 | `DBA.ITEM_PURCHASE_HIST` | `COM_CODE,ITM_SERIAL` | `DBA.ITEM_COMPANY` | `COM_CODE,ITM_SERIAL` |
| 361 | `DBA.PAY_SLIP_SETUP` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 362 | `DBA.YEARLY_INCREASE_HEADER` | `COM_CODE,EM_CODE` | `DBA.EMPLOYEE` | `COM_CODE,EM_CODE` |
| 363 | `DBA.YEARLY_INCREASE_DETAIL` | `COM_CODE,EM_CODE,YIH_YEAR` | `DBA.YEARLY_INCREASE_HEADER` | `COM_CODE,EM_CODE,YIH_YEAR` |
| 364 | `DBA.YEARLY_INCREASE_DETAIL` | `COM_CODE,ADG_CODE,AD_CODE` | `DBA.ALLOWAN_DEDUCTION` | `COM_CODE,ADG_CODE,AD_CODE` |
| 365 | `DBA.PAY_SLIP_CALC` | `COM_CODE,PSS_SERIAL,PSS_TYPE` | `DBA.PAY_SLIP_SETUP` | `COM_CODE,PSS_SERIAL,PSS_TYPE` |
| 366 | `DBA.PURCHASE_ORDER_STORE_ITEMS` | `COM_CODE,PO_SERIAL,PO_FISCAL_YEAR,POI_ITEM_SERIAL` | `DBA.PURCHASE_ORDER_ITEMS` | `COM_CODE,PO_SERIAL,PO_FISCAL_YEAR,POI_ITEM_SERIAL` |
| 367 | `DBA.PURCHASE_ORDER_STORE_ITEMS` | `STO_CODE` | `DBA.STORES` | `STO_CODE` |
| 368 | `DBA.PURCHASE_ORDER_STORE_ITEMS` | `COM_CODE,ITM_SERIAL` | `DBA.ITEM_COMPANY` | `COM_CODE,ITM_SERIAL` |
| 369 | `DBA.PURCHASE_ORDER_STORE_ITEMS` | `ISP_CODE` | `DBA.ITEM_UNIT` | `ITU_CODE` |
| 370 | `DBA.CST_JOB_ORDER_HEADER` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 371 | `DBA.CST_JOB_ORDER_HEADER` | `COM_CODE,ITM_SERIAL` | `DBA.ITEM_COMPANY` | `COM_CODE,ITM_SERIAL` |
| 372 | `DBA.CST_JOB_ORDER_HEADER` | `ISP_CODE` | `DBA.ITEM_UNIT` | `ITU_CODE` |
| 373 | `DBA.CST_JOB_ORDER_HEADER` | `COM_CODE,JOH_REORDER_FISCAL_YEAR,JOH_REORDER_DOC_SERIAL` | `DBA.CST_JOB_ORDER_HEADER` | `COM_CODE,JOH_FISCAL_YEAR,JOH_DOC_SERIAL` |
| 374 | `DBA.CST_JOB_ORDER_HEADER` | `COM_CODE,CUS_SERIAL` | `DBA.CUSTOMER_COMAPNY` | `COM_CODE,CUS_SERIAL` |
| 375 | `DBA.CST_JOB_ORDER_HEADER` | `COM_CODE,CCC_COST_SERIAL` | `DBA.COMPANY_COST_CENTERS` | `COM_CODE,CCC_COST_SERIAL` |
| 376 | `DBA.CST_JOB_ORDER_DETAIL` | `COM_CODE,JOH_FISCAL_YEAR,JOH_DOC_SERIAL` | `DBA.CST_JOB_ORDER_HEADER` | `COM_CODE,JOH_FISCAL_YEAR,JOH_DOC_SERIAL` |
| 377 | `DBA.CST_JOB_ORDER_DETAIL` | `COM_CODE,ITM_SERIAL` | `DBA.ITEM_COMPANY` | `COM_CODE,ITM_SERIAL` |
| 378 | `DBA.CST_JOB_ORDER_DETAIL` | `ISP_CODE` | `DBA.ITEM_UNIT` | `ITU_CODE` |
| 379 | `DBA.STORE_DATE_SERIAL` | `STO_CODE,COM_CODE` | `DBA.COMPANY_STORES` | `STO_CODE,COM_CODE` |
| 380 | `DBA.ITEM_COMPANY_STORE_PRICE` | `PRT_CODE` | `DBA.PRICE_TYPE` | `PRT_CODE` |
| 381 | `DBA.ITEM_COMPANY_STORE_PRICE` | `COM_CODE,STO_CODE,ITM_SERIAL` | `DBA.ITEM_STORE_COMPANY` | `COM_CODE,STO_CODE,ITM_SERIAL` |
| 382 | `DBA.ITEM_BOUNS_HEADER` | `COM_CODE` | `DBA.COMPANY` | `COM_CODE` |
| 383 | `DBA.ITEM_BOUNS_HEADER` | `COM_CODE,ITM_SERIAL` | `DBA.ITEM_COMPANY` | `COM_CODE,ITM_SERIAL` |
| 384 | `DBA.ITEM_BOUNS_HEADER` | `ISP_CODE` | `DBA.ITEM_UNIT` | `ITU_CODE` |
| 385 | `DBA.ITEM_BOUNS_HEADER` | `COM_CODE,STO_CODE` | `DBA.COMPANY_STORES` | `COM_CODE,STO_CODE` |
| 386 | `DBA.ITEM_BOUNS_DETAIL` | `IBH_BOUNS_CODE,COM_CODE` | `DBA.ITEM_BOUNS_HEADER` | `IBH_BOUNS_CODE,COM_CODE` |
| 387 | `DBA.ITEM_BOUNS_DETAIL` | `COM_CODE,ITM_SERIAL` | `DBA.ITEM_COMPANY` | `COM_CODE,ITM_SERIAL` |
| 388 | `DBA.ITEM_BOUNS_DETAIL` | `ISP_CODE` | `DBA.ITEM_UNIT` | `ITU_CODE` |
| 389 | `DBA.ISSUE_TRANS_HEADER_EXT` | `COM_CODE,DEFAULT_SAL_SERIAL` | `DBA.SALESMAN` | `COM_CODE,SAL_SERIAL` |
| 390 | `DBA.ISSUE_TRANS_HEADER_EXT` | `COM_CODE,ACTUAL_DIST_SERIAL` | `DBA.SALESMAN` | `COM_CODE,SAL_SERIAL` |
| 391 | `DBA.ISSUE_TRANS_HEADER_EXT` | `COM_CODE,DEFAULT_DIST_SERIAL` | `DBA.SALESMAN` | `COM_CODE,SAL_SERIAL` |
| 392 | `DBA.fa_asset_class` | `com_code,fa_glasac_chart_serial` | `DBA.COMPANY_CHART_OF_ACCOUNT` | `COM_CODE,CHRT_SERIAL` |
| 393 | `DBA.fa_asset_class` | `com_code,fa_glasac_tree_code_l1,fa_glasac_tree_code_l2,fa_glasac_tree_code_l3,fa_glasac_tree_code_l4,fa_glasac_tree_code_l5,fa_glasac_tree_code_l6` | `DBA.COMPANY_ACCOUNT_CHART_TREE` | `COM_CODE,TREE_CODE_L1,TREE_CODE_L2,TREE_CODE_L3,TREE_CODE_L4,TREE_CODE_L5,TREE_CODE_L6` |
| 394 | `DBA.fa_asset_class` | `com_code,fa_cumdep_tree_code_l1,fa_cumdep_tree_code_l2,fa_cumdep_tree_code_l3,fa_cumdep_tree_code_l4,fa_cumdep_tree_code_l5,fa_cumdep_tree_code_l6` | `DBA.COMPANY_ACCOUNT_CHART_TREE` | `COM_CODE,TREE_CODE_L1,TREE_CODE_L2,TREE_CODE_L3,TREE_CODE_L4,TREE_CODE_L5,TREE_CODE_L6` |
| 395 | `DBA.fa_asset_class` | `com_code,fa_expdep_tree_code_l1,fa_expdep_tree_code_l2,fa_expdep_tree_code_l3,fa_expdep_tree_code_l4,fa_expdep_tree_code_l5,fa_expdep_tree_code_l6` | `DBA.COMPANY_ACCOUNT_CHART_TREE` | `COM_CODE,TREE_CODE_L1,TREE_CODE_L2,TREE_CODE_L3,TREE_CODE_L4,TREE_CODE_L5,TREE_CODE_L6` |
| 396 | `DBA.fa_asset_class` | `com_code,fa_place_tree_code_l1,fa_place_tree_code_l2,fa_place_tree_code_l3,fa_place_tree_code_l4,fa_place_tree_code_l5,fa_place_tree_code_l6` | `DBA.COMPANY_ACCOUNT_CHART_TREE` | `COM_CODE,TREE_CODE_L1,TREE_CODE_L2,TREE_CODE_L3,TREE_CODE_L4,TREE_CODE_L5,TREE_CODE_L6` |
| 397 | `DBA.fa_asset_class` | `com_code,fa_asscont_tree_code_l1,fa_asscont_tree_code_l2,fa_asscont_tree_code_l3,fa_asscont_tree_code_l4,fa_asscont_tree_code_l5,fa_asscont_tree_code_l6` | `DBA.COMPANY_ACCOUNT_CHART_TREE` | `COM_CODE,TREE_CODE_L1,TREE_CODE_L2,TREE_CODE_L3,TREE_CODE_L4,TREE_CODE_L5,TREE_CODE_L6` |
| 398 | `DBA.fa_asset_class` | `com_code,fa_cumdep_chart_serial` | `DBA.COMPANY_CHART_OF_ACCOUNT` | `COM_CODE,CHRT_SERIAL` |
| 399 | `DBA.fa_asset_class` | `com_code,fa_expdep_chart_serial` | `DBA.COMPANY_CHART_OF_ACCOUNT` | `COM_CODE,CHRT_SERIAL` |
| 400 | `DBA.fa_asset_class` | `com_code,fa_place_chart_serial` | `DBA.COMPANY_CHART_OF_ACCOUNT` | `COM_CODE,CHRT_SERIAL` |
| 401 | `DBA.fa_asset_class` | `com_code,fa_asscont_chart_serial` | `DBA.COMPANY_CHART_OF_ACCOUNT` | `COM_CODE,CHRT_SERIAL` |
| 402 | `DBA.fa_asset_card` | `com_code,fa_glasac_chart_serial` | `DBA.COMPANY_CHART_OF_ACCOUNT` | `COM_CODE,CHRT_SERIAL` |
| 403 | `DBA.fa_asset_card` | `com_code,fa_cumdep_chart_serial` | `DBA.COMPANY_CHART_OF_ACCOUNT` | `COM_CODE,CHRT_SERIAL` |
| 404 | `DBA.fa_asset_card` | `com_code,fa_expdep_chart_serial` | `DBA.COMPANY_CHART_OF_ACCOUNT` | `COM_CODE,CHRT_SERIAL` |
| 405 | `DBA.fa_asset_card` | `com_code,fa_place_chart_serial` | `DBA.COMPANY_CHART_OF_ACCOUNT` | `COM_CODE,CHRT_SERIAL` |
| 406 | `DBA.fa_asset_card` | `com_code,fa_asscont_chart_serial` | `DBA.COMPANY_CHART_OF_ACCOUNT` | `COM_CODE,CHRT_SERIAL` |
| 407 | `DBA.fa_asset_card` | `cur_code` | `DBA.CURRENCY` | `CUR_CODE` |
| 408 | `DBA.fa_asset_card` | `com_code,fa_ascl_serial` | `DBA.fa_asset_class` | `com_code,fa_serial` |
| 409 | `DBA.fa_asset_trans_detail` | `com_code,ccc_cost_serial` | `DBA.COMPANY_COST_CENTERS` | `COM_CODE,CCC_COST_SERIAL` |
| 410 | `DBA.fa_asset_trans_detail` | `com_code,fa_as_serial` | `DBA.fa_asset_card` | `com_code,fa_as_serial` |
| 411 | `DBA.gl_balance_sheet_setup_detail` | `com_code,bss_serial,bss_type` | `DBA.GL_BALANCE_SHEET_SETUP` | `COM_CODE,BSS_SERIAL,BSS_TYPE` |
| 412 | `DBA.ins_off_table` | `cou_code_l1,cou_code_l2,cou_code_l3,cou_code_l4,cou_code_l5,cou_code_l6` | `DBA.COUNTRY` | `COU_CODE_L1,COU_CODE_L2,COU_CODE_L3,COU_CODE_L4,COU_CODE_L5,COU_CODE_L6` |
| 413 | `DBA.balance_adjustment` | `com_code,sto_code,itm_serial` | `DBA.ITEM_STORE_COMPANY` | `COM_CODE,STO_CODE,ITM_SERIAL` |
| 414 | `DBA.balance_issue_rm` | `com_code,sto_code,itm_serial` | `DBA.ITEM_STORE_COMPANY` | `COM_CODE,STO_CODE,ITM_SERIAL` |
| 415 | `DBA.balance_issue` | `com_code,sto_code,itm_serial` | `DBA.ITEM_STORE_COMPANY` | `COM_CODE,STO_CODE,ITM_SERIAL` |
| 416 | `DBA.balance_recieve` | `com_code,sto_code,itm_serial` | `DBA.ITEM_STORE_COMPANY` | `COM_CODE,STO_CODE,ITM_SERIAL` |
| 417 | `DBA.balance_ret_issue` | `com_code,sto_code,itm_serial` | `DBA.ITEM_STORE_COMPANY` | `COM_CODE,STO_CODE,ITM_SERIAL` |
| 418 | `DBA.balance_ret_rec` | `com_code,sto_code,itm_serial` | `DBA.ITEM_STORE_COMPANY` | `COM_CODE,STO_CODE,ITM_SERIAL` |
| 419 | `DBA.balance_transf_in` | `com_code,sto_code,itm_serial` | `DBA.ITEM_STORE_COMPANY` | `COM_CODE,STO_CODE,ITM_SERIAL` |
| 420 | `DBA.balance_transf_out` | `com_code,sto_code,itm_serial` | `DBA.ITEM_STORE_COMPANY` | `COM_CODE,STO_CODE,ITM_SERIAL` |
| 421 | `DBA.system_balance` | `com_code,sal_serial` | `DBA.SALESMAN` | `COM_CODE,SAL_SERIAL` |
| 422 | `DBA.system_balance` | `com_code` | `DBA.COMPANY` | `COM_CODE` |
| 423 | `DBA.system_balance` | `com_code,ven_serial` | `DBA.COMPANY_VENDORS` | `COM_CODE,VEN_SERIAL` |
| 424 | `DBA.system_balance` | `com_code,cus_serial` | `DBA.CUSTOMER_COMAPNY` | `COM_CODE,CUS_SERIAL` |
| 425 | `DBA.system_balance` | `com_code,itm_serial,sto_code` | `DBA.ITEM_STORE_COMPANY` | `COM_CODE,ITM_SERIAL,STO_CODE` |
| 426 | `DBA.system_balance` | `mod_module_id,mtt_trans_type_1,mtt_trans_type_2` | `DBA.MODULE_TRANSACTIONS` | `MOD_MODULE_ID,MTT_TRANS_TYPE_1,MTT_TRANS_TYPE_2` |
| 427 | `DBA.issue_trans_header` | `com_code,sto_code,return_trans_type_code_level1,return_trans_type_code_level2,return_trans_no,return_fisical_year` | `DBA.issue_trans_header` | `com_code,sto_code,trans_type_code_level1,trans_type_code_level2,trans_no,fisical_year` |
| 428 | `DBA.issue_trans_header` | `sal_serial,com_code` | `DBA.SALESMAN` | `SAL_SERIAL,COM_CODE` |
| 429 | `DBA.issue_trans_header` | `com_code,ccc_cost_serial` | `DBA.COMPANY_COST_CENTERS` | `COM_CODE,CCC_COST_SERIAL` |
| 430 | `DBA.issue_trans_header` | `com_code,sto_code` | `DBA.COMPANY_STORES` | `COM_CODE,STO_CODE` |
| 431 | `DBA.issue_trans_header` | `cur_code` | `DBA.CURRENCY` | `CUR_CODE` |
| 432 | `DBA.issue_trans_header` | `cus_serial` | `DBA.CUSTOMER` | `CUS_SERIAL` |
| 433 | `DBA.issue_trans_header` | `com_code,cus_serial` | `DBA.CUSTOMER_COMAPNY` | `COM_CODE,CUS_SERIAL` |
| 434 | `DBA.issue_transaction_items` | `isp_code` | `DBA.ITEM_UNIT` | `ITU_CODE` |
| 435 | `DBA.issue_transaction_items` | `com_code,sto_code,bonus_itm_serial` | `DBA.ITEM_STORE_COMPANY` | `COM_CODE,STO_CODE,ITM_SERIAL` |
| 436 | `DBA.issue_transaction_items` | `com_code,sto_code,itm_serial` | `DBA.ITEM_STORE_COMPANY` | `COM_CODE,STO_CODE,ITM_SERIAL` |
| 437 | `DBA.issue_transaction_items` | `com_code,sal_serial` | `DBA.SALESMAN` | `COM_CODE,SAL_SERIAL` |
| 438 | `DBA.issue_transaction_items` | `com_code,sto_code,trans_type_code_level1,trans_type_code_level2,trans_no,fisical_year` | `DBA.issue_trans_header` | `com_code,sto_code,trans_type_code_level1,trans_type_code_level2,trans_no,fisical_year` |
| 439 | `DBA.balance_issue1` | `com_code,sto_code,itm_serial` | `DBA.ITEM_STORE_COMPANY` | `COM_CODE,STO_CODE,ITM_SERIAL` |
| 440 | `DBA.balance_recieve1` | `com_code,sto_code,itm_serial` | `DBA.ITEM_STORE_COMPANY` | `COM_CODE,STO_CODE,ITM_SERIAL` |
| 441 | `DBA.balance_ret_issue1` | `com_code,sto_code,itm_serial` | `DBA.ITEM_STORE_COMPANY` | `COM_CODE,STO_CODE,ITM_SERIAL` |
| 442 | `DBA.balance_ret_rec1` | `com_code,sto_code,itm_serial` | `DBA.ITEM_STORE_COMPANY` | `COM_CODE,STO_CODE,ITM_SERIAL` |
| 443 | `DBA.issue_trans_items_ext` | `com_code,sto_code,trans_type_code_level1,trans_type_code_level2,trans_no,iss_item_serial,fisical_year` | `DBA.issue_transaction_items` | `com_code,sto_code,trans_type_code_level1,trans_type_code_level2,trans_no,iss_item_serial,fisical_year` |
| 444 | `DBA.Future_menus` | `fum_parent_code_l1,fum_parent_code_l2,fum_parent_code_l3,fum_parent_code_l4,fum_parent_code_l5,fum_parent_code_l6` | `DBA.Future_menus` | `fum_code_l1,fum_code_l2,fum_code_l3,fum_code_l4,fum_code_l5,fum_code_l6` |
| 445 | `DBA.characteristic_rep_form_i` | `form_number,com_code` | `DBA.characteristic_rep_form_h` | `form_number,com_code` |
| 446 | `DBA.characteristic_rep_form_i` | `itm_serial` | `DBA.ITEM_MASTER` | `ITM_SERIAL` |
| 447 | `DBA.customer_ext` | `cus_serial` | `DBA.CUSTOMER` | `CUS_SERIAL` |
| 448 | `DBA.customer_ext` | `jt_code` | `DBA.JOB_TITLE` | `JT_CODE` |
| 449 | `DBA.sales_order_header` | `com_code,cus_serial` | `DBA.CUSTOMER_COMAPNY` | `COM_CODE,CUS_SERIAL` |
| 450 | `DBA.sales_order_header` | `com_code,dlv_sto_code` | `DBA.COMPANY_STORES` | `COM_CODE,STO_CODE` |
| 451 | `DBA.sales_order_items` | `com_code,actual_sto_code` | `DBA.COMPANY_STORES` | `COM_CODE,STO_CODE` |
| 452 | `DBA.sales_order_items` | `com_code,dlv_sto_code` | `DBA.COMPANY_STORES` | `COM_CODE,STO_CODE` |
| 453 | `DBA.sales_order_items` | `com_code,item_cus_serial` | `DBA.CUSTOMER_COMAPNY` | `COM_CODE,CUS_SERIAL` |
| 454 | `DBA.sales_order_items` | `com_code,itm_serial` | `DBA.ITEM_COMPANY` | `COM_CODE,ITM_SERIAL` |
| 455 | `DBA.sales_order_items` | `com_code,so_serial,so_fiscal_year` | `DBA.sales_order_header` | `com_code,so_serial,so_fiscal_year` |
| 456 | `DBA.customer_complain_inquire` | `com_code,cus_serial` | `DBA.CUSTOMER_COMAPNY` | `COM_CODE,CUS_SERIAL` |
| 457 | `DBA.item_store_comp_ven_followup` | `com_code,sto_code,itm_serial` | `DBA.ITEM_STORE_COMPANY` | `COM_CODE,STO_CODE,ITM_SERIAL` |
| 458 | `DBA.item_store_comp_ven_followup` | `com_code,ven_serial,itm_serial` | `DBA.ITEM_COMPANY_VENDOR` | `COM_CODE,VEN_SERIAL,ITM_SERIAL` |
| 459 | `DBA.sales_order_followup` | `com_code,so_serial,so_fiscal_year` | `DBA.sales_order_header` | `com_code,so_serial,so_fiscal_year` |
| 460 | `DBA.contract_master` | `mi_code_l1,mi_code_l2,mi_code_l3,mi_code_l4,mi_code_l5,mi_code_l6` | `DBA.MEDICAL_INS_TREE` | `MI_CODE_L1,MI_CODE_L2,MI_CODE_L3,MI_CODE_L4,MI_CODE_L5,MI_CODE_L6` |
| 461 | `DBA.contract_detail` | `cont_serial` | `DBA.contract_master` | `cont_serial` |
| 462 | `DBA.contract_detail` | `itg_code_l1,itg_code_l2,itg_code_l3,itg_code_l4,itg_code_l5,itg_code_l6` | `DBA.ITEM_GROUPS` | `ITG_CODE_L1,ITG_CODE_L2,ITG_CODE_L3,ITG_CODE_L4,ITG_CODE_L5,ITG_CODE_L6` |
| 463 | `DBA.contract_detail` | `itc_code` | `DBA.ITEM_COLOR` | `ITC_CODE` |
| 464 | `DBA.contract_detail` | `ic_code` | `DBA.ITEM_CATEGORY` | `IC_CODE` |
| 465 | `DBA.contract_detail` | `ig_code` | `DBA.ITEM_GENDER` | `IG_CODE` |
| 466 | `DBA.contract_detail` | `imo_code` | `DBA.ITEM_MODEL` | `IMO_CODE` |
| 467 | `DBA.contract_detail` | `is_code` | `DBA.ITEM_SEASON` | `IS_CODE` |
| 468 | `DBA.contract_detail` | `its_code` | `DBA.ITEM_SIZE` | `ITS_CODE` |
| 469 | `DBA.cus_contract` | `com_code` | `DBA.COMPANY` | `COM_CODE` |
| 470 | `DBA.cus_contract` | `cont_serial` | `DBA.contract_master` | `cont_serial` |
| 471 | `DBA.cus_contract` | `com_code,cus_serial` | `DBA.CUSTOMER_COMAPNY` | `COM_CODE,CUS_SERIAL` |
| 472 | `DBA.salary_transaction_detail` | `com_code,em_code,eb_serial` | `DBA.EMP_BANKS` | `COM_CODE,EM_CODE,EB_SERIAL` |
| 473 | `DBA.com_job` | `com_code` | `DBA.COMPANY` | `COM_CODE` |
| 474 | `DBA.com_job` | `com_code,cus_serial` | `DBA.CUSTOMER_COMAPNY` | `COM_CODE,CUS_SERIAL` |
| 475 | `DBA.com_job` | `com_code,ven_serial` | `DBA.COMPANY_VENDORS` | `COM_CODE,VEN_SERIAL` |

## 7. Legacy module and UI reconciliation

The source module analysis reports 114 PBD libraries in the main `D:\\future_25` copy, with domain families including inventory (28 libraries), payroll (14), accounting (13), fixed assets (12), sales (8), purchasing (7), general/setup (2), shell/shared (5), menus (5), maintenance variants (17), and support/integration (3). It also reports large numbers of windows, DataWindows, functions and structures.

The UI analysis describes an MDI-style desktop application with master/detail forms, lookup/choice windows, report/print windows, bilingual Arabic/English window variants, barcode/receipt and other POS device configuration. Exact runtime navigation, screen behavior, validation order, transaction boundaries and role behavior remain partly inferred or unknown.

SGSCTR should recreate business capabilities and user outcomes using its current web/API architecture, not copy PowerBuilder screens or PBD structure. The current UI contains catalogue, supplier, receiving-draft, inventory, transfer, governance and regulatory workspaces. The following remain explicit gaps for later approved phases:
- four-module navigation and module-scoped workspaces/permissions;
- product-family-aware catalogue and professional approval of required fields;
- complete purchasing (RFQ/requisition/PO, commitments, receipt matching, supplier returns);
- approved receipt acceptance, quarantine/release and lot/expiry controls;
- stock counts, adjustments, recalls, FEFO and traceability;
- approved costing and valuation;
- module-specific dispensing/sales and payer claims;
- finance/GL integration and reporting;
- business reports, export/print workflows;
- device integration only if confirmed as needed;
- backup/restore and any branch/offline synchronization policy.

## 8. Data migration and conversion rules

No legacy data migration is authorized by this document. When migration is separately approved:
1. Preserve source table name, primary key, natural key, row identity and source lineage in a staging/import audit layer.
2. Profile the actual database snapshot and reconcile row counts, duplicates, orphaned foreign keys, invalid dates, quantities, money precision and code tables.
3. Use a field-level mapping specification with source column, source type, nullability/default, target field, transformation, validation, confidence, owner and sign-off.
4. Migrate master/reference data before transactional data; transactions must retain document lineage and posting status.
5. Do not fabricate missing lots, expiry, unit conversions, cost layers, payer rules, account mappings or legal entity ownership.
6. Keep source database read-only and preserve a verified backup; migration rehearsal and reconciliation sign-off precede cutover.
7. Do not import PowerBuilder metadata, user credentials, licence/protection values, workstation/device secrets or irrelevant temporary tables into production.

## 9. Unresolved professional and owner approvals

The reconciliation does not close existing open questions:
- Product family taxonomy, product identifiers, batch/lot/expiry/serial and storage conditions (Q11, Q30, Q32, Q38, Q47–Q50).
- Purchasing, receipt acceptance, supplier returns, supplier eligibility and qualification (Q31, Q39, Q43, Q51).
- Stock lifecycle, counts, transfer custody, exception handling and roles (Q33, Q10).
- Moving weighted-average costing and worked examples for receipt, supplier return, transfer, loss, expiry, adjustment, negative stock and close (Q12, Q34, Q44).
- Payer contracts, discounts, coverage, copay/exemption, claim settlement and patient balances (Q14–Q16).
- Legal entity, branch licence/operator/stock ownership and statutory accounting (Q01–Q04, Q17, Q29, Q37).
- Whether payroll/HR, fixed assets, general services, job costing and broad non-pharmacy ERP features belong to shared Special Group platform, contracting, future scope or out of scope (Q66).

No proposed legacy rule is silently promoted into an approved SGSCTR rule. In particular, legacy “average cost” descriptions do not override the owner's Pharmacy moving weighted-average requirement; even that owner requirement still needs accountant/pharmacy approval of calculation timing and edge cases.

## 10. Delivery sequence — gated by evidence and approvals

| Sequence | Work package | Entry criteria | Exit evidence |
|---:|---|---|---|
| 0 | Finish field-level schema and relationship mapping | 321-table inventory + 475 FK inventory completed | Every source field/relationship classified; unknowns and candidate targets recorded; reviewers confirm coverage. |
| 1 | Four-module capability and ownership mapping | Option B selected | Each Pharmacy workflow, master, transaction, report and permission has module owner or shared-capability rationale. |
| 2 | Product/catalogue and location reconciliation | Q38/Q47–Q50 review | Approved family taxonomy, identifiers, units, storage/traceability and location ownership decisions. |
| 3 | Procurement and receipt design | Q31/Q39/Q43/Q51 review | Approved supplier eligibility, PO/receipt matching, acceptance, quarantine, return and audit requirements. |
| 4 | Inventory operational design | Q11–Q13/Q32–Q35 review | Approved ledger, lot/expiry, count, transfer, return, adjustment and worked costing examples. |
| 5 | Dispensing/sales/claims design | Q14–Q16 and pharmacy workflow approvals | Approved workflow, payer-specific calculations, patient balance and settlement examples. |
| 6 | Accounting/cost control design | Q17 and accountant approval | Approved chart/dimensions, module attribution, posting matrix, period close, reconciliation and reports. |
| 7 | Implementation and migration | Approved ADRs/specifications and test cases | API/UI/DB changes, tests, migration rehearsal, reconciliation report and owner sign-off. |
| 8 | Release | Definition of Done, security, operational and professional acceptance | Reproducible build/test evidence, backup/restore, rollback, monitoring and release approval. |

## 11. Immediate engineering gaps found

1. Current `AppDbContext` contains no GL, claims, dispensing/sales, payroll or fixed-asset persistence.
2. Current receipt records are explicitly Draft-only; they are not posted goods receipts.
3. Supplier register/assurance records are draft/unverified/pending, not approved supplier qualification.
4. Catalogue product, unit and conversion records are generic and Draft-only; product-family policy remains unresolved.
5. Stock movement and transfer-request structures exist, but transfer approval creates draft movements and balance-affecting posting remains gated by Q12/Q13; no approved costing engine is evidenced.
6. No purchase-order, invoice matching, supplier-return, claim, payer remittance, patient balance, GL posting, cost-center or budget API was found in the inspected current source set.
7. The four-module model is not yet shown as fully represented across every legacy workflow, entity, endpoint, screen, report and permission.

## 12. Acceptance criteria for closing this reconciliation

- [ ] Every one of the 321 source tables is classified with a field-level mapping decision or explicit exclusion/unknown reason.
- [ ] All 475 foreign-key relationships are mapped, rejected or marked unresolved with rationale.
- [ ] All source module families, workflow sections and UI capability families are represented in the capability matrix.
- [ ] Every pharmacy capability is assigned to one of the four modules or documented as shared.
- [ ] No payroll, fixed-asset, contracting or generic ERP capability is silently brought into Pharmacy scope.
- [ ] All source [O]/[I]/[U] labels remain distinct.
- [ ] All accounting, costing, payer and regulatory rules have the required professional approval records.
- [ ] Approved target design is reconciled against current SGSCTR entities, EF configuration, migrations, API, UI and tests.
- [ ] Migration is separately approved and rehearsed; no legacy DDL is run against the new database.

**Current status:** exhaustive table-name and FK inventory is recorded; workflow/capability mapping is an initial evidence-based assessment. Field-by-field semantics, all UI-to-SQL paths, runtime validation behavior and approved implementation rules are not yet established. This is therefore not a claim that the entire legacy application has already been rebuilt.
