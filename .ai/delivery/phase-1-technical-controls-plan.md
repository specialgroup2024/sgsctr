# Phase 1 technical controls plan

Status: partially implemented; provider-backed API authentication foundation is in this phase branch. Remaining work requires additional policy decisions and verification.

## Starting evidence

- API: ASP.NET Core 10, EF Core/Npgsql registration and minimal endpoints.
- Database: PostgreSQL 18 Compose service.
- Web: Next.js 15.5.7.
- Keycloak 26.8.2 selected for self-hosted identity; local development service and realm import added.
- API JWT bearer validation and default-deny fallback authorization added.
- No approved business role/permission matrix, persistent audit model, EF migration or API test project exists.

## Work packages

### P1.1 Identity and authorization decision
- [x] Select self-hosted Keycloak for the identity-provider direction.
- [x] Define local realm and API audience identifier.
- [ ] Approve production hosting/data-residency, domain/TLS, HA, backup and recovery design.
- [ ] Approve user lifecycle, MFA/recovery and emergency access.
- [ ] Approve role, permission and entity/sector/location scope matrix.

### P1.2 Authentication integration
- [x] Add Keycloak local development service and persistent named volume.
- [x] Import the `sgsctr` realm with the `sgsctr-api` resource-server client.
- [x] Configure API JWT bearer validation for signature, issuer, audience and lifetime.
- [x] Require authentication by default; explicitly allow only the existing minimal public endpoints.
- [x] Add a protected identity diagnostic endpoint.
- [x] Extend smoke tests for anonymous and malformed-token 401 responses.
- [ ] Implement Next.js server-side BFF sign-in/session/logout.
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

The code and Compose changes are committed on the phase branch. No local Docker startup, .NET build, successful Keycloak user login, API integration test, backup/restore or GitHub Actions run has yet been observed for this branch.

## Explicit exclusions

No business workflow, pharmacy stock schema, contracting schema, financial posting, inventory valuation, patient balance, tax calculation, production identity provider deployment, production migration or production deployment is authorized by this plan alone.
