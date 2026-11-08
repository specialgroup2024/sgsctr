# Special Group — Contracting and Pharmacies Platform

This repository contains the technical foundation and governed design for the
Special Group Pharmacies and Specialized Contracting platform.

## Current build

- ASP.NET Core 10 API and PostgreSQL 18 development database.
- Next.js 15 web foundation with a responsive local dashboard.
- Live API/database connection status in the dashboard.
- Docker Compose local environment and CI smoke tests.

The UI is a development overview and known pharmacy location register. It does
not implement authentication, stock balances, stock transfers, contracting
workflows, claims, patient data or financial posting.

## Prerequisites

Linux workstation with Git, Docker Engine and Docker Compose v2. Internet access
is needed for first image/package downloads.

## Start locally

Run these commands in a terminal:

    git clone https://github.com/specialgroup2024/sgsctr.git
    cd sgsctr
    git checkout phase-2-nextjs-ui
    cp .env.example .env
    docker compose up --build -d

Open the web application at http://localhost:3000.

Backend endpoints:
- API root: http://localhost:8080/
- Liveness: http://localhost:8080/health/live
- Database readiness: http://localhost:8080/health/ready
- System information: http://localhost:8080/api/v1/system/info

Check status and logs with docker compose ps and docker compose logs -f web.
Run the API smoke test with bash scripts/smoke-test.sh.

The web dashboard checks the API through a Next.js server route. The browser
does not connect directly to PostgreSQL or require permissive API CORS rules.
PostgreSQL is published on localhost port 5433. Database settings are in the
ignored local .env file.

## Run frontend outside Docker (optional)

    cd web
    npm install
    npm run dev

The development server runs at http://localhost:3000. Set API_BASE_URL to
http://localhost:8080 if the API is running on the host.

## Stop

    docker compose down

To also delete the local development database volume and its test data:

    docker compose down --volumes

## Safety and scope

- .env is local-only and ignored by Git. Never commit real passwords.
- Compose credentials are for local testing, not production.
- EF Core context is intentionally empty; no business schema or migration exists.
- The dashboard contains no fabricated stock or financial figures.
- Readiness verifies database connectivity, not business correctness or production readiness.
- Business workflow and accounting approvals remain required before stock-changing features.
