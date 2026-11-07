# Proposed system context — Phase 0

Status: proposal for discovery; legal identity and accounting design require owner/professional approval.

## Context
Owner reports one company, “Special Group”, with Pharmacies Sector and Specialized Contracting Sector. Plan provisionally for one legal entity with two separate business domains. Verify official legal identity and confirm both sectors are operated by the same legal person before production configuration.

Pharmacy site topology provided by owner: Mokattam main warehouse distributes to Student Hospital, Qasr El-Aini Hospital and Manial Hospital branches. These locations are administratively connected but separately identifiable for stock, accounting dimensions, permissions and reporting. Confirm whether this is the complete site list and verify legal operator, licence holder and stock custodian.

## Proposed deployment shape
- ASP.NET Core API: modular monolith, one deployable backend initially.
- PostgreSQL: one database provisionally for LE-01, with strict sector/module data ownership and authorization. Reassess if additional legal entities are evidenced.
- React Native: mobile client consuming versioned APIs; never connect clients directly to PostgreSQL.
- Optional web administration client: decision pending; share API and authorization policies.
- Background processing: introduce only for confirmed asynchronous jobs; use durable idempotent work patterns.
- Observability: structured logs, metrics, traces and security/audit events with sensitive-data redaction.

## Backend module boundaries
- Identity and Access: users, authentication integration, role and permission evaluation, sector-scoped access.
- Shared Platform: configuration, reference data only when truly common, audit envelope, outbox and notifications.
- Contracting: projects, estimates, contracts, variations, procurement, subcontractors, costs, billing and project reporting.
- Pharmacy: catalog, suppliers, purchasing, receiving, lots/expiry, stock movements, dispensing records and returns. Model Mokattam warehouse and each branch as distinct inventory locations.
- Pharmacy Claims: payer agreements, claim lifecycle, remittances, patient balances and collections.
- Finance: one company statutory accounting framework provisionally, with sector subledgers/journals or posting dimensions and reconciled company-level reporting. Include branch/warehouse dimensions and separate location reports; exact ledger ownership and posting authority require accountant approval.

Modules own their data and expose use-case interfaces. No direct cross-module table writes. Shared code must not contain contracting or pharmacy policy. Every transaction carries company/legal-entity and sector ownership, with branch/project/warehouse dimensions where appropriate.

## Data and security principles
- Enforce server-side authorization and least-privilege database roles; sector users see only authorized sector records.
- Financial and inventory invariants use transactions and constraints.
- Use fixed-precision decimal types and explicit currency; precision and rounding require accountant approval.
- Keep patient/health data out of general logs, agent memory and test fixtures.
- Version migrations; test backup and restore; make integrations idempotent.
- Cross-sector reporting is permissioned and traceable; intercompany activity applies only to distinct legal entities and genuine documented transactions.
- Warehouse-to-branch stock transfers must be traceable, approved and auditable; track dispatch, in-transit quantity, receipt and discrepancy resolution. Do not model internal transfers as sales.

## Initial stack direction
ASP.NET Core, PostgreSQL and React Native are stated project choices. Exact framework, runtime, PostgreSQL and mobile toolchain versions remain to be verified and pinned before dependency work. EF Core/Npgsql is a candidate persistence stack, subject to a technical spike.

## Not decided
Verified legal identity, any parent/subsidiary structure, branch ownership/licensing, complete site list, accountant-approved sector/branch accounting model, warehouse transfer workflow, web client, identity provider, hosting region, offline behavior, integrations, ledger posting rules and deployment topology. See memory/open-questions.md and proposed ADR-0001.
