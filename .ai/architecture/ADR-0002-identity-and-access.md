# ADR-0002: Identity and access architecture

- Status: **Proposed — owner decision required**
- Date: 2026-11-10
- Scope: ASP.NET Core API, Next.js web client and future React Native client
- Decision authority: project owner for provider, user lifecycle and business access policy

## Context

The repository contains an ASP.NET Core 10 API, Next.js web foundation and PostgreSQL 18. The API currently has no authentication or authorization middleware. The identity provider, user lifecycle, role catalogue and sector/location access matrix are undecided.

## Proposed direction

1. Use OpenID Connect (OIDC) for user authentication and OAuth 2.0 access tokens for API authorization. Do not create a proprietary password-to-token endpoint or self-issued production JWTs.
2. Keep the identity provider replaceable. Select a provider only after the owner confirms hosting, data residency, cost, account recovery, MFA, user administration and support requirements.
3. Use Authorization Code flow with PKCE for public clients. Prefer a server-side Backend-for-Frontend (BFF) for the Next.js browser experience, with secure, HttpOnly, SameSite cookies and server-held tokens. Do not store bearer or refresh tokens in browser localStorage/sessionStorage.
4. Treat the React Native application as a public client using Authorization Code with PKCE and operating-system secure credential storage. Do not embed client secrets in the mobile app.
5. The API validates access-token signature, issuer, audience and expiry using trusted provider metadata/keys. ID tokens are for client sign-in, not API access tokens.
6. Implement authorization in the API with named policies and resource-level checks. Deny by default for business endpoints. Never trust client-supplied role, sector, location or legal-entity identifiers without server-side authorization.
7. Model access dimensions separately: legal entity, sector, location/branch/warehouse and resource/project where applicable. Do not define business roles or approval limits in this ADR.
8. Keep liveness/readiness endpoints deliberately minimal and explicitly anonymous; do not expose connection strings, hostnames, exception details or secrets in health responses.

## Alternatives considered

- Custom username/password and JWT issuer in the application: rejected due to credential lifecycle, token security, MFA, recovery and operational burden.
- Hard-coded local administrator and role seed: rejected because no approved user lifecycle or role matrix exists.
- Provider-specific integration before provider selection: deferred to avoid coupling and rework.

## Security and operational requirements

- MFA capability for privileged accounts; exact enforcement and recovery policy require owner approval.
- Short-lived access tokens; refresh-token issuance, rotation, revocation and storage follow the selected provider's supported secure design.
- Validate issuer, audience, signature, expiry and required claims. Fail closed on invalid or missing configuration.
- No secrets, tokens, password material or sensitive health information in logs.
- Account provisioning, deactivation, recovery, access review and emergency access must be documented and auditable.
- Separate authentication (who is the caller?) from authorization (what may the caller do?).

## Consequences and residual risks

- No business endpoint is considered protected until authentication and authorization middleware plus negative tests are implemented.
- Provider selection and business role/permission mapping remain owner decisions.
- The proposed BFF and mobile flows require a provider that supports standard OIDC/OAuth flows.
- This ADR does not approve pharmacy, contracting, finance or accounting permissions.

## Acceptance criteria for implementation

- Invalid signature, issuer, audience and expired-token tests return 401.
- Anonymous access to protected business routes returns 401; authenticated but unauthorized access returns 403.
- Cross-sector and cross-location access tests prove server-side isolation.
- Browser tokens are not exposed to JavaScript storage; mobile credentials use platform secure storage.
- User disablement/revocation behavior is tested against the chosen provider.
- Health endpoints remain minimal and do not bypass authorization for business routes.

## Required owner decisions

- Identity provider and hosting/data-residency constraints.
- User populations, invitation/provisioning, MFA and recovery policy.
- Role catalogue, permissions, legal-entity/sector/location scopes and separation of duties.
- Administrator and emergency-access responsibilities.

## References

- Microsoft Learn: [JWT bearer authentication in ASP.NET Core 10](https://learn.microsoft.com/aspnet/core/security/authentication/configure-jwt-bearer-authentication?view=aspnetcore-10.0)
- Microsoft Learn: [Authentication and authorization in Minimal APIs](https://learn.microsoft.com/aspnet/core/fundamentals/minimal-apis/security?view=aspnetcore-10.0)
