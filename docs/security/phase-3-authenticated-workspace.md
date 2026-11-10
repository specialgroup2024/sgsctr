# SGSCTR authenticated workspace setup

Status: implementation guide for the phase-3 branch. Local development only; not a production deployment approval.

## What this phase implements

- Keycloak OpenID Connect Authorization Code with PKCE login.
- Next.js server-side BFF session using an encrypted, HttpOnly, SameSite=Lax cookie. Access and refresh tokens are not written to browser storage.
- ID-token signature, issuer, audience and nonce verification; the API independently validates the access token.
- Login, logout, session refresh, protected pages and authenticated navigation.
- Organization sector directory and PostgreSQL-backed location register.
- Location create/edit/deactivate API operations, gated by an explicit subject allowlist.
- Initial location rows reflect only owner-provided names. Legal identity, ownership and licensing are not asserted.

## Preserve existing data

Never use `docker compose down -v`, remove named volumes, or delete PostgreSQL/Keycloak data to troubleshoot. This phase adds one EF migration; it does not drop or recreate existing application data.

## Migration rollback safety

The forward migration only adds the `OrganizationLocations` table and its owner-provided seed rows. Its `Down` operation drops that table and all location records created in it. Do not run an EF downgrade without explicit owner approval and a verified export/backup of those records. Normal startup applies only pending forward migrations.

## Configure the VM

1. Update the existing ignored `.env` file manually; do not replace it if it contains existing database passwords.
2. Ensure these values exist:
   - `AUTH_SESSION_SECRET`: output of `openssl rand -base64 48` (at least 32 characters).
   - `WEB_BASE_URL=http://localhost:3000`
   - `KEYCLOAK_PUBLIC_URL=http://localhost:8180`
   - `COOKIE_SECURE=false` for this local HTTP tunnel only.
   - Keep existing PostgreSQL, pgAdmin and Keycloak passwords unchanged.
   - Leave `ORGANIZATION_MANAGER_SUBJECTS` empty until the owner approves a specific account.
3. Compose binds web, API, Keycloak, PostgreSQL and pgAdmin to VM loopback addresses. From your desktop, open an SSH tunnel:

       ssh -N -L 3000:127.0.0.1:3000 -L 8180:127.0.0.1:8180 YOUR_USER@YOUR_VM_IP

4. In a second VM terminal, rebuild and start without removing volumes:

       docker compose up -d --build

5. Check startup and migration:

       docker compose ps
       docker compose logs --tail=100 api web keycloak

   The API applies the new migration automatically only in Development because `Database__ApplyMigrations=true` is set by this Compose file. Existing named PostgreSQL volumes are retained.

## Configure the existing Keycloak realm

The existing Keycloak database volume is persistent. Realm JSON import is not an update mechanism for an already-imported realm. Do not delete the Keycloak volume.

In Keycloak Admin Console at `http://localhost:8180`, select realm `sgsctr` and create this client if it is not already present:

- Client ID: `sgsctr-web`
- Client type/protocol: OpenID Connect
- Client authentication: Off (public client)
- Standard flow: On
- Direct access grants: Off
- Valid redirect URI: `http://localhost:3000/api/auth/callback`
- Valid post-logout redirect URI: `http://localhost:3000/*`
- Web origin: `http://localhost:3000`
- Proof Key for Code Exchange: S256 (required)

Add an access-token audience mapper to this client:
- Mapper type: Audience
- Included client audience: `sgsctr-api`
- Add to access token: On
- Add to ID token: Off

The access token must contain audience `sgsctr-api`; otherwise the API correctly rejects it. Do not enable password grant or implicit flow.

Create test users only for approved personnel, using individual accounts and the owner's approved MFA/recovery policy. Do not use the Keycloak bootstrap administrator as an application user.

## First sign-in and organization-manager permission

1. Open `http://localhost:3000` through the SSH tunnel.
2. Sign in with the approved Keycloak test account.
3. Confirm that the overview and Organization page load and the user identity appears in the top bar.
4. Organization data is readable by authenticated users. Create/edit/deactivate is denied by default.
5. If the owner authorizes one account to manage organization reference records, copy that user's subject identifier from the Organization page and add it to `ORGANIZATION_MANAGER_SUBJECTS` in the VM's ignored `.env`, comma-separated if more than one.
6. Recreate only the API service to load the allowlist:

       docker compose up -d --force-recreate api

No role is automatically assigned, no user is seeded, and no default administrator is created. The allowlist is a temporary, explicit technical gate; it is not a substitute for a future approved role and scope model.

## Security and operational boundaries

- This is a local development Keycloak deployment using HTTP and `start-dev`. Never expose these ports directly to the internet.
- Use SSH tunnels; ports are loopback-bound on the VM.
- For HTTPS production, configure canonical HTTPS URLs, secure cookies, hardened Keycloak, managed secrets, production database, backups, monitoring, MFA, account lifecycle and a reviewed authorization policy.
- Organization records are reference data only. Legal identity changes, stock operations, pharmacy transactions, contracting transactions, accounting and financial postings are not implemented.
- Deactivation is soft; records remain in PostgreSQL.
- No persisted business audit event model is included yet. Do not treat application logs as a complete audit trail.

## Troubleshooting

- Login returns `token_exchange_failed`: check Keycloak client redirect URI, client ID and PKCE S256.
- Login returns `api_token_rejected`: inspect the access token audience mapper and API logs; `aud` must include `sgsctr-api`.
- Login returns `authentication_failed`: check Keycloak discovery/JWKS reachability from the web container and inspect `docker compose logs web keycloak api`.
- Browser cannot reach login or callback: ensure both SSH forwards are open and use exactly `localhost:3000` / `localhost:8180`.
- Never remove database or Keycloak volumes as a login fix.
