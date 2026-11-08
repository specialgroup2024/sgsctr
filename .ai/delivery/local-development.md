# Local development and test runbook

- Status: API, PostgreSQL and Next.js local foundation.
- Branch: `phase-2-nextjs-ui`.
- Scope: responsive development dashboard and live API/database connectivity only.

## Prerequisites

Linux workstation with Git, Docker Engine and Docker Compose v2. Internet access
is needed for first image/package downloads.

## Start

For a fresh clone:

    git clone https://github.com/specialgroup2024/sgsctr.git
    cd sgsctr
    git checkout phase-2-nextjs-ui
    cp .env.example .env
    docker compose up --build -d

If the repository is already cloned, run from its root:

    git fetch origin
    git checkout phase-2-nextjs-ui
    cp -n .env.example .env
    docker compose up --build -d

## Open the application

- Web UI: http://localhost:3000
- API root: http://localhost:8080/
- API liveness: http://localhost:8080/health/live
- API/database readiness: http://localhost:8080/health/ready
- API system information: http://localhost:8080/api/v1/system/info

The dashboard polls its server-side status endpoint every 15 seconds. The
Next.js container reaches the API using the internal Docker address
http://api:8080. The browser does not connect directly to PostgreSQL.

## Verify

    docker compose ps
    bash scripts/smoke-test.sh http://localhost:8080 http://localhost:3000

Expected: db is healthy, api and web are running, API readiness reports the
database reachable, and the web page contains the Special Group dashboard.

## Troubleshooting

    docker compose logs --tail=100 web
    docker compose logs --tail=100 api
    docker compose logs --tail=100 db

If port 3000 is occupied, change only the host-side mapping in compose.yaml
(for example, 3001:3000) and open http://localhost:3001. If API port 8080 or
PostgreSQL port 5433 is occupied, change only its host-side mapping; internal
container communication remains api:8080 and db:5432.

If a frontend build fails, capture the complete output from
docker compose build --no-cache web.

## Stop and reset

    docker compose down

Destructive local reset (removes the development database volume and its test data):

    docker compose down --volumes

## Phase boundary

The dashboard is a read-only foundation. No authentication, business migrations,
pharmacy inventory tables, stock movements, contracting workflows, claims,
patient data, costing or financial postings are implemented. Do not infer
business acceptance or production readiness from a successful health check.
