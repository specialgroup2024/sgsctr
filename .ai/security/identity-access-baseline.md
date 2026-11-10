# Identity and access security baseline

Status: API bearer authentication exists on master. Next.js BFF login/session and organization workspace are implemented on phase-3 branch; PR/CI/runtime verification pending. Business authorization policy approvals remain pending.

## Trust boundaries

- Browser and mobile clients are untrusted public environments.
- The API is the enforcement point for resource access and business permissions.
- PostgreSQL is private to the application network; clients never connect directly.
- Keycloak authenticates identities and issues tokens; the API authorizes each requested action.
- pgAdmin is a local development administration tool, not an application identity service.

## Implemented technical controls

1. Keycloak is provided as a self-hosted local development Compose service.
2. The `sgsctr` realm has an API resource-server identifier `sgsctr-api`.
3. The API validates bearer access tokens using OIDC metadata and provider signing keys.
4. Token validation checks signature, issuer, audience and lifetime.
5. A fallback authorization policy requires an authenticated principal for endpoints unless explicitly marked anonymous.
6. Only root, liveness, readiness and system information endpoints are explicitly anonymous.
7. `GET /api/v1/auth/me` is an authenticated diagnostic endpoint.
8. Phase 3 adds a Next.js BFF Authorization Code + PKCE flow, ID-token signature/issuer/audience/nonce validation, API validation of the access token, encrypted HttpOnly session cookies, refresh and sign-out.
9. Phase 3 adds protected web routes and authenticated organization reference-data endpoints.
10. Organization location writes require an explicit subject allowlist; it is empty by default and no default administrator is seeded.

## Required controls still pending

- Verify the Phase 3 BFF flow in CI and on the Linux VM with a provisioned test user.
- Approve and implement enterprise role catalogue, permissions, sector/location/project scopes, separation of duties and resource-level checks.
- Approve user provisioning, deactivation, recovery, MFA enforcement and emergency access.
- Implement React Native Authorization Code with PKCE and operating-system secure credential storage; do not embed client secrets.
- Add valid-token, invalid-signature, issuer, audience, expiry, disabled-user and authorization integration tests.
- Configure production TLS, reverse proxy, secret storage, Keycloak database, backups, monitoring and high availability.

## Owner-controlled policy

The following must not be invented by implementation agents:
- Role names, role membership and permission catalogue.
- Legal-entity, sector, branch and warehouse scope assignments.
- Approval limits, dual control and separation-of-duties rules.
- User invitation, onboarding, offboarding, recovery, MFA exceptions and emergency access.
- Access review frequency and privileged-account ownership.

## Minimum verification suite

- No token, malformed token, expired token, invalid signature, issuer or audience: 401.
- Valid identity without permission: 403.
- Valid permission in one sector/location cannot read or mutate another scope.
- Disabled/revoked user cannot continue privileged activity beyond documented provider behavior.
- Client cannot elevate authority by changing request fields or local UI state.
- Health endpoints disclose only the minimum status required.
- No secret/token/credential appears in application, audit, CI or error logs.

## Current implementation boundary

The organization location reference-data table and EF migration are included in Phase 3; this is not a business transaction schema. No enterprise role/permission model, persisted business audit event model or API test project is included. The current Keycloak service uses development mode and must not be exposed as a production identity service.
