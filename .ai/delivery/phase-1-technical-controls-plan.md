# Phase 1 technical controls plan

Status: core API/database foundation and native Identity implementation are present on master. Owner VM checks verify database readiness and web-to-API connectivity. Authentication enforcement, security tests, backup/restore and production controls remain open.

## Starting evidence
- API: ASP.NET Core 10, EF Core/Npgsql.
- Database: PostgreSQL 18 Compose service.
- Web: Next.js 15.5.7.
- ASP.NET Core Identity is registered in a dedicated PostgreSQL identity schema.
- API readiness checks both application and Identity contexts.
- No approved business role/permission matrix or persistent business audit-event model exists.

## Work packages

### P1.1 Identity and authorization
- [x] Owner selected application-managed ASP.NET Core Identity; external Keycloak rejected.
- [x] Add Identity schema and native login/refresh endpoints; public registration disabled.
- [x] Default-deny API authorization when Authentication:Enabled is true.
- [x] Add Next.js BFF sign-in/session implementation and protected identity diagnostic endpoint.
- [ ] Verify effective local Compose setting; it defaults AUTHENTICATION_ENABLED=false in Development.
- [ ] Run successful login, refresh, logout, anonymous-denial and invalid-token tests with authentication enabled.
- [ ] Approve production hosting, HTTPS/domain, secrets, MFA/recovery and emergency access.
- [ ] Approve role, permission and entity/sector/location scope matrix.
- [ ] Implement React Native token lifecycle and OS secure storage before mobile release.

### P1.2 Audit and observability
- [ ] Approve event catalogue, data classification, retention, access and export requirements.
- [ ] Implement structured logs with redaction and correlation.
- [ ] Implement append-only audit persistence and transactional outbox for approved consequential actions.
- [ ] Verify sensitive values cannot enter logs or audit payloads.

### P1.3 EF Core and database test baseline
- [x] PostgreSQL is a mandatory API startup dependency; readiness checks application and Identity contexts.
- [x] Correct duplicate regulatory-document index migration in merged PR #24; preserve the existing index and migration history.
- [ ] Add deterministic design-time DbContext creation if needed.
- [ ] Add migration generation/review and PostgreSQL integration-test workflow.
- [ ] Do not create business tables or seed business records before domain approval.

### P1.4 Backup and recovery
- [x] Named Data Protection volume is defined in Compose and mounted at /var/lib/sgsctr/data-protection-keys.
- [ ] Verify existing key ring preservation and volume persistence after API-container recreation.
- [ ] Configure production certificate-based Data Protection key encryption and secret delivery.
- [ ] Document local PostgreSQL backup/restore commands.
- [ ] Test restore into an isolated database/container, never over the only working database.
- [ ] Obtain owner-approved retention and recovery objectives before production claims.

## Verification record
Owner-provided VM output dated 2026-11-11:
- GET /health/live returned HTTP 200.
- GET /health/ready returned HTTP 200 with database, applicationContext and identityContext connected.
- Web container fetch to http://api:8080/health/ready returned HTTP 200.
- GET /api/system-status returned HTTP 200 with api=online and database=connected.
These tests verify connectivity, not user authentication, authorization or production readiness. GitHub CI results must be checked from the current workflow run before claiming a check passed.

## Explicit exclusions
No business workflow, pharmacy stock schema, contracting schema, financial posting, inventory valuation, patient balance, tax calculation or production deployment is authorized by this plan alone.
