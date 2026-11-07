# ADR-0001: Accounting boundaries for contracting and pharmacy

- Status: **Proposed — single-entity operating model recorded from owner statement; accountant/legal verification pending**
- Date: 2026-11-07
- Decision owner: business owner; accountant approves accounting treatment
- Scope: legal-entity mapping, sector accounting boundaries and database direction

## Owner-provided entity information

The business owner identified the registered company as **“Special Group”**, with two sectors:
1. Pharmacies Sector
2. Specialized Contracting Sector

This is an owner-provided statement, not independent verification of the exact registered legal name or legal form. The official Arabic/English registered name, legal form, commercial-registration and tax identifiers, and branch ownership schedule remain to be checked against company records.

For discovery and architecture planning, model one provisional legal entity (**LE-01 — Special Group**) operating two separate business sectors. Do not create two legal entities solely because the sectors have different operations.

## Accounting boundary decision

If the official records confirm that both sectors are operated by the same registered legal person:

- Maintain one statutory company accounting framework: one company-level chart of accounts, fiscal year, tax profile, statutory financial statements and legally required books.
- Maintain separate sector-level operational accounting and management reporting for Pharmacies and Specialized Contracting. Use controlled sector subledgers/modules, journals or posting dimensions, branch/project/cost-centre dimensions and sector-specific permissions/approvals.
- Every financial transaction must carry its owning legal entity and appropriate sector; add branch, project, warehouse, payer or other dimensions where relevant.
- Provide company-level consolidated statutory reporting from the same legal-entity books, with sector drill-down and reconciliation.
- Do not create separate statutory company books, separate legal-entity databases or intercompany balances between the two sectors unless evidence establishes separate legal persons or a genuine transaction between distinct entities.
- Shared company-level balances, taxes, cash/bank controls and statutory postings must reconcile to sector detail. The accountant must approve the chart of accounts, sector dimensions, allocation and reconciliation rules.

If later evidence identifies a separately incorporated pharmacy or contracting company, create a distinct legal-entity record and separate statutory books/database boundary for that entity. Do not silently reclassify it as a sector.

## Database direction

Provisional planning baseline: one PostgreSQL database for LE-01, with explicit sector/module ownership, server-side authorization and controlled data access. Do not create one database per sector or branch on the current evidence. Separate identity/audit infrastructure may be shared. If additional legal entities are verified, reassess one database per legal entity versus stronger cluster isolation based on security, regulatory, recovery and operational needs.

Cross-sector reporting is within the company boundary but must remain traceable and permission-controlled. Sector users should see only authorized sector data; company-wide finance roles may have approved cross-sector access. Mobile clients must use APIs, never connect directly to PostgreSQL.

## Consequences and controls

- Legal entity and operating sector are separate dimensions in the domain model.
- Sector separation must not cause duplicate statutory books for one company.
- Sector reports must reconcile to company-level statutory balances.
- Any intercompany accounting requires distinct verified legal entities and a real documented transaction.
- Database provisioning is not authorized until the official company record and accountant-approved accounting model are reviewed.

## Required approvals

Business owner confirms entity and sector facts. Accountant approves statutory-versus-management accounting design, sector chart/dimensions, allocation, control accounts and reconciliation. Qualified Egyptian legal/tax adviser verifies legal identity, registered activities, licensing and tax implications. Technical owner implements only the approved mapping.

**This ADR does not approve tax treatment, chart of accounts, financial calculations, ledger posting logic, or production database provisioning.**