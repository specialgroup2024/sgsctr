# ADR-0002: Identity and access architecture

- Status: Owner-directed replacement — ASP.NET Core Identity; implementation and runtime verification pending.
- Date: 2026-11-10
- Scope: ASP.NET Core API, Next.js web client and future React Native client.
- Decision authority: project owner explicitly requested normal application-managed authentication instead of Keycloak.

## Context

SGSCTR uses ASP.NET Core 10, PostgreSQL 18, Next.js and a future React Native client. The previous self-hosted Keycloak choice introduced a separate identity service and administration burden that the owner does not want.

## Decision

1. Use ASP.NET Core Identity with EF Core/Npgsql as the application-owned account and credential system. No external identity provider is required.
2. Store Identity users, roles, claims and tokens in the existing PostgreSQL database, isolated in the identity schema. Keep existing business/reference tables intact.
3. Use supported ASP.NET Core Identity API endpoints for password sign-in and bearer-token issuance/refresh. Do not implement custom password hashing or a proprietary token format.
4. Use a Next.js BFF for browser sign-in. Keep access/refresh tokens server-side inside an encrypted, HttpOnly, SameSite cookie; never expose tokens to browser JavaScript or localStorage/sessionStorage.
5. The future React Native client may call the application Identity API over HTTPS and store tokens only in OS-protected secure storage. Complete mobile token lifecycle/revocation design and tests before release.
6. Public registration is disabled. Accounts are provisioned by an authenticated administrator. An optional first-run bootstrap administrator is created only when both bootstrap email and password are explicitly configured; changing those variables never resets an existing account.
7. Authentication and authorization remain separate. The API denies by default; business role membership, sector/location/project scopes and approval limits remain owner-controlled decisions.
8. Use Identity password hashing, unique email, minimum 12-character complexity, lockout after five failed attempts for 15 minutes, and generic sign-in failure messages. MFA, email verification, password recovery and account lifecycle workflows require approved policy and configured delivery.
9. Keep liveness/readiness endpoints deliberately minimal and explicitly anonymous.

## Alternatives considered

- Self-hosted Keycloak: previously selected, now rejected by explicit owner direction because a separate identity service is not wanted.
- Custom password hashing/token implementation: rejected; use framework-supported Identity.
- Public self-registration: rejected; application accounts are administrator-provisioned.

## Data and migration safeguards

- Add Identity tables in a dedicated identity schema within the existing PostgreSQL database.
- Do not drop, recreate, rename or migrate existing business/reference tables as part of this change.
- Never delete the legacy sgsctr_keycloak_data volume during transition. Compose no longer mounts it; it remains untouched until the owner explicitly authorizes a separate retention decision.
- Back up PostgreSQL before applying the new Identity migration in any existing environment.

## Consequences and residual risks

- API and web implementation are being migrated on feature/native-identity-authentication; merge, build, CI and VM runtime verification are pending.
- A bootstrap administrator must be configured securely before first use; no real credentials are committed.
- No production email sender, MFA enforcement, recovery flow, session revocation policy or React Native implementation is claimed complete.
- No business role/permission/scope matrix is approved. Authentication alone does not authorize pharmacy, contracting, finance or accounting actions.

## Required owner decisions still open

- Production HTTPS/domain, secret storage, backup/restore and key persistence.
- User populations, administrator ownership, account creation/deactivation, MFA, email verification and recovery policy.
- Role catalogue, permissions, legal-entity/sector/location scopes and separation of duties.
- React Native token storage, expiry, refresh and revocation requirements.
