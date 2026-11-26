# Future 25 reuse map — UI, workflow and data traceability

- Status: discovery artifact; **not** approved requirements, runtime parity or implementation authorization.
- Evidence: `futher_md/future_25_app_ui.md`, `future_25_app_workflow.md`, `future25_schema.sql`, `future25_schema_report.md`, and current SGSCTR source reconciliation.
- Legacy confidence: `[O]` static object/schema observed; `[I]` inferred; `[U]` runtime behavior unknown.
- SGSCTR direction: reuse user-visible patterns and business concepts, not PowerBuilder code, protected assets, schema verbatim or unapproved policy.
- Selected Pharmacy boundary: Option B (Regular Medications, Chemotherapy Drugs, Medical Supplies, Cosmetics). Existing generic records are not yet module-isolated.

## Reuse decisions

| Legacy pattern / screen evidence | User task | SGSCTR destination | Data candidates | Reuse disposition / gap |
|---|---|---|---|---|
| `w_genapp_frame`, toolbar, bilingual menu [O/I] | Navigate and switch workspaces | Next.js authenticated shell, sector/module navigation | Identity/session; organization/location references | Reuse shell concept; do not recreate MDI or legacy security |
| `w_master_detail*`, `uo_dw_header_*`, `uo_dw_lines_*` [O/I] | Maintain transaction header + lines | Document workspace with header, line editor, validation summary, save draft | Future document aggregate + line tables | Pattern reusable; APIs and approved lifecycle required |
| `w_generic_choice*`, `w_base_choice` [O/I] | Select product, supplier, location, unit | Searchable dialog/combobox with server search | Catalogue, supplier draft, organization locations | Reuse selection pattern; selection must respect module scope/authorization |
| `uo_dw_finder`, `uo_dw_sorter` [O/I] | Search, filter, sort lists | Shared table filters, search, sort, pagination | List/query endpoints | Reuse UX behavior; API filtering and paging not evidenced for all lists |
| Inventory item master windows; `ITEM_MASTER`, `ITEM_UNIT`, conversion tables [O] | Product identity and packaging | Catalogue workspace | CatalogueProduct, UnitOfMeasure, ProductUnitConversion; staged legacy identifiers | Draft-only target exists; source fields need semantic and pharmacist review |
| `w_header_lines_receive*`; `RATR_TRANSACTION_*` [O/I] | Receive purchases/returns | Receiving workspace | Receipt draft/lines; future PO, inspection, batch/expiry | Draft receiving exists; accepted receipt/stock posting not implemented |
| Issue/return/transfer windows; `issue_trans_*`, `balance_transf_*` [O/I] | Issue, return, move stock | Inventory/transfer workspaces | StockMovement, StockTransferRequest; future lot, custody, in-transit | Only draft scaffolding; no posted effect or complete dispatch/receipt lifecycle |
| `w_balance_report*`, inventory reports [O] | View balances and movement history | Inventory reports | Posted movement query; future lot and valuation dimensions | Read pattern reusable; current balances limited to Posted movement data |
| Purchase order windows; `PURCHASE_ORDER_*`, requisition/RFQ/quotation [O] | Procure from vendors | Future procurement module | Supplier, requisition, RFQ, quote, PO | Not implemented; workflow and approvals pending |
| Sales/issue/POS screens and device settings [O/I] | Dispense/sell and issue receipts | Future dispensing/POS module | Product, patient/payer, price, transaction, claim | Not implemented; clinical, payer and patient-data rules pending |
| Claims tables/windows [O/I] | Prepare/follow-up claims | Future claims workspace | Payer agreement, claim, claim lines, remittance | Legacy names are evidence only; no claims workflow; agreements required |
| GL/journal/cost-center/budget windows [O] | Financial reporting and posting | Separate module accounting/reporting boundary | Future journal, account, cost center, period | No financial posting; accounting policy and entity structure pending |
| Print/preview/report windows; DataWindows [O] | Print/export documents and reports | Report/print service, PDF/Excel, accessible preview | Query/report definitions and approved document snapshots | Pattern reusable; no one-to-one report inventory or validated layouts |
| Arabic/English window variants [O] | Work in Arabic or English | Existing locale provider, RTL/LTR layout | Language-neutral codes; translated labels | Existing bilingual web base; domain terminology and screen coverage need review |

## Data reuse strategy

1. Preserve the original schema/table/column keys as source lineage only. Use a migration staging area with source system, extract batch, legacy key, raw value, transformation version, validation result and reconciliation status.
2. Map in business meaning, not names. Candidate concepts include products, units, vendors, locations, receipts, issues, returns, transfers, purchase orders, claims, journal vouchers, cost centers and reports.
3. Keep legacy identifiers as external/source keys; never treat them as target UUIDs, GTIN/UDI/EDA registration, legal entity identifiers or approved valuation.
4. Quarantine ambiguous, sensitive, duplicate, invalid or unsupported values. No direct migration from `ITEM_AVR_COST`, patient/claim or accounting balances without approved policy and reconciliation.
5. Do not execute recovered SQL, import the 321 tables, or use a legacy production connection. Future migration requires owner-authorized source snapshot, data classification, mapping approval, rehearsal, reconciliation and cutover approval.

## UI implementation sequence (proposal)

- **UI-01 Shell/navigation:** module-aware sidebar and workspace, breadcrumb, EN/AR, access-denied/empty/error/loading states.
- **UI-02 Catalogue:** searchable list + product editor + units/conversions + pending review. Only approved Draft catalogue writes.
- **UI-03 Supplier register:** search/list/detail and evidence/review states; Draft/Pending only.
- **UI-04 Receiving:** document header/line entry and validation; save Draft only; no stock effects.
- **UI-05 Inventory:** balance/movement inquiry with clear Draft/Posted state; no posting action until approved.
- **UI-06 Transfers:** request and approval visibility; clearly show not dispatched/received/posted; no stock effects.
- **UI-07 Reports:** first inventory/catalogue/supplier/receipt/transfer reports from verified query data; report parity remains mapped individually.

Each slice must be implemented end-to-end (UI → BFF/API → persistence where authorized), tested in both languages, and runtime-verified. Do not build another static shell or expose buttons that imply an unavailable operation.

## Unknowns and gates

- Runtime window layout, event handlers, exact validation, menu order, reports, device behavior and transaction commit semantics are [U].
- PBD business logic was not decompiled; no old executable was launched.
- Product-family taxonomy, mandatory fields, procurement, receiving acceptance, batches/expiry, transfer custody/posting, dispensing, payer/discount, costing, GL, access/SoD and migration decisions remain pending in the approval register/open questions.
- This map is an implementation guide for discovery and UI reuse; it is not a business-rule approval.
