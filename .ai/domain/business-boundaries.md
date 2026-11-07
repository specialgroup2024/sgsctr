# Business and accounting boundaries

## Owner-provided operating structure

The owner identifies “Special Group” as comprising:
- Pharmacies Sector
- Specialized Contracting Sector

For planning, record one provisional legal entity: LE-01 — Special Group. Exact registered name, legal form, identifiers and site ownership require documentary verification. Do not treat the sectors as separate companies.

## Sector responsibilities

### Specialized Contracting Sector
Own customer/project contracts, estimates, variations, procurement, subcontractors, commitments, project costs, progress billing, retention, close-out and sector reports.

### Pharmacies Sector
Own pharmacy locations, central warehouse, products, suppliers, purchasing, stock, dispensing, payer agreements, claims, patient balances, collections and sector reports.

Owner-confirmed pharmacy locations:
- Mokattam main warehouse.
- Student Hospital branch.
- Qasr El-Aini Hospital branch.
- Manial Hospital branch.

The owner confirms the three branches may transfer medicines and supplies directly between one another; transfers need not pass through Mokattam. Support both warehouse-to-branch and branch-to-branch transfers. All locations are administratively connected, but remain separately identifiable for stock, accounting dimensions, permissions and reports.

Each location needs its own stock balances and movement history. Transfers require source/destination locations, item quantities, batch/lot and expiry data where applicable, dispatch, receipt confirmation, in-transit status, discrepancy handling, approvals and audit history. These are internal location movements where locations belong to the same legal entity, not sales or intercompany transactions.

## Statutory and management accounting

If both sectors belong to the same registered legal person, maintain one statutory company accounting framework and statutory books. Preserve separate sector subledgers/journals or posting dimensions and sector-specific management reports. Transactions identify legal entity and sector; branch, project and warehouse dimensions apply as relevant. Reconcile sector/location detail to company-level statutory balances.

“Separate for accounting purposes but administratively connected” means separately accountable operational locations and accounting dimensions, not separate legal entities or duplicate statutory books. Accountant approval is required for transfer valuation and financial posting treatment.

Do not create intercompany transactions between sectors or locations of the same legal entity. If official evidence shows a separately incorporated entity, model it separately with its own statutory books and approved isolation.

## Intercompany and shared services

Record intercompany activity only between distinct verified legal entities and where a real documented transaction exists. Capture both counterparties, source document, approval, amount/currency, tax/accounting treatment and matching/reconciliation status.

Identity, audit infrastructure, notifications and deployment tooling may be shared with least-privilege controls. Sector data remains permissioned and traceable.

## Database boundary

Provisional direction: one PostgreSQL database for the one owner-reported company, with strict sector/module boundaries, separate sector permissions and audit trails. Do not create a database per sector, warehouse or branch on current evidence. Reassess if additional legal entities are documented.

See [ADR-0001](../decisions/ADR-0001-business-boundaries.md), [legal-entity-register.md](legal-entity-register.md) and [accounting-rules.md](accounting-rules.md).
