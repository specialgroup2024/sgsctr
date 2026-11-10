# Phase 1 technical controls plan

Status: native ASP.NET Core Identity migration is under implementation on feature/native-identity-authentication; build, CI and runtime verification are pending.

## Starting evidence

- API: ASP.NET Core 10, EF Core/Npgsql registration and minimal endpoints.
- Database: PostgreSQL 18 Compose service.
- Web: Next.js 15.5.7.
- ASP.NET Core Identity with EF Core/Npgsql is the approved direction; migration adds an identity schema in the existing PostgreSQL database.
- Native API bearer-token login/refresh and default-deny authorization are being implemented.
- No approved business role/permission matrix or persistent audit model exists; a dedicated API integration-test project is still absent.

## Work packages

### P1.1 Identity and authorization decision
- [x] Owner selected application-managed ASP.NET Core Identity; external Keycloak provider rejected.
- [ ] Approve production hosting/data-residency, domain/TLS, HA, backup and recovery design.
- [ ] Approve user lifecycle, MFA/recovery and emergency access.
- [ ] Approve role, permission and entity/sector/location scope matrix.

### P1.2 Authentication integration
- [x] Add ASP.NET Core Identity and an isolated PostgreSQL identity schema migration.
- [x] Add native login/refresh API endpoints and disable public registration.
- [x] Add optional one-time bootstrap administrator and admin-only account provisioning endpoint.
- [x] Require authentication by default; explicitly allow only the existing minimal public endpoints.
- [x] Add a protected identity diagnostic endpoint.
- [x] Extend smoke tests for anonymous API denial, disabled public registration and protected-route redirects.
- [x] Implement Next.js BFF email/password sign-in, encrypted HttpOnly session and local sign-out (runtime verification pending).
- [ ] Implement React Native Authorization Code + PKCE with OS secure storage.
- [ ] Add valid-token, invalid-signature, issuer, audience, expiry and revoked-user integration tests.
- [ ] Implement approved business authorization policies and cross-scope tests.

### P1.3 Audit and observability
- [ ] Approve event catalogue, data classification, retention, access and export requirements.
- [ ] Implement structured logs with redaction and correlation.
- [ ] Implement append-only audit persistence and transactional outbox for approved consequential actions.
- [ ] Verify sensitive values cannot enter logs or audit payloads.

### P1.4 EF Core migration and database test baseline
- [ ] Pin EF Core tooling/provider versions compatible with the selected .NET runtime.
- [ ] Add deterministic design-time DbContext creation if needed.
- [ ] Add migration generation, review and PostgreSQL integration-test workflow.
- [ ] Do not create business tables or seed business records before domain approval.

### P1.5 Backup and recovery
- [ ] Document local backup/restore commands and safe backup handling.
- [ ] Test restore into an isolated database/container, never over the only working database.
- [ ] Obtain owner-approved retention and recovery objectives before production claims.

## Current verification boundary

The code and Compose changes are committed on the phase branch. No local Docker startup, .NET build, successful native user login, API integration test, backup/restore or GitHub Actions run has yet been observed for this branch.

## Explicit exclusions

No business workflow, pharmacy stock schema, contracting schema, financial posting, inventory valuation, patient balance, tax calculation, production identity deployment, production migration or production deployment is authorized by this plan alone.
