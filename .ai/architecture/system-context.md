# Proposed system context — foundation and discovery

Status: architecture proposal. Legal identity, business permissions and regulated operating decisions require owner/professional approval.

## Context

Owner reports “Special Group” with Pharmacies Sector and Specialized Contracting Sector. Plan provisionally for one legal entity with two business domains. Verify official identity and that both sectors are operated by the same legal person before production configuration.

Pharmacy topology: Mokattam main warehouse, Student Hospital branch, Qasr El-Aini Hospital branch and Manial Hospital branch. The owner confirms branches may transfer medicines and supplies directly between one another; transfers need not route through Mokattam. All locations are administratively connected but separately accountable for stock, accounting dimensions and reports. Verify complete site list, legal operator, licence holder and stock custodian.

## Repository-verified technology baseline

- ASP.NET Core API targets .NET 10 (`net10.0`).
- Repository SDK pin: .NET SDK `10.0.115` (lowered from `10.0.403` by owner commit `e685aa3` on 2026-11-16; `global.json` is authoritative).
- EF Core provider: Npgsql Entity Framework Core PostgreSQL `10.0.3`; the API currently registers `AppDbContext`.
- PostgreSQL Compose image: `postgres:18-alpine`.
- Web foundation: Next.js `15.5.7`, React `19.1.1`, TypeScript `5.9.3`.
- Mobile direction: React Native; mobile project/toolchain is not yet present in the inspected repository.
- These are repository configuration facts, not a production support, hosting or upgrade approval.

## Proposed deployment shape

- ASP.NET Core API: modular monolith, one deployable backend initially.
- PostgreSQL: one database provisionally for LE-01, with strict sector/module data ownership and authorization. Reassess if additional legal entities are evidenced.
- React Native: mobile client consuming versioned APIs; never connect clients directly to PostgreSQL.
- Next.js: current web foundation; browser should call a server-side BFF/API route rather than connect to PostgreSQL.
- Background processing: the Pharmacy module has an EDA regulatory-ingestion hosted worker with PostgreSQL-backed source/document/alert/scan history. It is a bounded best-effort MVP; see [EDA ingestion architecture](eda-regulatory-ingestion.md). Use durable idempotent work patterns for future jobs.
- Observability: structured logs, metrics, traces and security/audit events with sensitive-data redaction.

## Backend module boundaries

- Identity and Access: users, authentication integration, role and permission evaluation, sector/location-scoped access.
- Shared Platform: configuration, truly common reference data, audit envelope, outbox and notifications.
- Contracting: projects, estimates, contracts, variations, procurement, subcontractors, costs, billing and project reporting.
- Pharmacy: catalog, suppliers, purchasing, receiving, lots/expiry, stock movements, dispensing and returns. Model Mokattam and each branch as distinct inventory locations. Support direct branch-to-branch transfers as well as warehouse-to-branch and branch-to-warehouse transfers.
- Pharmacy Claims: payer agreements, claim lifecycle, remittances, patient balances and collections.
- Finance: one company statutory accounting framework provisionally, with sector subledgers/journals or posting dimensions and reconciled company-level reporting. Include branch/warehouse dimensions and location-level reports; posting authority requires accountant approval.

Modules own their data and expose use-case interfaces. No direct cross-module table writes. Every transaction carries company/legal-entity and sector ownership, with branch/project/warehouse dimensions where relevant.

## Pharmacy transfer invariants

- Transfers identify source and destination locations; both must be authorized pharmacy locations.
- Branch-to-branch transfers are first-class movements, not sales.
- Track requested, approved, picked, dispatched, in-transit, partially received, received, discrepancy, cancelled and returned states as approved by operations.
- Dispatch and receipt are separate events. In-transit stock must not be simultaneously available at source and destination.
- Record item, unit, quantity, batch/lot and expiry where applicable, document reference, responsible users, timestamps and approvals.
- Enforce role permissions, separation of duties, idempotent processing and immutable audit history. Corrections use controlled reversal/adjustment records.
- Detailed workflow, negative-stock exceptions, emergency process, transfer valuation and financial postings remain subject to pharmacy-operations and accountant approval.
- Workflow: [proposed process](../domain/pharmacy-stock-transfer-workflow.md); [acceptance criteria](../quality/pharmacy-stock-transfer-acceptance.md).
- Technical artifacts: [domain model](pharmacy-transfer-domain-model.md), [API contract](pharmacy-transfer-api-contract.md), [persistence design](pharmacy-transfer-persistence-design.md), [implementation plan](pharmacy-transfer-implementation-plan.md).

## Data and security principles

- Enforce server-side authorization and least-privilege database roles; scope users to authorized sectors and locations.
- Financial and inventory invariants use transactions and constraints.
- Use fixed-precision decimals and explicit currency; precision and rounding require accountant approval.
- Keep patient/health data out of general logs, agent memory and test fixtures.
- Version migrations; test backup/restore; make integrations idempotent.
- Cross-sector reporting is permissioned and traceable; intercompany activity applies only to distinct legal entities and genuine documented transactions.
- Internal location transfers are traceable and auditable; do not model them as sales.
- Identity and access approach: [ADR-0002](ADR-0002-identity-and-access.md), proposed pending owner decisions.

## Not decided

Verified legal identity, parent/subsidiary structure, branch ownership/licensing, complete site list, accountant-approved accounting model, transfer workflow roles/approval limits and exception policy, transfer valuation/posting, identity provider, hosting region, offline behavior, integrations, ledger posting rules, audit retention, backup/recovery objectives and deployment topology.
