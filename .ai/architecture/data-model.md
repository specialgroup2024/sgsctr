# Data model and persistence conventions

Status: modelling guidance, not an approved physical schema or accounting policy. Inspect EF entities and migrations before implementation.

## Ownership
- Use modular-monolith boundaries. Each module owns its entities, persistence configuration and invariants.
- Cross-module interaction uses application interfaces or documented events; no direct writes to another module's tables.
- One legal entity for Special Group is provisional pending documentary verification. Keep Pharmacies and Specialized Contracting operationally and financially distinguishable.
- Use explicit sector, branch/location, warehouse and project dimensions. Administrative connection does not imply access.
- Owner-identified pharmacy sites: Mokattam main warehouse, Student Hospital, Qasr El-Aini and Manial Hospital. Direct branch-to-branch movement is required capability, not proof of implementation.

## Persistence
- PostgreSQL is the system of record; use EF Core/Npgsql migrations.
- Use stable keys, foreign keys and constraints for confirmed invariants. Add unique constraints only for approved uniqueness rules.
- Store money as fixed-precision decimal with explicit currency, never floating point. Precision, rounding, costing pool, timing, tax and posting require accountant approval.
- Quantities require explicit units and approved precision. Timestamps use UTC; preserve source timezone and publication/effective dates where relevant.
- Use explicit state transitions; reject arbitrary client status changes.

## Pharmacy and regulated data
- Separate catalogue identity, supplier declarations, regulatory evidence, qualification, purchasing eligibility and stock transactions.
- Preserve source, capture time, document reference, reviewer, verification state and decision history.
- Distinguish product identifiers from pack, batch/lot, serial, expiry and traceability-event identifiers.
- Product-family fields, regulatory identifiers, storage and traceability requirements remain pending qualified review (Q38).
- Stock movements are append-only; corrections use controlled reversals/adjustments.
- Dispatch and receipt are separate transfer events; in-transit stock is unavailable at both endpoints.
- Weighted-average costing is a requirement; moving-average timing, cost pool, return basis, transfer value and rounding are not approved.

## Audit, privacy and migrations
- Audit actor, action, resource, timestamp, correlation and justified minimal before/after details.
- Apply data minimization, retention and legal-hold rules after qualified review.
- Never store secrets, patient records or raw production exports in source, fixtures or AI memory.
- Test clean schema creation, supported upgrades, EF parity, constraints, indexes and recovery.
- Never edit an applied migration; use a forward correction. Avoid destructive changes without staged compatibility and verified backup.

## Related
[Accounting rules](../domain/accounting-rules.md) · [Business boundaries](../domain/business-boundaries.md) · [Approval register](../governance/approval-register.md)
