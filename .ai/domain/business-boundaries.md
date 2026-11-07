# Business and accounting boundaries

## Operating domains

### Contracting
Own its customer/project contracts, estimates, variations, procurement, subcontractors, commitments, project costs, progress billing, retention, close-out and operational reports.

### Pharmacy
Own its branches, products, suppliers, purchasing, stock, dispensing, payer agreements, claims, patient balances, collections and operational reports.

These are two distinct business domains. Neither is presumed to equal exactly one incorporated legal entity.

## Legal-entity accounting rule

- Every verified legal entity has its own books, journals, chart of accounts, fiscal periods, tax configuration, numbering, approvals and financial statements.
- Contracting and pharmacy must not share ledgers, even where ownership or platform infrastructure is shared.
- Attribute each contract, purchase, stock item, sale, claim, receipt, liability and asset to its actual legal owner/counterparty.
- A branch is a location/cost centre within its owning entity unless evidence establishes it as a separate legal entity.
- A pharmacy group may comprise one or several legal entities; confirm ownership branch by branch before setup.
- Do not assume a parent/holding company exists. If one is confirmed, it has its own books and any group consolidation is a separate reporting layer.

## Intercompany and shared services

Record an intercompany transaction only when there is an actual documented transaction between confirmed entities. Capture both counterparties, source document, approval, amount/currency, tax/accounting treatment and matching/reconciliation status. Do not create balancing entries merely to make reports agree.

Identity, audit infrastructure, notifications and deployment tooling may be shared with least-privilege controls. Shared services must not merge business data or books.

## Database boundary

Preferred initial direction: one PostgreSQL database with distinct credentials and migrations for each confirmed legal entity. Do not create a database per branch unless it is a separate legal entity or a documented control requires it. A separate platform identity store may be used but must not contain business ledger transactions.

See [ADR-0001](../decisions/ADR-0001-business-boundaries.md) and [legal-entity-register.md](legal-entity-register.md). Entity topology and database provisioning remain blocked pending documentary confirmation and owner/accountant approval.
