# Current state

Last reviewed: 2026-11-07.
Status: Phase 0 discovery; no business features implemented.

## Owner-provided structure
The owner identifies the registered company as “Special Group”, with Pharmacies Sector and Specialized Contracting Sector. Record provisionally as LE-01 with two sectors. Exact registered name/form/identifiers and whether both sectors are operated by the same legal person remain to be verified from official records.

Pharmacy logistics confirmed by owner:
- Main pharmacy warehouse: Mokattam.
- Distribution destinations: Student Hospital branch, Qasr El-Aini Hospital branch and Manial Hospital branch.
- These sites are administratively connected but separately identifiable for accounting and inventory control.
- The warehouse-to-branch relationship is an internal distribution/stock-movement process provisionally within the Pharmacies Sector; site legal ownership, licences and stock custody remain to be verified.

## Accounting boundary
- One legal entity has one statutory company accounting framework, subject to verification.
- The Pharmacies and Specialized Contracting sectors retain separate operational workflows, permissions, budgets, sector subledgers/journals or posting dimensions, and management reports.
- Pharmacy warehouse and each branch require distinct location-level stock balances, movements and accounting/management reports, with reconciliation to sector/company balances.
- Sector totals must reconcile to company-level statutory balances.
- Do not create two statutory entities, separate company databases, or intercompany entries solely because there are two sectors or multiple pharmacy locations.
- If official evidence identifies a separate incorporated entity, give it its own statutory books and reassess database isolation.
- Provisional database direction: one PostgreSQL database for LE-01 with strict sector/module access controls; not one database per sector, warehouse or branch.

## Evidence status
Owner statements are recorded but not independently verified. Exact Arabic/English registered legal name, legal form, commercial-registration and tax/VAT references, registered activities, parent/subsidiary relationship, branch/site ownership, operator, licences and stock custody remain outstanding. mam/ai-chat guidance is not a substitute for official legal records or accounting approval.

## Repository and delivery
- Phase 0 discovery only; no application source, database migrations or mobile app implementation identified in inspected default branch.
- ADR-0001 and the legal-entity register are proposals/working records, not legal or accounting opinions.
- No production posting, inventory valuation, tax calculation, claim settlement or patient-balance logic is approved.

## Next milestone
Verify the company record and full branch/site schedule; confirm site legal owner/operator/licence and stock custody; have the business owner, accountant and qualified Egyptian legal/tax adviser approve the company/sector/branch accounting map. Then finalize database provisioning and entity/sector authorization design.
