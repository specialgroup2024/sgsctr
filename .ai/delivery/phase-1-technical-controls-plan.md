# Phase 1 technical controls plan

Status: execution plan; identity-provider and business-access decisions remain open.

## Starting evidence

- API: ASP.NET Core 10, minimal endpoints, EF Core/Npgsql registration.
- Database: PostgreSQL 18 Compose service.
- Web: Next.js 15.5.7.
- API currently has no authentication middleware, authorization policies, migrations, persisted audit events or test project.
- Existing CI restores/builds the solution, starts the Compose stack and runs API/database/web smoke tests.

## Work packages

### P1.1 Identity and authorization decision
- Confirm provider, hosting/data-residency, cost, MFA, recovery and user lifecycle.
- Obtain owner-approved role, permission and entity/sector/location scope matrix.
- Resolve ADR-0002; do not implement a guessed provider or business roles.

### P1.2 Authentication integration
- Implement standards-based OIDC/OAuth integration for approved clients/provider.
- Validate JWT signature, issuer, audience, expiry and required claims in API.
- Add default-deny authorization for business endpoints; explicitly mark minimal health endpoints anonymous.
- Add 401/403, invalid-token, disabled-user and cross-scope tests.

### P1.3 Audit and observability
- Approve event catalogue, data classification, retention, access and export requirements.
- Implement structured logs with redaction and correlation.
- Implement append-only audit persistence and transactional outbox for approved consequential actions.
- Verify that sensitive values cannot enter logs or audit payloads.

### P1.4 EF Core migration and database test baseline
- Pin EF Core tooling/provider versions compatible with the selected .NET runtime.
- Add a deterministic design-time DbContext creation path if needed.
- Add migration generation, review and PostgreSQL integration-test workflow.
- Do not create business tables or seed business records before domain approval.

### P1.5 Backup and recovery
- Document local backup/restore commands and safe handling of backup files.
- Test restore into an isolated database/container, never over the only working database.
- Obtain owner-approved retention and recovery objectives before production claims.

## Gates and acceptance evidence

- Identity provider and access matrix are owner-approved.
- API rejects missing/invalid credentials on protected routes and distinguishes 401 from 403.
- Cross-sector/location negative tests pass.
- Migration can be applied to a clean PostgreSQL instance and tested against a representative non-production database.
- Audit event and business state persistence are atomic where required; redaction tests pass.
- Backup restore is demonstrated in an isolated environment.
- CI records exact build, test, migration and smoke-test results.

## Explicit exclusions

No business workflow, pharmacy stock schema, contracting schema, financial posting, inventory valuation, patient balance, tax calculation, production identity provider, production migration or production deployment is authorized by this plan alone.
