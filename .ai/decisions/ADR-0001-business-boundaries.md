# ADR-0001: Accounting boundaries for contracting and pharmacy

- Status: **Proposed — domain boundary established; legal-entity topology pending owner evidence**
- Date: 2026-11-07
- Decision owner: business owner; accountant approves accounting treatment
- Scope: business accounting separation and database isolation direction

## Decision established from repository requirements

The product has two distinct operating domains: specialist contracting and a pharmacy group. They must not share accounting books, journals, numbering sequences, financial permissions, or operational transaction ownership. This separation applies even if the same person or parent organization owns both operations.

The repository does **not** establish the registered legal names, number of incorporated entities, ownership chain, or which branches belong to which entity. Therefore, the two operating domains must not yet be labelled as exactly two legal entities.

## Entity-to-books rule

1. Every confirmed legal entity maintains its own statutory books, chart of accounts, fiscal periods, tax configuration, numbering controls, approvals, and financial statements.
2. Contracting transactions belong only to the legal entity that contracts with the customer and incurs/owns the costs.
3. Pharmacy transactions belong only to the legal entity that purchases/owns stock, operates the pharmacy activity, and records the sale/claim. The actual owner must be confirmed for each branch.
4. Multiple branches owned and operated by one legal entity may be tracked as branches/cost centres within that entity's books; they do not receive separate statutory ledgers solely because they are separate locations.
5. If branches are owned by different legal entities, each entity has separate books and balances. Do not consolidate by treating them as branches.
6. A holding/parent company is not assumed. If confirmed, it has its own books; group consolidation is a separate reporting layer and does not replace entity ledgers.
7. Intercompany charges, loans, stock transfers or services are recorded only where an actual legal/economic transaction exists, with documented counterparties, approvals, tax treatment and reconciliation.

## Data isolation direction

Use one PostgreSQL database and distinct credentials/migrations per confirmed legal entity as the preferred initial isolation model. Do not create one database per branch unless that branch is itself a separate legal entity or a documented security/regulatory requirement demands it. A separately permissioned platform/identity store may support authentication but must not own business ledgers.

Cross-entity reporting must use authorized, traceable reporting projections. Do not allow cross-database writes or direct mobile-client database access. Separate PostgreSQL clusters remain an option if risk, residency, scale or recovery requirements justify the added operations cost.

## Consequences

- Separate books are mandatory at the legal-entity level and between the two business domains.
- Branch reporting can be achieved without falsely multiplying legal entities.
- Group reporting and intercompany processing require explicit, reconcilable design.
- Database topology cannot be finalized until the entity register is evidenced and approved.

## Evidence and approval gate

Business owner must supply/confirm the legal-entity register: registered legal name, legal form, commercial-registration identifier, tax/VAT identifiers where applicable, ownership relationship, business activity, and branches/sites operated. Accountant and qualified Egyptian legal/tax advisers must verify the records and determine statutory accounting/tax treatment. Technical owner then maps approved entities to databases, credentials, backups and access policies.

**No legal-entity count, company identity, tax treatment, consolidation policy, schema, ledger posting logic or production calculation is approved by this ADR.**