# Keycloak local development setup

Status: implemented development identity-provider foundation; production deployment is not approved by this runbook.

## What is provisioned

- Keycloak 26.8.2 runs as a separate Compose service.
- The Keycloak administration UI is bound to localhost only at http://localhost:8180.
- The imported realm is `sgsctr`; the resource-server audience/client identifier is `sgsctr-api`.
- Keycloak development data is persisted in the named `sgsctr_keycloak_data` volume.
- The API validates signed bearer access tokens against the realm metadata and signing keys.
- The API expects issuer `http://localhost:8180/realms/sgsctr` and audience `sgsctr-api` in local Compose.
- The API's metadata request uses the internal Compose hostname; the public issuer remains localhost so browser-based OIDC clients use the same issuer.
- No end-user, business role, sector/location permission, or privileged account is seeded.

## First startup

1. Copy `.env.example` to `.env`.
2. Set unique, strong local values for `POSTGRES_PASSWORD`, `PGADMIN_DEFAULT_PASSWORD`, and `KEYCLOAK_ADMIN_PASSWORD`.
3. Start the stack:

       docker compose up --build -d

4. Wait for Keycloak, then open http://localhost:8180.
5. Sign in using the bootstrap administrator username/password from your ignored local `.env`.
6. Confirm the `sgsctr` realm is available in the realm selector.
7. Create named user accounts only for approved test personnel. Do not reuse the bootstrap administrator for application access.

## Configure a test client and user

The API accepts access tokens whose issuer is `http://localhost:8180/realms/sgsctr` and whose audience includes `sgsctr-api`.

Before a test user can call the API:

1. In the `sgsctr` realm, create an OIDC client for the intended test client. Use Authorization Code with PKCE for a public client, or a confidential server-side client for a BFF.
2. Do not enable Direct Access Grants / Resource Owner Password Credentials.
3. Add an audience protocol mapper to the client or an assigned client scope. Set the included client audience to `sgsctr-api`; include it in the access token, not the ID token.
4. Create a test user, set a non-reused password, and configure required actions/MFA according to the approved test policy.
5. Obtain an access token through the Authorization Code flow and call:

       curl -i -H "Authorization: Bearer <ACCESS_TOKEN>" http://localhost:8080/api/v1/auth/me

6. The API should return HTTP 200 with the authenticated subject. Do not paste real tokens into tickets, chat, source control or logs.

## Anonymous and protected endpoints

- Anonymous: `/`, `/health/live`, `/health/ready`, `/api/v1/system/info`.
- Authentication required: `/api/v1/auth/me`.
- A fallback authorization policy requires authentication for any newly mapped endpoint unless it explicitly opts into anonymous access.
- No business authorization policies or role/scope claims are defined yet. Authentication does not grant pharmacy, contracting, accounting or administrative permissions.

## Important environment boundaries

- `start-dev`, the development database mode, HTTP issuer and local bootstrap credentials are for local development only.
- The Keycloak port is loopback-bound. Do not expose it to a LAN or the public internet.
- Production requires a hardened Keycloak deployment, HTTPS, a separately managed PostgreSQL database, protected secrets, backup/restore, monitoring, account lifecycle/MFA policy, and a reviewed reverse-proxy/hostname configuration.
- Do not delete the PostgreSQL or Keycloak named volumes to troubleshoot login; doing so destroys local data.
- Changing the imported realm JSON does not overwrite an already imported realm in a persistent Keycloak volume. Apply realm changes deliberately through the admin console or a reviewed realm migration. Never delete the volume merely to re-import configuration.

## Verification

Run:

    bash scripts/smoke-test.sh

The script checks API/database readiness, Keycloak realm discovery, HTTP 401 for anonymous access to the protected identity endpoint, rejection of a malformed bearer token, and web availability. It does not prove successful end-user login, authorization scopes, MFA, account revocation, production hardening or cross-sector isolation.
