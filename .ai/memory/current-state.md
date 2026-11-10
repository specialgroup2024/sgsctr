# Current state

Last reviewed: 2026-11-10.

Status: Phase 1 technical-control design is merged. Self-hosted Keycloak and API authentication implementation is in the open phase branch; it is not yet verified by build/runtime tests.

## Owner-provided structure

The owner identifies “Special Group” with Pharmacies Sector and Specialized Contracting Sector. Record provisionally as LE-01 with two sectors. Exact registered name/form/identifiers and whether both sectors are operated by the same legal person remain to be verified.

Pharmacy locations confirmed by owner:
- Mokattam main warehouse.
- Student Hospital branch.
- Qasr El-Aini Hospital branch.
- Manial Hospital branch.

The owner explicitly confirms that the three branches may transfer medicines and supplies directly between one another; a transfer does not have to pass through Mokattam. Support direct branch-to-branch and warehouse-mediated transfers. The locations are administratively connected but separately accountable for inventory and accounting reports.

## Accounting and inventory boundary

- One legal entity has one statutory company accounting framework, subject to official verification.
- Pharmacies and Specialized Contracting retain separate workflows, permissions, budgets, sector subledgers/journals or posting dimensions and management reports.
- Warehouse and each branch require distinct location-level stock balances, movement histories and reports.
- Transfers between any authorized pharmacy locations require source/destination traceability, dispatch, in-transit tracking, receipt confirmation, discrepancy handling and approvals.
- Location transfers within the same legal entity are internal stock movements, not sales or intercompany transactions.
- Transfer valuation, financial posting and detailed workflow policies require accountant and pharmacy-operations approval.
- Do not create duplicate statutory books, separate company databases or intercompany entries solely because of sectors or pharmacy locations.
- Provisional database direction: one PostgreSQL database for LE-01 with strict sector/module access controls.

## Verified repository foundation

- Default branch: `master`; project solution: `Sgsctr.slnx`.
- API: ASP.NET Core `net10.0`, EF Core/Npgsql registration and minimal endpoints.
- SDK pin: .NET SDK `10.0.403`; Npgsql EF Core provider package version `10.0.3`.
- Database Compose image: PostgreSQL `18-alpine`; local Compose service: `db`.
- Web: Next.js `15.5.7`, React `19.1.1`.
- Compose includes `db`, `api`, `web`, local pgAdmin and (on the phase branch) Keycloak.
- pgAdmin is loopback-bound to host port 5051; Keycloak is intended to be loopback-bound to host port 8180.
- The API readiness endpoint tests database reachability only.
- The API now configures JWT bearer authentication and a fallback policy requiring authentication for endpoints unless explicitly marked anonymous. Existing root, health and system-info endpoints are explicitly anonymous.
- Protected diagnostic endpoint: `GET /api/v1/auth/me`; it returns only authentication status and subject identifier.
- Local Keycloak realm: `sgsctr`; API audience: `sgsctr-api`. No end-user or business role is seeded.
- Local Compose uses Keycloak development mode and a local development hostname. This is not a production deployment configuration.
- No approved business role/permission matrix, persisted audit event model, EF migration or API test project is present.
- The owner confirmed pgAdmin login and pgAdmin-to-PostgreSQL connectivity locally. This does not prove API-to-PostgreSQL or Keycloak runtime connectivity.

## Governance and domain design

- Root `AGENT.md`, `AGENTS.md` and `.ai/` define the dynamic five-role process and human/professional approval boundaries.
- Pharmacy stock-transfer workflow, 21 acceptance criteria and non-posting technical design remain proposals pending pharmacy-operations, accountant and owner approval.
- No production stock posting, inventory valuation, tax calculation, claim settlement or patient-balance logic is approved.

## Phase 1 technical-control references

- Identity/access architecture: `.ai/architecture/ADR-0002-identity-and-access.md`.
- Identity controls: `.ai/security/identity-access-baseline.md`.
- Audit/logging controls: `.ai/security/audit-logging-baseline.md`.
- Work packages and acceptance gates: `.ai/delivery/phase-1-technical-controls-plan.md`.
- Local Keycloak setup: `docs/security/keycloak-local-setup.md`.

## Next milestone

Verify the Keycloak/API integration with build and runtime tests, then implement Next.js BFF login. Obtain owner approval for user lifecycle/MFA/recovery and the role/permission/entity-sector-location matrix before implementing business authorization. Continue audit, EF migration tooling and isolated backup/restore work without creating business schema prematurely.
