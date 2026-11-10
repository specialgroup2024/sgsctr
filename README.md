# Special Group — Contracting and Pharmacies Platform

This repository contains the technical foundation and governed design for the
Special Group Pharmacies and Specialized Contracting platform.

## Current build

- ASP.NET Core 10 API and PostgreSQL 18 development database.
- Next.js 15 web foundation with a responsive local dashboard.
- Live API/database connection status in the dashboard.
- Docker Compose local environment with pgAdmin database administration and CI smoke tests.

The UI is a development overview and known pharmacy location register. The migration branch introduces ASP.NET Core Identity and native email/password sign-in. It is not merged or runtime-verified yet. The application does not implement stock balances, stock transfers, contracting workflows, claims, patient data or financial posting.

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
