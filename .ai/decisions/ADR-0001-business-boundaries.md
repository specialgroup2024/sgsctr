# ADR-0001: Accounting boundaries for contracting and pharmacy

- Status: **Proposed — operating model recorded from owner statements; accountant/legal verification pending**
- Date: 2026-11-07
- Decision owner: business owner; accountant approves accounting treatment
- Scope: legal-entity mapping, sector accounting boundaries and database direction

## Owner-provided entity information

The business owner identifies “Special Group” with two sectors: Pharmacies Sector and Specialized Contracting Sector. This is an owner statement, not independent verification of the exact registered legal name or legal form. Official Arabic/English name, legal form, registration/tax identifiers and site ownership require documentary verification.

For discovery, model one provisional legal entity (LE-01 — Special Group) with two business sectors. Do not create two legal entities solely because the sectors differ operationally.

## Accounting boundary

If official records confirm both sectors belong to the same registered legal person:
- Maintain one statutory company accounting framework, chart of accounts, fiscal year, tax profile and statutory books.
- Maintain separate sector operational accounting and management reporting using controlled subledgers/modules, journals or posting dimensions, branch/project/cost-centre dimensions and sector permissions.
- Tag each transaction with legal entity and sector, plus branch, project, warehouse or other relevant dimensions.
- Reconcile sector detail to company-level statutory control accounts and reporting.
- Do not create duplicate statutory books or intercompany balances between sectors of the same legal entity.
- Accountant approves chart, dimensions, allocations, posting and reconciliation rules.

## Pharmacy locations and stock transfers

Owner-confirmed locations:
- Mokattam — main pharmacy warehouse.
- Student Hospital branch.
- Qasr El-Aini Hospital branch.
- Manial Hospital branch.

The owner requires locations to be **separate for accounting purposes but administratively connected**. Keep each location's stock balances, receipts, issues, transfers, discrepancies and reports separately identifiable while connecting them through common administration and controlled workflows.

The owner has explicitly confirmed that **the three branches may transfer medicines and supplies directly between one another**; transfers do not have to pass through Mokattam. The inventory model and workflow must therefore support approved transfers between any authorized pharmacy locations, including:
- Mokattam warehouse → branch;
- branch → Mokattam warehouse;
- branch → branch directly.

A direct branch-to-branch transfer is an internal location movement when both locations belong to the same legal entity. It is not a sale or intercompany transaction. It must have a source and destination, item/quantity, lot/batch and expiry where applicable, transfer reference, dispatch and receipt confirmation, in-transit tracking, discrepancy/shortage handling, timestamps, initiating users and required approvals. Maintain location-level stock ledgers and a traceable movement history; do not silently change a location's stock balance.

Support configurable permissions and approval limits for requesting, authorizing, dispatching and receiving transfers. Separate duties where policy requires; do not assume the same person may approve and receive their own transfer. Exact workflow, emergency exceptions, valuation and financial posting treatment require pharmacy operations and accountant approval.

This does not establish that the listed sites are exhaustive or verify their legal owner, operator, licence holder or stock custodian. If evidence identifies a separately incorporated entity, create a distinct legal-entity record and its own statutory books; reassess database isolation.

## Database direction

Provisional planning baseline: one PostgreSQL database for LE-01, with explicit sector/module ownership, server-side authorization and controlled data access. Do not create one database per sector, warehouse or branch on current evidence. Reassess if additional legal entities are verified.

## Consequences and controls

- Legal entity, sector and inventory location are distinct domain dimensions.
- Sector separation must not duplicate statutory books for one company.
- Pharmacy locations are administratively connected but separately accountable.
- Inventory transfers must support direct branch-to-branch movement and warehouse-mediated movement, with full auditability and in-transit control.
- Company-level statutory balances reconcile to sector and location detail as applicable.
- Intercompany accounting requires distinct verified legal entities and a genuine documented transaction.

## Required approvals

Business owner confirms entity and operating facts. Accountant approves statutory-versus-management accounting, chart/dimensions, allocations and transfer valuation/posting. Pharmacy operations approves transfer workflow, roles, exceptions and stock controls. Qualified Egyptian legal/tax adviser verifies legal identity, activities, licensing and tax implications.

**This ADR does not approve tax treatment, chart of accounts, financial calculations, ledger posting logic or production database provisioning.**
