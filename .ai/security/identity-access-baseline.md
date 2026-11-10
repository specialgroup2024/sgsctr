# Identity and access security baseline

Status: proposed technical baseline; provider and business policy approvals pending.

## Trust boundaries

- Browser and mobile clients are untrusted public environments.
- The API is the enforcement point for resource access and business permissions.
- PostgreSQL is private to the application network; clients never connect directly.
- The identity provider authenticates identities; the API authorizes each requested action.
- pgAdmin is a local development administration tool, not an application identity service.

## Required controls

1. Use OIDC/OAuth standards and the approved provider; do not build a custom production token issuer.
2. Validate token signature, issuer, audience, expiry and required claims.
3. Require authentication by default for business endpoints once authentication is enabled.
4. Explicitly allow anonymous access only to minimal health/liveness endpoints.
5. Enforce permissions server-side at endpoint and resource level; a hidden UI control is not authorization.
6. Scope authorization by legal entity, sector and location, with project/resource scope where relevant.
7. Deny access when a scope is absent, ambiguous, inactive or not owned by the authenticated subject.
8. Do not accept user, role, sector or location authority from request-body fields alone.
9. Keep privileged actions separate from ordinary operational permissions; apply separation of duties after owner approval.
10. Log authentication and authorization outcomes without logging credentials, tokens or sensitive business/health data.

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
- Disabled/revoked user cannot continue privileged activity beyond the provider's documented revocation behavior.
- Client cannot elevate authority by changing request fields or local UI state.
- Health endpoints disclose only the minimum status required.
- No secret/token/credential appears in application, audit, CI or error logs.

## Current implementation boundary

The API currently registers EF Core/Npgsql and exposes root, liveness, readiness and system-info endpoints. It does not yet configure authentication, authorization, users, roles or business routes. This document is a control specification, not evidence that those controls are active.
