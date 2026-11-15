---
name: postgres-data
description: Design or review PostgreSQL schema, EF Core/Npgsql persistence, migrations, constraints, indexes, transactions and recovery.
---

# Workflow
1. Inspect PostgreSQL image, EF Core/Npgsql versions, DbContexts, entity configurations, migrations and snapshots.
2. Identify data ownership, sensitivity, lifecycle, consistency invariants and affected modules.
3. Prefer explicit constraints, foreign keys, uniqueness and transaction boundaries over application-only assumptions.
4. Review migration ordering, idempotency, existing data, duplicate objects and rollback/recovery.
5. Use fixed-precision numeric types for money with explicit currency; confirm precision and rounding with an accountant.
6. Test fresh database creation and upgrade from representative prior schema/data; verify success and failure recovery.
7. Run EF validation and integration tests; record commands and outcomes.

# Guardrails
- Never drop or rewrite data to silence a migration failure.
- Do not create financial posting, stock valuation or operational tables without approval.
- Do not assume one database means unrestricted cross-module access.
- Preserve audit history and sensitive-data minimization.

# References
See architecture/system-context.md, architecture/data-model.md, governance/approval-and-execution.md and delivery/definition-of-done.md.
