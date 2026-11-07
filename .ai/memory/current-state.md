# Current state

Last reviewed: 2026-11-07.
Status: Phase 0 discovery; no business features implemented.

## Owner-provided structure
The owner identifies the registered company as “Special Group”, with Pharmacies Sector and Specialized Contracting Sector. Record provisionally as LE-01 with two sectors. Exact registered name/form/identifiers and whether both sectors are operated by the same legal person remain to be verified from official records.

## Accounting boundary
- One legal entity has one statutory company accounting framework, subject to verification.
- The Pharmacies and Specialized Contracting sectors retain separate operational workflows, permissions, budgets, sector subledgers/journals or posting dimensions, and management reports.
- Sector totals must reconcile to company-level statutory balances.
- Do not create two statutory entities, separate company databases, or intercompany entries solely because there are two sectors.
- If official evidence identifies a separate incorporated entity, give it its own statutory books and reassess database isolation.
- Provisional database direction: one PostgreSQL database for LE-01 with strict sector/module access controls; not one database per sector or branch.

## Evidence status
Owner statement is recorded but not independently verified. Exact Arabic/English registered legal name, legal form, commercial-registration and tax/VAT references, registered activities, parent/subsidiary relationship and branch/site ownership remain outstanding. mam/ai-chat guidance is not a substitute for official legal records or accounting approval.

## Repository and delivery
- Phase 0 discovery only; no application source, database migrations or mobile app implementation identified in inspected default branch.
- ADR-0001 and the legal-entity register are proposals/working records, not legal or accounting opinions.
- No production posting, inventory valuation, tax calculation, claim settlement or patient-balance logic is approved.

## Next milestone
Verify the company record and full branch/site schedule; have the business owner, accountant and qualified Egyptian legal/tax adviser approve the company/sector accounting map. Then finalize database provisioning and entity/sector authorization design.
