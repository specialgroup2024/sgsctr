# SGSCTR native application authentication

Status: migration guide for feature/native-identity-authentication; CI, build, merge and VM runtime verification remain pending.

## Authentication design

- ASP.NET Core Identity owns application users and password hashes.
- Identity tables are added to the existing PostgreSQL database in the identity schema.
- API sign-in and refresh use supported ASP.NET Core Identity API endpoints.
- Next.js handles browser sign-in through a server-side BFF. Tokens are stored in an encrypted HttpOnly SameSite cookie and are never exposed to browser JavaScript.
- Public registration and unauthenticated password recovery/reset are disabled. Users are created by an administrator.
- A future React Native client can use the API over HTTPS and OS-protected secure storage; mobile implementation is not included in this migration.

## Preserve existing data

Never use docker compose down -v, remove named volumes, or delete PostgreSQL data. The new migration adds only the identity schema and Identity tables. It does not drop existing business/reference tables. The legacy sgsctr_keycloak_data volume is intentionally retained but is no longer mounted by Compose.

## Configure the VM

1. Update the existing ignored .env manually; do not replace it or overwrite existing PostgreSQL/pgAdmin credentials.
2. Keep existing POSTGRES_DB, POSTGRES_USER, POSTGRES_PASSWORD and PGADMIN_DEFAULT_* values unchanged.
3. Add BOOTSTRAP_ADMIN_EMAIL and a unique BOOTSTRAP_ADMIN_PASSWORD that meets the password policy (12+ characters, upper/lowercase, digit and symbol). First startup creates this account only if the email is not already present. Changing the variable later does not reset its password.
4. Generate AUTH_SESSION_SECRET using openssl rand -base64 48.
5. Set WEB_BASE_URL=http://localhost:3000 and COOKIE_SECURE=false for the local SSH-tunnel-only HTTP setup.
6. Keep ORGANIZATION_MANAGER_SUBJECTS empty until the owner approves a specific account.
7. Back up PostgreSQL before applying the new migration. Use a verified backup and test restoration separately; never overwrite the only working database.

## Start without deleting volumes

From the repository directory:

    docker compose up -d --build

Check:

    docker compose ps
    docker compose logs --tail=150 api web db

Compose no longer starts Keycloak. Do not run docker compose down -v. From a desktop, the existing web/API tunnel is:

    ssh -N -L 3000:127.0.0.1:3000 -L 8080:127.0.0.1:8080 YOUR_USER@YOUR_VM_IP

Open http://localhost:3000. If using a browser inside the VM, no tunnel is needed.

## First administrator and user provisioning

- Sign in with BOOTSTRAP_ADMIN_EMAIL and BOOTSTRAP_ADMIN_PASSWORD.
- The bootstrap account is assigned the technical Administrator role only when it is first created.
- The protected API endpoint POST /api/v1/admin/users allows an Administrator to create standard accounts. It accepts JSON with email and password and returns the new account ID.
- Public registration is disabled. Do not enable it as a workaround.
- No pharmacy, contracting, accounting or sector/location role is automatically granted. Business roles and scopes require owner approval.
- ORGANIZATION_MANAGER_SUBJECTS remains a temporary explicit gate for organization reference-data writes.

## Current security and release limits

- Password hashing and lockout use ASP.NET Core Identity; the application does not implement its own password hashing.
- MFA, email verification, password reset delivery, account deactivation screens, full audit trail, Data Protection key persistence and formal token revocation are not yet verified/complete.
- Identity bearer token/refresh flow must be tested after API container restart before production use. Do not claim production readiness.
- Production requires HTTPS, protected secrets, persistent Data Protection keys, backup/restore testing, monitoring, approved MFA/recovery policy and a complete authorization matrix.
- No inventory, pharmacy transactions, contracting transactions, financial posting or legal-entity editing is enabled by this change.

## Verification

Run:

    bash scripts/smoke-test.sh

The smoke test checks API/database readiness, anonymous API denial, disabled public registration, web availability and protected-route redirects. It does not prove successful account sign-in, refresh/revocation, MFA, mobile authentication, authorization scopes or production hardening.
