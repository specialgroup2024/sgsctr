# Business and accounting boundaries

## Owner-provided operating structure

The owner identifies the registered company as **“Special Group”**, comprising:
- Pharmacies Sector
- Specialized Contracting Sector

For planning, record one provisional legal entity: LE-01 — Special Group. The exact registered legal name, legal form, official identifiers and site ownership still require documentary verification. Do not treat the two sectors as two companies.

## Sector responsibilities

### Specialized Contracting Sector
Own its customer/project contracts, estimates, variations, procurement, subcontractors, commitments, project costs, progress billing, retention, close-out and sector reports.

### Pharmacies Sector
Own its branches, central warehouse, products, suppliers, purchasing, stock, dispensing, payer agreements, claims, patient balances, collections and sector reports.

Owner-confirmed pharmacy logistics structure:
- Main pharmacy warehouse: Mokattam.
- Distribution from the Mokattam warehouse to the Student Hospital, Qasr El-Aini Hospital and Manial Hospital branches.
- The warehouse and branches are administratively connected within the Pharmacies Sector.
- They remain separately identifiable for accounting and inventory control. Record warehouse and branch-level stock balances, receipts, issues, transfers, consumption, adjustments and reporting independently.

Each sector has separate workflows, operational records, budgets, cost/profitability reports, roles and approval controls. Pharmacy inventory costing remains weighted-average subject to accountant-approved detailed rules.

## Statutory and management accounting

If both sectors belong to the same registered legal person, maintain one statutory company accounting framework and statutory set of books. Within it, preserve separate sector subledgers/journals or posting dimensions and sector-specific management reports. Transactions must identify the legal entity and sector; branch, project and warehouse dimensions apply as relevant. Sector reports must reconcile to company-level statutory balances.

“Separate for accounting purposes but administratively connected” means separate operational/accounting dimensions and reconciled branch/warehouse reporting, not separate legal entities or duplicate statutory books. Stock transfers from Mokattam to a branch must be traceable as internal location movements; whether they create any accounting value entries depends on accountant-approved policy.

Do not create separate statutory company books or intercompany transactions between sectors of the same legal entity. If official evidence shows a sector is separately incorporated, model it as a separate legal entity with its own statutory books and approved isolation.

## Intercompany and shared services

Record intercompany activity only between distinct verified legal entities and where a real documented transaction exists. Capture both counterparties, source document, approval, amount/currency, tax/accounting treatment and matching/reconciliation status.

Identity, audit infrastructure, notifications and deployment tooling may be shared with least-privilege controls. Sector data remains permissioned and traceable.

## Database boundary

Provisional direction: one PostgreSQL database for the one owner-reported company, with strict sector/module boundaries, separate sector permissions and audit trails. Do not create a database per sector, warehouse or branch on current evidence. Reassess if additional legal entities are documented.

See [ADR-0001](../decisions/ADR-0001-business-boundaries.md), [legal-entity-register.md](legal-entity-register.md) and [accounting-rules.md](accounting-rules.md).
