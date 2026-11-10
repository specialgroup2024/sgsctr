# ADR-0002: Identity and access architecture

- Status: **Accepted — self-hosted Keycloak for the identity-provider direction; production topology and business authorization policy remain pending**
- Date: 2026-11-10
- Scope: ASP.NET Core API, Next.js web client and future React Native client
- Decision authority: project owner selected self-hosted hosting; Keycloak is the implementation provider for the current phase

## Context

The repository contains an ASP.NET Core 10 API, Next.js web foundation and PostgreSQL 18. The API had no authentication or authorization middleware. The owner selected a self-hosted identity provider.

## Decision

1. Use self-hosted Keycloak as the OIDC provider. Pin the local development image to Keycloak 26.8.2; review security updates before upgrading.
2. Use OpenID Connect for user authentication and OAuth 2.0 access tokens for API authorization. Do not create a proprietary password-to-token endpoint or self-issued production JWTs.
3. Use Authorization Code with PKCE for public clients. Prefer a server-side Backend-for-Frontend (BFF) for the Next.js browser experience, with secure, HttpOnly, SameSite cookies and server-held tokens. Do not store bearer or refresh tokens in browser localStorage/sessionStorage.
4. Treat the React Native application as a public client using Authorization Code with PKCE and operating-system secure credential storage. Do not embed client secrets in the mobile app.
5. The API validates access-token signature, issuer, audience and expiry using Keycloak OIDC metadata and signing keys. ID tokens are for client sign-in, not API access tokens.
6. Implement authorization in the API with named policies and resource-level checks. Deny by default for business endpoints. Never trust client-supplied role, sector, location or legal-entity identifiers without server-side authorization.
7. Model access dimensions separately: legal entity, sector, location/branch/warehouse and resource/project where applicable. Do not define business roles or approval limits in this ADR.
8. Keep liveness/readiness endpoints deliberately minimal and explicitly anonymous; do not expose connection strings, hostnames, exception details or secrets in health responses.

## Alternatives considered

- Custom username/password and JWT issuer in the application: rejected due to credential lifecycle, token security, MFA, recovery and operational burden.
- Hard-coded local administrator and role seed: rejected because no approved user lifecycle or role matrix exists.
- Managed identity provider: not selected because the owner chose self-hosted hosting.

## Security and operational requirements

- MFA capability for privileged accounts; exact enforcement and recovery policy require owner approval.
- Short-lived access tokens; refresh-token issuance, rotation, revocation and storage follow the selected provider's supported secure design.
- Validate issuer, audience, signature, expiry and required claims. Fail closed on invalid or missing configuration.
- No secrets, tokens, password material or sensitive health information in logs.
- Account provisioning, deactivation, recovery, access review and emergency access must be documented and auditable.
- Separate authentication (who is the caller?) from authorization (what may the caller do?).

## Consequences and residual risks

- Local Keycloak service and API bearer-token validation are implemented in the development stack.
- No production-grade Keycloak deployment, Next.js BFF login flow or React Native login flow is implemented yet.
- No business role, permission, approval limit, legal-entity/sector/location scope or separation-of-duties policy is approved.
- Authentication alone does not authorize pharmacy, contracting, finance or accounting actions.

## Required owner decisions still open

- Production hosting location, domain, TLS termination, HA, database, backup and recovery design.
- User populations, invitation/provisioning, MFA enforcement, recovery and emergency-access policy.
- Role catalogue, permissions, legal-entity/sector/location scopes and separation of duties.
- Administrator and emergency-access responsibilities.

## References

- Keycloak: [OIDC endpoints and discovery](https://www.keycloak.org/docs/latest/securing_apps/#_oidc)
- Keycloak: [Release notes](https://www.keycloak.org/docs/latest/release_notes/)
- Microsoft Learn: [JWT bearer authentication in ASP.NET Core 10](https://learn.microsoft.com/aspnet/core/security/authentication/configure-jwt-bearer-authentication?view=aspnetcore-10.0)
