# Pharmacy Group four-module boundary matrix

- Status: **Owner-selected Phase 0 business model; boundary analysis draft**
- Decision: **Option B — four independent operational modules**
- Owner decision date: 2026-11-25; recorded as PHARM-OWN-002.
- Repository evidence snapshot: `master` at `94236489089407e598cd68ead41ee7454c47c3e8`.
- This matrix is not an implementation specification, professional opinion or production authorization.

## 1. Selected business model

The Pharmacy Group consists of exactly four independently operated modules:

1. **Regular Medications**
2. **Chemotherapy Drugs**
3. **Medical Supplies**
4. **Cosmetics**

Each module has independent operational ownership and module-level management financial records and reporting. Group management may receive consolidated management reporting, but module transactions, operational controls and detailed financial records must remain attributable to their owning module.

This choice does **not** establish four legal entities, four statutory companies, four databases, four physical warehouses or a particular schema/deployment design. The registered legal person and statutory accounting structure remain subject to documentary and accountant review.

## 2. Boundary rules for Phase 0

- Each module owns its applicable product records, operational procedures, supplier/procurement transactions, receiving, inventory, pricing and customer/patient-facing transactions, operational approvals and management reporting.
- A module must not read, change, value, issue or financially post another module's records merely because both belong to the Pharmacy Group.
- Group-level administration, identity, audit infrastructure and consolidated reporting may be shared subject to approved least-privilege access and traceable module ownership.
- Shared supplier reference data, pooled procurement, shared physical storage, shared stock, inter-module transfers and cross-module settlements are **not assumed**. Their boundaries require explicit decisions.
- A transfer between two physical locations within one module is different from a transfer between two modules. Existing branch-to-branch route capability does not authorize inter-module movement.
- Separate module management records do not determine the number of statutory ledgers. Statutory books depend on verified legal-entity facts and accountant approval.
- Weighted-average costing is a stated pharmacy requirement. Costing pools, timing and transaction treatment must be approved; no module-level costing design is selected here.
- Provider coverage, patient exemption/10% contribution and the Special Group employee discount remain distinct business concepts. Their eligibility, category applicability and calculation order remain pending.

## 3. Module responsibility profile

| Module | Independent operational responsibility | Distinct controls to discover (not approved rules) |
|---|---|---|
| Regular Medications | Its own catalogue, supplier/procurement transactions, receiving, stock, applicable dispensing/sales, pricing, payer and management records. | Product identity, pack/unit, batch/expiry, dispensing, payer eligibility, patient contribution, returns and recall. |
| Chemotherapy Drugs | Its own catalogue, procurement, receipt, custody, stock, applicable dispensing/sales and financial/management records. | Qualified handling, storage, traceability, authorization, quality release, dispensing and payer applicability. No clinical or handling procedure is inferred. |
| Medical Supplies | Its own catalogue, procurement, receipt, stock, distribution/sales and financial/management records. | Whether devices are included in this module, product/serial/lot/expiry attributes, quality evidence, site restrictions and returns. |
| Cosmetics | Its own catalogue, procurement, receipt, stock, sales/pricing and financial/management records. | Product identity, notification/registration evidence where applicable, batch/expiry, storage, returns and product-specific regulatory controls. |

The table defines ownership boundaries to investigate; it does not prescribe every module's workflow or imply that all four modules use the same process.

## 4. Capability boundary matrix and current source evidence

| Capability | Option B target boundary | Evidence on current master | Finding / gap |
|---|---|---|---|
| Product catalogue | Each module owns its operational product set and approved classification. | `CatalogueProduct` is generic. `CatalogueProductFamilyAssignment` stores one proposed family code with `PendingProfessionalReview`. | No module ownership key or approved module-specific catalogue. |
| Product taxonomy | Exactly four operational modules as selected above; category taxonomy remains professionally reviewable. | Migration `20261114150000_PharmacyProductGovernanceDrafts` permits five labels: RegularMedicine, Chemotherapy, MedicalDevice, MedicalSupply and Cosmetic. | Taxonomy has five proposal labels for four modules. MedicalDevice vs MedicalSupply mapping must be decided; do not silently create a fifth module or merge classifications. |
| Suppliers / procurement | Each module owns its purchasing decisions, terms, orders and transaction history. Group supplier reference sharing is undecided. | Generic Pharmacy supplier, evidence, assurance and onboarding entities/endpoints exist. | No module ownership field or verified PO/purchasing workflow established by inspected files. Supplier qualification and eligibility remain gated. |
| Receiving | Each module owns receipt decisions and evidence for its transactions. | `PharmacyReceiptDraft` and API/BFF/UI create and list Draft receipt records. Response explicitly says no stock balance or movement is created. | Non-posting receipt drafts only; no module ownership, PO match, accepted-stock posting or approved receiving SOP. |
| Stock ledger | Separate module-owned stock records and movement authority, with auditable group visibility. | `StockMovement` and migration `20261117123041_20261117120000_StockMovementLedger` exist. API creates Draft movements; balances query only Posted rows. | Ledger foundation exists, but the inspected movement API has no posting command. No module identifier/ownership on movement rows. |
| Physical locations | Location stock must be attributable to the responsible module even if a site is shared. | Organization locations are registered under sector code `PHARMACIES`; owner identified Mokattam, Student Hospital, Qasr El-Aini and Manial. | Location-to-module assignment and shared-site custody are not defined in inspected model. Site licensing/operator evidence remains pending. |
| Location transfers | Transfers within one module follow its approved location workflow. Cross-module movement is a separate policy. | `StockTransferRequest` and API create, submit, send for approval, approve, reject and cancel requests. Approval creates paired Draft movements only. | No dispatch/receipt lifecycle or posting in the inspected endpoint; no module boundary check/field. No balance effect from approval. |
| Weighted-average costing | Each module's stock valuation and management results must remain separately attributable. | Requirement appears in governance/domain records; no costing engine or valuation posting was found in inspected source. | Cost pool, timing, transfers, returns, adjustments, negative stock, rounding and per-module treatment remain open (Q12/Q34/Q44/Q55). |
| Dispensing / sales | Applicable customer/patient transactions belong to the owning module. | No dispensing/sales workflow was evidenced in inspected current-state and source paths. | Not established as implemented. Clinical/pharmacy operating approval required. |
| Provider reimbursement / claims | Each applicable module owns payer agreements, claims, remittance and receivable attribution. | Existing domain draft distinguishes payer coverage, discounts, patient copay, claims and remittance; no operational claim workflow was found. | Contract applicability, calculation order and claim lifecycle remain open (Q14-Q16/Q54). |
| Patient contribution / employee discount | Rules and financial effects must be attributable to the module and transaction. | Owner business requirements are recorded; no operational pricing/discount/receivable implementation was evidenced. | 0% exemption, 10% contribution and employee discount interaction remain unapproved. |
| Accounting / reporting | Independent module-level management records and reports; group consolidation without losing module attribution. | Current accounting guidance describes sector/location dimensions and provisional one-entity model; no GL or module-level posting engine was evidenced. | Module-level account/report structure and statutory reconciliation require accountant/legal decisions (Q01/Q04/Q17/Q55). |
| Quality / regulatory | Each module applies only its approved product/site-specific controls. | Pending family/evidence records and EDA intelligence foundations exist. | No category-specific operational policy or regulatory applicability is approved; INV-PRO-001, INV-REG-001 and INV-QLT-001 remain pending. |
| Access / audit | Module-scoped permissions, audit and separation of duties; group oversight is controlled. | APIs use authenticated groups and Administrator/local-development write policies; catalogue audit events exist. | No approved module-level permission or separation-of-duties matrix; module scope is not represented in inspected operational entities. |
| User experience | Users enter the correct module and see its own work queues, records and reports. | One Pharmacy Inventory workspace at `/pharmacies/inventory` has shared catalogue, suppliers, receiving, transfers, batches, reports, approvals and readiness tabs. | Four independent operational workspaces and module-specific navigation are not evidenced. |

## 5. Cross-module questions that remain open

1. Can a supplier legal identity be shared as a group reference while each module owns its contracts, qualification decisions and purchase orders?
2. Can one physical warehouse or hospital branch hold stock for multiple modules? If yes, how are ownership, custody, access, counts and reporting separated?
3. Are transfers between modules prohibited, or permitted only through an approved inter-module issue/receipt and financial settlement process?
4. Does the Medical Supplies module include medical devices, or must the product taxonomy distinguish device classes within that module?
5. What is the module-level management accounting model, and how does it reconcile to statutory books after the legal entity is verified?
6. Is weighted-average costing calculated independently per module, and what is the approved cost pool within each module?
7. Which users, limits and separation-of-duties rules apply at group, module and physical-location levels?

These questions are recorded in `.ai/memory/open-questions.md` as Q58-Q65. Existing questions Q01-Q18 and Q22-Q23, Q30-Q55 also remain relevant.

## 6. Phase 0 conclusion

**Confirmed direction:** four independent Pharmacy Group operational modules, with group-level oversight and consolidated management reporting.

**Current implementation conclusion:** the repository contains shared Pharmacy foundations and draft/non-posting inventory capabilities, but the inspected source does not yet implement four independent operational module boundaries. In particular, product, supplier, receipt, movement, transfer, access and UI records are not demonstrably partitioned by the four modules.

**Next safe work:** define module ownership and cross-module policy decisions; reconcile the five proposed taxonomy labels with the four modules; obtain qualified pharmacist, quality, regulatory and accountant decisions where required; then prepare a reviewed domain architecture proposal. Do not activate posting, stock movement, dispensing, claims or financial calculations as part of this matrix.

## 7. Evidence and approval references

- Owner decision: `.ai/governance/approval-register.md` — PHARM-OWN-002.
- Business boundary: `.ai/domain/business-boundaries.md`.
- Existing workflow and costing guardrails: `.ai/domain/pharmacy-workflows.md`, `.ai/domain/accounting-rules.md`.
- Location-transfer proposal: `.ai/domain/pharmacy-stock-transfer-workflow.md` and `.ai/quality/pharmacy-stock-transfer-acceptance.md`.
- Source evidence: `src/Sgsctr.Api/Data/CatalogueProduct.cs`, `CatalogueProductFamilyAssignment.cs`, `PharmacyReceiptDraft.cs`, `PharmacySupplier.cs`, `StockMovement.cs`, `StockTransferRequest.cs`; API extensions under `src/Sgsctr.Api/PharmacyCatalogue`, `PharmacyInventory` and `PharmacySuppliers`; migrations dated 2026-11-14 through 2026-11-17; `web/app/pharmacies/inventory/InventoryWorkspace.tsx`.
- Review limitation: GitHub source/tree inspection only. No local build, automated tests, deployed database inspection, live VM test or professional review was performed for this matrix.


## 8. Legacy Future 25 source baseline — owner-designated 2026-11-25

The owner designated `futher_md/` as the primary legacy business/functional evidence corpus for reconstructing the former pharmacy application in SGSCTR. It is read-only product evidence, not SGSCTR policy or an approval source. See [AI source authority](../governance/ai-agent-source-authority.md).

### 8.1 Corpus inventory and evidence baseline

The folder contains 13 artifacts: nested `AGENTS.md`; `future25_schema.sql`; `future25_schema_report.md`; `future_25_ai_agent_build_spec.md`; `future_25_app_modules.md`; `future_25_app_ui.md`; `future_25_app_workflow.md`; `future_25_architecture.md`; `future_25_cost_control.md`; `future_25_how_app_working.md`; `future_25_rea_evidence.json`; and `future_25_static_analysis.md`.

Observed repository evidence on `master` at commit `12e383dd0279220bf9353d301485f06612f8b23d`:
- Recovered SQL Anywhere 9 DDL: 321 CREATE TABLE, 475 ALTER TABLE (mostly foreign keys), 36 CREATE INDEX, 1 CREATE VIEW, 475 foreign-key clauses and 297 primary-key clauses. The schema report says it was recovered from a translated transaction log, not an authenticated live catalog export.
- The schema report groups tables into inventory/stores (87), application/support (83), accounting/finance (45), payroll/HR (27), setup/security (26), system/PowerBuilder/MobiLink support (21), sales/customers (14), purchasing (12) and fixed assets (6).
- The analysis identifies a PowerBuilder 9 desktop application, compiled PBD libraries, ODBC and SQL Anywhere; MobiLink synchronization is inferred from metadata. No executable was launched and PBD business logic was not decompiled.
- The module/UI/workflow/cost-control documents are static artifact analysis. Their own [O]/[I]/[U] confidence labels and stated limitations must be retained.

### 8.2 Required reconciliation coverage

| Legacy evidence | SGSCTR reconciliation target | Initial handling |
|---|---|---|
| Items, groups, units, conversions, barcodes, batches/expiry and stock balances | Four module-owned catalogues and stock/traceability foundations | Map to Regular Medications, Chemotherapy Drugs, Medical Supplies and Cosmetics; product fields/classification remain subject to Q38 and professional review. |
| Stores, company stores, receipts, issues, returns, transfers, counts and adjustments | Module-owned stock at Mokattam, Student Hospital, Qasr El-Aini and Manial | Preserve location and movement concepts; do not infer module/site assignments or activate posting. |
| Vendor, requisition, RFQ, quotation, purchase order and receiving | Module procurement and supplier capability | Map all entities and lifecycle states; supplier sharing, qualification, purchasing authority and receipt rules remain approval-gated. |
| Sales, customer, price, promotion, discount and transaction history | Applicable pharmacy dispensing/sales and pricing | Map concepts; distinguish retail sales, payer coverage, patient share/exemption and employee discount. No patient-facing or financial behavior without approval. |
| Claims, payer and follow-up structures | Provider agreements, claim submission, adjudication, remittance and receivables | Investigate source tables/workflows; legacy names alone do not prove current contract terms or approved calculation rules. |
| Chart of accounts, vouchers, GL distributions, cost centers, budgets and rollups | Module-level management financial records and group consolidation | Map as accounting requirements; statutory ledger, posting engine, costing pools, tax and valuation require accountant/legal approval. |
| Arabic/English windows, menus, DataWindows, reports, print layouts and exports | SGSCTR web UI, navigation, localization, reports and export acceptance criteria | Translate user tasks and report outputs, not PowerBuilder screen implementation or protected assets. |
| Users, permissions, workstation/session, audit, backup, devices and synchronization | Platform identity, authorization, audit, operations, integration and recovery | Reconstruct only where applicable; current SGSCTR security/deployment decisions govern. |
| Payroll/HR, fixed assets, job costing, general services and other non-pharmacy families | Shared platform or separate sector capability assessment | Inventory and map every capability; do not silently add these to the Pharmacy Sector or assume they are in the current delivery scope. Resolve Q66. |

### 8.3 Non-negotiable reconciliation rules

1. Inventory all 321 legacy table definitions and relationships; classify each table as pharmacy-module-owned, shared platform/reference, cross-cutting accounting, non-pharmacy candidate, technical legacy support, duplicate/obsolete, or unresolved. Record evidence and proposed SGSCTR destination for every table.
2. Map legacy entities/columns/keys/foreign keys/indexes to existing SGSCTR entities, EF configurations, migrations, API routes, UI pages, reports and tests. Mark each as existing/partial/missing/conflicting/not-applicable/unknown. Never equate a legacy table with a required new table without domain analysis.
3. Reconstruct complete workflows from UI, module catalog, workflow, architecture, static-analysis and schema evidence. Include validations, state transitions, permissions, transaction boundaries, reversals, reports and exception paths where evidence supports them.
4. Maintain the four Option B operational boundaries. A legacy company/store/module model must not collapse the four modules or establish legal/statutory structure.
5. Use the active SGSCTR stack and modular-monolith architecture. Do not adopt legacy SQL Anywhere, PowerBuilder, WPF, SQLite demo, MobiLink or the legacy AI build-spec stack recommendations as implementation decisions.
6. Keep all inferred/unknown legacy behavior explicitly unresolved. Cost-control examples, average-cost algorithms, posting mappings, budget enforcement and return/transfer treatment are evidence to analyze, not approval to implement.
7. Build a traceable legacy-to-SGSCTR coverage matrix before declaring scope complete. Then implement in small approved increments with tests; no wholesale schema import or destructive migration.

### 8.4 Current completion status and next gate

- **Completed in this record:** folder discovery; all 13 artifact names inventoried; SQL DDL totals and schema functional-area totals inspected; architecture, module, UI, workflow, cost-control, static-analysis and AI build-spec headings/contents sampled; source confidence and limitations identified.
- **Not completed:** exhaustive per-table/column/FK mapping; full per-screen/report inventory; end-to-end workflow traceability; comparison against every current SGSCTR entity, migration, API, UI route and test; validation of source claims against a live legacy database/runtime.
- **Next safe step:** produce the detailed legacy-to-SGSCTR capability and schema boundary matrix, beginning with pharmacy-critical master data, purchasing/receiving, inventory/stock, transfers, dispensing/sales, claims, costing/accounting and reports. Do not begin broad business implementation until this reconciliation and the relevant approval gates are complete.
