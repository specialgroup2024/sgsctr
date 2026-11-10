# Current state

Last reviewed: 2026-11-10.

Status: Phase 1 technical controls and Phase 2 application shell are present on master. Phase 3 authentication, navigation and organization workspace are implemented on branch phase-3-auth-organization-workspace; merge, CI and local VM runtime verification remain pending. Do not claim successful end-user login until the BFF/Keycloak/API flow has been exercised.

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
- API: ASP.NET Core `net10.0`, EF Core/Npgsql; SDK pin `10.0.403`; Npgsql provider `10.0.3`.
- Database Compose image: PostgreSQL `18-alpine`.
- Web: Next.js `15.5.7`, React `19.1.1`.
- Master contains Keycloak/API bearer authentication and the Phase 2 application shell.
- The API validates JWT signature, issuer, audience and lifetime; fallback authorization requires authentication except explicitly anonymous endpoints.
- Protected diagnostic endpoint: `GET /api/v1/auth/me`.
- Local Keycloak realm: `sgsctr`; API audience: `sgsctr-api`. No user or business role is seeded.
- Local Keycloak `start-dev`, HTTP and dual issuer validation are development-only.
- No approved enterprise role/permission matrix or persisted business audit event model exists.

## Phase 3 implementation boundary

- Next.js BFF login uses Keycloak Authorization Code with PKCE, ID-token signature/issuer/audience/nonce verification, API access-token validation and encrypted HttpOnly session cookies; browser storage is not used for bearer tokens.
- Protected routes include overview, organization, pharmacies and contracting; navigation shows the signed-in identity and sign-out action.
- Organization sectors are owner-provided directory values. Pharmacy location reference records are persisted through an EF migration; the migration seeds the four owner-provided locations without asserting legal ownership or licensing.
- Authenticated users can read the directory. Location create/edit/deactivate requires the exact subject to be placed in `ORGANIZATION_MANAGER_SUBJECTS`; this is empty by default and does not replace a future role/scope matrix.
- No inventory, pharmacy transactions, contracting transactions, financial posting or legal-entity editing is enabled.
- Existing Keycloak realm volumes are persistent. The web client and audience mapper must be applied using the documented admin-console procedure; do not delete the Keycloak volume.

## Governance and next milestone

- Root `AGENT.md`, `AGENTS.md` and `.ai/` define dynamic five-role operation and human/professional approval boundaries.
- Pharmacy stock-transfer workflow and acceptance criteria remain proposals pending pharmacy-operations, accountant and owner approval.
- Run CI and VM runtime verification for Phase 3, complete an approved test-user login, and validate refresh/logout/401 behavior.
- Obtain owner approval for account lifecycle/MFA/recovery and the enterprise role/permission/entity-sector-location matrix before implementing business authorization.
