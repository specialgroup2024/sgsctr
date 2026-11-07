# Proposed system context — Phase 0

Status: proposal for discovery; not an implementation baseline or approved architecture.

## Context
One product supports specialist contracting and a pharmacy group. Keep their business rules, financial books, reports, permissions and records separate. Clinical decisions remain with authorized pharmacy professionals.

## Proposed deployment shape
- ASP.NET Core API: modular monolith, one deployable backend initially.
- PostgreSQL: one managed cluster may host isolated databases per legal entity/business boundary.
- React Native: mobile client consuming versioned APIs; do not connect clients directly to PostgreSQL.
- Optional web administration client: decision pending; share API and authorization policies.
- Background processing: introduce only for confirmed asynchronous jobs; use durable idempotent work patterns.
- Observability: structured logs, metrics, traces and security/audit events with sensitive-data redaction.

## Backend module boundaries
- Identity and Access: users, authentication integration, role and permission evaluation.
- Shared Platform: configuration, reference data only when truly common, audit envelope, outbox and notifications.
- Contracting: projects, estimates, contracts, variations, procurement, subcontractors, costs, billing and project reporting.
- Pharmacy: catalog, suppliers, purchasing, receiving, lots/expiry, stock movements, dispensing records and returns.
- Pharmacy Claims: payer agreements, claim lifecycle, remittances, patient balances and collections.
- Finance boundary: separate ledgers/journals per legal entity; module ownership and posting authority must be agreed before design is finalized.

Modules own their data and expose use-case interfaces. No direct cross-module table writes. Shared code must not contain contracting or pharmacy policy.

## Data and security principles
- Use server-side authorization and least-privilege database roles.
- Enforce financial and inventory invariants with transactions and constraints.
- Use fixed-precision decimal types and explicit currency; final precision and rounding require accountant approval.
- Keep patient/health data out of general logs, agent memory and test fixtures.
- Version migrations; test backup and restore; make integrations idempotent.
- Cross-entity reporting is not a default. Any intercompany activity is explicit, authorized and auditable.

## Initial stack direction
ASP.NET Core, PostgreSQL and React Native are stated project choices. Exact framework, runtime, PostgreSQL and mobile toolchain versions remain to be verified and pinned before dependency work. EF Core/Npgsql is a candidate persistence stack, subject to a technical spike.

## Not decided
Legal-entity topology, database-per-entity mapping, web client, identity provider, hosting region, offline behavior, integration list, ledger ownership, and deployment topology. See memory/open-questions.md and proposed ADR-0001.
