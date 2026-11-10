# Identity and access security baseline

Status: native ASP.NET Core Identity replacement is implemented on a migration branch; CI, build and runtime verification remain pending. Business authorization policy approvals remain pending.

## Trust boundaries

- Browser and mobile clients are untrusted environments.
- The API is the enforcement point for resource access and business permissions.
- PostgreSQL is private to the application network; clients never connect directly.
- ASP.NET Core Identity owns application accounts and password verification; the API authorizes each requested action.
- pgAdmin is a local development database tool, not an application identity service.

## Implemented on migration branch

1. ASP.NET Core Identity with EF Core/Npgsql, using a dedicated identity schema in the existing PostgreSQL database.
2. Framework password hashing, unique email, minimum 12-character password policy and temporary lockout after five failed attempts.
3. Native API login and refresh endpoints based on ASP.NET Core Identity API endpoints.
4. Public account registration, unauthenticated password recovery and reset endpoints are blocked until an approved email/recovery workflow exists.
5. Optional first-run bootstrap administrator requires explicit environment configuration; an existing account is never reset or promoted automatically.
6. Administrator-only API endpoint provisions standard user accounts; no business roles are assigned automatically.
7. Next.js BFF stores tokens only in an encrypted HttpOnly cookie and sends them server-to-server.
8. Protected web routes and organization reference-data endpoints retain API-side authorization.
9. Organization location writes remain gated by an explicit subject allowlist, empty by default.

## Required controls still pending

- Execute .NET restore/build, Next.js typecheck/build and PostgreSQL migration tests in CI.
- Verify sign-in, invalid password, lockout, refresh, sign-out, disabled user and unauthorized user creation end-to-end.
- Configure persistent ASP.NET Core Data Protection keys and a production secret store before production deployment.
- Approve and implement MFA, email verification, password reset delivery, account deactivation, session revocation and emergency access.
- Implement React Native sign-in with HTTPS and OS secure credential storage; do not embed secrets in the mobile app.
- Approve enterprise role catalogue, permissions, sector/location/project scopes, separation of duties and resource-level checks.
- Implement persisted security audit events, retention, access controls and redaction.

## Owner-controlled policy

Do not invent role names, role membership, sector/location scope, approval limits, dual control, account onboarding/offboarding, MFA exceptions, recovery or emergency access. Obtain owner/security approval before implementing these policies.

## Minimum verification suite

- No token, malformed token, expired token or invalid token: 401.
- Invalid password: generic failure; repeated failures trigger lockout.
- Public registration and unauthenticated recovery/reset endpoints are unavailable.
- Non-administrator cannot provision accounts; authenticated standard user receives 403.
- Valid authentication without permission cannot perform protected business actions.
- Cross-sector/location access is denied by server-side policy.
- No password, token, secret or sensitive personal data appears in logs.

## Data protection boundary

The new Identity schema is additive. Existing organization/reference records and PostgreSQL named volumes must remain intact. The old Keycloak volume is retained but unused; do not remove it as part of this migration.
