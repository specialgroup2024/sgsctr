# Current state

Last reviewed: 2026-11-10.

Status: Phase 1 technical foundation exists; technical-control design is now being prepared. No business features or production financial workflows are implemented.

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

- Default branch inspected: `master`; project solution is `Sgsctr.slnx`.
- API: ASP.NET Core `net10.0`, EF Core/Npgsql registration and minimal endpoints for root, liveness, readiness and system information.
- SDK pin: .NET SDK `10.0.403`; Npgsql EF Core provider package version `10.0.3`.
- Database Compose image: PostgreSQL `18-alpine`; local Compose service is `db`.
- Web: Next.js `15.5.7`, React `19.1.1`.
- Compose includes `db`, `api`, `web` and local pgAdmin. pgAdmin is loopback-bound to host port 5051.
- The API readiness endpoint tests database reachability. It is not a business correctness or production readiness test.
- No authentication middleware, authorization policies, application user/role model, persisted audit event model, EF migration or API test project was found in the inspected paths.
- Existing CI workflow builds the solution, starts the Compose stack and runs the API/database/web smoke script. A previous Phase 1 CI run was recorded as successful in repository memory; this task did not rerun GitHub Actions or the owner's local smoke test.
- The owner confirmed pgAdmin login and pgAdmin-to-PostgreSQL connectivity locally in this conversation. This does not prove API-to-PostgreSQL connectivity.

## Governance and domain design

- Root `AGENT.md`, `AGENTS.md` and `.ai/` define the dynamic five-role process and human/professional approval boundaries.
- Pharmacy stock-transfer workflow, 21 acceptance criteria and non-posting technical design remain proposals pending pharmacy-operations, accountant and owner approval.
- No production stock posting, inventory valuation, tax calculation, claim settlement or patient-balance logic is approved.

## Phase 1 technical-control work

- Proposed identity/access architecture: `.ai/architecture/ADR-0002-identity-and-access.md`.
- Identity controls: `.ai/security/identity-access-baseline.md`.
- Audit/logging controls: `.ai/security/audit-logging-baseline.md`.
- Work packages and acceptance gates: `.ai/delivery/phase-1-technical-controls-plan.md`.
- These are proposed design artifacts, not implemented controls. Identity provider, account lifecycle, business roles/scopes, audit retention and event catalogue remain owner decisions.

## Next milestone

Obtain owner decisions for identity provider, user lifecycle/MFA/recovery and the role/permission/entity-sector-location matrix. Then implement and test provider-backed authentication, default-deny API authorization, PostgreSQL migration tooling, audit persistence/redaction, and isolated backup/restore verification. Keep pharmacy and contracting business features gated on their respective owner and professional approvals.
