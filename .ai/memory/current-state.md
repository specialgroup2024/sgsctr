# Current state

Last reviewed: 2026-11-11.

Status: Phase 1 technical controls, Phase 2 application shell, Phase 3 organization workspace and native ASP.NET Core Identity code are present on master. End-to-end login, CI and local VM runtime verification must still be evidenced before claiming production-ready authentication. The EDA regulatory-ingestion MVP is being implemented on feat/eda-regulatory-ingestion; it is not yet merged or runtime-verified.

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
- Master now registers ASP.NET Core Identity through IdentityRegistration.cs, persists Identity in PostgreSQL schema identity and uses native Identity bearer-token validation with default-deny authorization. Verify login/refresh/logout end-to-end before claiming runtime success.
- Protected diagnostic endpoint: `GET /api/v1/auth/me`.
- Current Compose does not run Keycloak. The legacy sgsctr_keycloak_data volume is retained but unused; do not delete it as part of unrelated work.
- The legacy sgsctr_keycloak_data volume is retained but not mounted or deleted by the new Compose file.
- No approved enterprise role/permission matrix or persisted business audit event model exists.

## Phase 3 implementation boundary

- Master contains native email/password sign-in, Identity API tokens and encrypted HttpOnly BFF sessions; runtime verification remains pending.
- Protected routes include overview, organization, pharmacies and contracting; navigation shows the signed-in identity and sign-out action.
- Organization sectors are owner-provided directory values. Pharmacy location reference records are persisted through an EF migration; the migration seeds the four owner-provided locations without asserting legal ownership or licensing.
- Authenticated users can read the directory. Location create/edit/deactivate requires the exact subject to be placed in `ORGANIZATION_MANAGER_SUBJECTS`; this is empty by default and does not replace a future role/scope matrix.
- No inventory, pharmacy transactions, contracting transactions, financial posting or legal-entity editing is enabled.
- The legacy Keycloak volume is retained but unused; do not delete it during the transition.

## EDA regulatory intelligence implementation branch

- Owner requested automatic EDA document ingestion and in-app notifications; this is now approved MVP scope, not merely an agent-only proposal.
- Branch feat/eda-regulatory-ingestion adds a hosted EDA page monitor, four seeded EDA sources, PostgreSQL document/source/alert/scan persistence, authenticated API/BFF endpoints, document download and a Pharmacy Regulatory Intelligence workspace.
- New records remain Unverified/Pending; no pharmacy prices, dispensing, inventory, reimbursement or accounting rules are changed.
- CI, API startup/migration, source reachability, actual ingestion, alert display and document download remain unverified until the branch runs in GitHub Actions and in the local VM.
- Scope is bounded to four public EDA pages; wider Egyptian sources, OCR, publication/effective-date extraction, email/SMS/push, retention policy and reviewer assignment remain open.

## Governance and next milestone

- Root `AGENT.md`, `AGENTS.md` and `.ai/` define dynamic five-role operation and human/professional approval boundaries.
- Pharmacy stock-transfer workflow and acceptance criteria remain proposals pending pharmacy-operations, accountant and owner approval.
- Run CI and VM runtime verification for Phase 3, complete an approved test-user login, and validate refresh/logout/401 behavior.
- Obtain owner approval for account lifecycle/MFA/recovery and the enterprise role/permission/entity-sector-location matrix before implementing business authorization.
