# Business boundaries

## Contracting business

Own its customers, projects, estimates, contracts, variations,
subcontractors, purchasing, project costs, billing, and reports.

## Pharmacy business

Own its branches, products, suppliers, purchasing, stock, dispensing,
payer agreements, claims, patient balances, collections, and reports.

## Accounting separation

Maintain separate books, journals, account mappings, numbering,
permissions, and financial reports for each legal entity.

The initial design may use one PostgreSQL installation, but keep the
business databases or schemas isolated. Record the approved choice in
ADR-0001. Do not create consolidated financial entries unless explicitly
approved; any intercompany transaction must be traceable.

## Shared services

Identity, audit infrastructure, notifications, and deployment tooling may
be shared only where access controls prevent cross-business data exposure.
