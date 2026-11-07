# Current state

Last reviewed: 2026-11-07.
Status: Phase 0 discovery; no business features implemented.

## Owner-provided structure

The owner identifies “Special Group” with Pharmacies Sector and Specialized Contracting Sector. Record provisionally as LE-01 with two sectors. Exact registered name/form/identifiers and whether both sectors are operated by the same legal person remain to be verified.

Pharmacy locations confirmed by owner:
- Mokattam main warehouse.
- Student Hospital branch.
- Qasr El-Aini Hospital branch.
- Manial Hospital branch.

The owner explicitly confirms that the three branches may transfer medicines and supplies directly between one another; a transfer does not have to pass through Mokattam. Support direct branch-to-branch and warehouse-mediated transfers. The locations are administratively connected but separately accountable for inventory and accounting reports.

## Accounting and inventory boundary

- One legal entity has one statutory company accounting framework, subject to official verification.
- Pharmacies and Specialized Contracting retain separate workflows, permissions, budgets, sector subledgers/journals or posting dimensions and management reports.
- Warehouse and each branch require distinct location-level stock balances, movement histories and reports.
- Transfers between any authorized pharmacy locations require source/destination traceability, dispatch, in-transit tracking, receipt confirmation, discrepancy handling and approvals.
- Location transfers within the same legal entity are internal stock movements, not sales or intercompany transactions.
- Transfer valuation, financial posting and detailed workflow policies require accountant and pharmacy-operations approval.
- Do not create duplicate statutory books, separate company databases or intercompany entries solely because of sectors or pharmacy locations.
- Provisional database direction: one PostgreSQL database for LE-01 with strict sector/module access controls.

## Evidence status

Owner statements are recorded but not independently verified. Exact Arabic/English registered legal name, legal form, commercial-registration and tax/VAT references, registered activities, parent/subsidiary relationship, site ownership, operator, licences and stock custody remain outstanding. The full site list is not yet confirmed.

## Repository and delivery

- Phase 0 discovery only; no application features, database migrations or mobile app implementation identified in inspected default branch.
- ADR-0001 and legal-entity register are proposals/working records, not legal or accounting opinions.
- Pharmacy stock-transfer workflow and acceptance criteria have been drafted under .ai/domain and .ai/quality; both await operational/accounting approval.
- No production posting, inventory valuation, tax calculation, claim settlement or patient-balance logic is approved.

## Next milestone

Obtain pharmacy-operations approval of the transfer lifecycle, roles, custody, approval limits, exceptions and lot/expiry controls; obtain accountant approval of weighted-average costing impact, transfer valuation/posting and reconciliation examples. Then translate approved criteria into a non-posting domain/API design and implementation plan. In parallel, verify company identity, legal site/operator/licence and full branch/site schedule before production configuration.
