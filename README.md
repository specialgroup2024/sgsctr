# Special Group — Contracting and Pharmacies Platform

This repository contains the technical foundation and governed design for the
Special Group Pharmacies and Specialized Contracting platform.

## Current build

- ASP.NET Core 10 API and PostgreSQL 18 development database.
- Next.js 15 web foundation with a responsive local dashboard.
- Live API/database connection status in the dashboard.
- Docker Compose local environment with pgAdmin database administration and CI smoke tests.
- ASP.NET Core Data Protection key ring persisted in a dedicated Docker volume; production requires certificate-based key encryption.

The UI is a development overview and known pharmacy location register. The application uses ASP.NET Core Identity for sign-in. It is not a production business system yet: stock balances, stock transfers, contracting workflows, claims, patient data and financial posting are not implemented.

## Prerequisites

Linux workstation with Git, Docker Engine and Docker Compose v2. Internet access
is needed for first image/package downloads.

## Start locally

Run these commands in a terminal:

    git clone https://github.com/specialgroup2024/sgsctr.git
    cd sgsctr
    cp .env.example .env

Edit the local `.env` file before starting the stack. Keep the file private and
set PGADMIN_DEFAULT_PASSWORD, BOOTSTRAP_ADMIN_EMAIL, BOOTSTRAP_ADMIN_PASSWORD and AUTH_SESSION_SECRET. Use unique strong values. The bootstrap administrator is created only if that email does not already exist. Do not commit .env or share credentials.

Then run:

    docker compose up --build -d

Open the web application at http://localhost:3000.

Sign in at http://localhost:3000 with the bootstrap administrator account configured in .env. No external identity service or public registration is used.

Open pgAdmin at http://localhost:5051 and sign in with the email and password
configured in `.env`. To connect to PostgreSQL from pgAdmin, register a server
with these connection values:
- Name: SGSCTR Local
- Host name/address: `db`
- Port: `5432`
- Maintenance database: the `POSTGRES_DB` value (default: `sgsctr_dev`)
- Username: the `POSTGRES_USER` value (default: `sgsctr`)
- Password: the `POSTGRES_PASSWORD` value in `.env`

Use `db` as the host because pgAdmin runs inside the Compose network. The
pgAdmin web port is bound to `127.0.0.1` so it is not exposed to other machines.

Backend endpoints:
- API root: http://localhost:8080/
- Liveness: http://localhost:8080/health/live
- Database readiness: http://localhost:8080/health/ready
- System information: http://localhost:8080/api/v1/system/info
- Authenticated identity diagnostic: http://localhost:8080/api/v1/auth/me (requires an application Identity bearer token)

Check status and logs with:

    docker compose ps
    docker compose logs -f web
    docker compose logs -f pgadmin

Run the API smoke test with:

    bash scripts/smoke-test.sh

The web dashboard checks the API through a Next.js server route. The browser
does not connect directly to PostgreSQL or require permissive API CORS rules.
PostgreSQL is published on localhost port 5433. Database settings are in the
ignored local .env file.

## ASP.NET Core Data Protection key persistence

The API stores its key ring at
`/var/lib/sgsctr/data-protection-keys`, backed by the dedicated
`sgsctr_dataprotection_keys` Docker named volume. This survives ordinary API
container recreation and image replacement. The Docker image creates the
directory with permissions for its non-root application user.

The local Development environment persists keys but does not encrypt the key
ring at rest; ASP.NET Core may therefore continue to log the XML-encryptor
warning. This is deliberately not represented as production-secure.

Before replacing the currently running API container for the first
deployment of this change, preserve its existing ephemeral key ring if you
need to avoid invalidating active protected sessions/tokens. Run these commands
from the repository directory while the current API container is still running:

    mkdir -p "$HOME/sgsctr-dataprotection-backup"
    docker cp sgsctr-api:/home/app/.aspnet/DataProtection-Keys/. "$HOME/sgsctr-dataprotection-backup/"
    docker volume create sgsctr_dataprotection_keys
    docker run --rm -v sgsctr_dataprotection_keys:/target -v "$HOME/sgsctr-dataprotection-backup:/source:ro" alpine:3.20 sh -c 'cp -an /source/. /target/ && chown -R 1654:1654 /target'

If the source directory is absent, stop and inspect the current API key-ring
location rather than proceeding with an empty backup. Keep the backup private;
it contains security-sensitive key material. Remove the backup only after
confirming the API starts and existing protected sessions behave as expected.

Before deploying with `ASPNETCORE_ENVIRONMENT=Production`:
1. Provision a private X.509 certificate with an accessible private key.
2. Mount the PFX file read-only into the API container using the deployment
   platform's secret mechanism.
3. Supply `DataProtection__CertificatePath` and
   `DataProtection__CertificatePassword` as protected runtime secrets.
4. Keep the certificate/private key backed up and stable across deployments.
5. Do not place the PFX or its password in Git, the Docker image, or a plain
   committed Compose file.

The API intentionally refuses to start in non-Development environments if
certificate-based key encryption is not configured. Back up the Data
Protection volume and certificate together; losing either can invalidate
existing protected authentication/session data. Do not delete the volume as
part of routine troubleshooting.

## Frontend package installation and Docker DNS troubleshooting

The web image installs packages from the public npm registry during its
dependency stage. The Dockerfile retries short-lived registry failures and
uses a bounded request timeout. An error such as
`EAI_AGAIN registry.npmjs.org` means the build container could not resolve
the registry hostname; it is a DNS/network problem, not evidence that the
named npm package is missing.

If the build still fails:

1. Check DNS and HTTPS access from the host:

       getent hosts registry.npmjs.org
       curl -I --max-time 15 https://registry.npmjs.org/

2. If host resolution works but Docker builds cannot resolve names, configure
   working DNS servers for the Docker daemon in
   `/etc/docker/daemon.json` (merge with existing settings; do not overwrite
   other daemon options), for example:

       {
         "dns": ["1.1.1.1", "8.8.8.8"]
       }

   Then restart Docker:

       sudo systemctl restart docker

   Use DNS servers permitted by your network/ISP or organization. Public DNS
   addresses may be blocked on managed networks.

3. Retry only the web image first, then start the stack:

       docker compose build --no-cache web
       docker compose up -d

If the host command in step 1 also fails, repair the host's DNS, proxy, VPN, or
internet connection before rebuilding. Repeated Docker builds cannot fix an
unavailable registry connection.

## Run frontend outside Docker (optional)

    cd web
    npm install
    npm run dev

The development server runs at http://localhost:3000. Set API_BASE_URL to
http://localhost:8080 if the API is running on the host.

## Stop

    docker compose down

Do not use docker compose down --volumes on an environment containing data you need to preserve.

## Safety and scope

- `.env` is local-only and ignored by Git. Never commit real passwords.
- pgAdmin is intended for local development; do not expose it publicly without appropriate security controls.
- Compose credentials are for local testing, not production.
- Identity records are stored in the additive identity schema; existing business/reference records remain separate.
- The dashboard contains no fabricated stock or financial figures.
- Readiness verifies database connectivity, not business correctness or production readiness.
- Business workflow and accounting approvals remain required before stock-changing features.


## Docker API startup troubleshooting

If the API container restarts or Docker reports it unhealthy, follow the evidence-led [Docker API startup-crash recovery runbook](.ai/delivery/docker-api-startup-recovery.md). Use the Compose service name `api` for logs (`docker compose logs api`). Do not remove named volumes, reset PostgreSQL, or bypass the API readiness dependency as a workaround.
