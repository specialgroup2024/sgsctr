# ADR-0001: Isolate contracting and pharmacy accounting data

- Status: **Proposed — not approved**
- Date: 2026-11-07
- Decision owner: business owner with accountant and technical owner
- Scope: logical and physical data separation for contracting and pharmacy

## Context
The product serves a specialist contracting operation and a pharmacy group. The repository requires separate accounting systems and reports. Legal-entity count and ownership are not yet confirmed.

## Options considered
1. **Separate PostgreSQL databases per legal entity (preferred proposal).** One PostgreSQL cluster may host multiple databases, each with its own credentials, migrations, backup/restore boundary and ledger. Stronger isolation than schemas; straightforward operational start. Cross-database joins and atomic transactions are unavailable, so consolidated reporting and intercompany flows need explicit integration and reconciliation.
2. **Separate schemas in one database.** Easier cross-schema queries and single-database transactions; lower operational overhead. Weaker isolation because shared database roles, connection configuration and accidental unqualified queries can cross boundaries. Row-level security and disciplined grants help but do not equal separate database boundaries.
3. **Separate PostgreSQL clusters/instances.** Strongest infrastructure, failure and credential isolation. Higher hosting, monitoring, backup, upgrade and operational cost; may be excessive before scale and recovery requirements are known.

## Proposed direction
Use a separate PostgreSQL database for each confirmed legal entity that requires its own books. At minimum, contracting and pharmacy must not share ledgers. If multiple pharmacy legal entities exist, assess a separate database per entity rather than assuming one pharmacy database. Shared identity/platform data may live in a separately permissioned platform database; it must not become a place for business transactions.

Use distinct database roles and credentials, schema migrations, backup/restore tests and access policies. Do not grant the mobile client database access. Cross-entity reports use an authorized reporting projection, not direct ledger merging. Intercompany transactions require paired, traceable entries and reconciliation.

## Consequences and tradeoffs
- Positive: clear database and credential boundaries, independent restore and retention, reduced accidental cross-business access.
- Negative: cross-database reporting, reference-data synchronization and atomic multi-entity workflows become explicit integration concerns.
- Risk: database separation alone does not establish legal-entity correctness, accounting compliance or complete access isolation.

## Approval and validation required
Business owner confirms entity map and reporting needs. Accountant approves books, intercompany treatment and opening-balance approach. Security/technical owner validates credentials, access, backups and recovery. Revisit if entity topology, scale, residency or recovery targets differ from assumptions.

No schema, ledger, posting logic or production calculation is authorized by this proposal.
