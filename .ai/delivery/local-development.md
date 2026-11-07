# Local development and test runbook

- Status: initial local foundation instructions.
- Branch: `phase-1-local-foundation`.
- Scope: API process, PostgreSQL connectivity and basic smoke test only.

## Prerequisites

Linux workstation with Git, Docker Engine and Docker Compose v2. Optional:
.NET SDK 10.0.403 for running the API directly from the host.

## Start

```bash
git clone https://github.com/specialgroup2024/sgsctr.git
cd sgsctr
git checkout phase-1-local-foundation
cp .env.example .env
docker compose up --build -d
docker compose ps
```

## Verify

```bash
bash scripts/smoke-test.sh
curl -i http://localhost:8080/health/live
curl -i http://localhost:8080/health/ready
curl -i http://localhost:8080/api/v1/system/info
```

Expected:
- Liveness returns HTTP 200 with status `ok`.
- Readiness returns HTTP 200 with database `reachable`.
- System info returns HTTP 200 and `businessModulesEnabled: false`.

## Troubleshooting

```bash
docker compose logs --tail=100 api
docker compose logs --tail=100 db
docker compose ps
```

If port 8080 is occupied, stop the conflicting service or change the host-side
port mapping in `compose.yaml`. If PostgreSQL port 5433 is occupied, change
only the host-side mapping; the API container continues using `db:5432`.

If downloads fail, check DNS/outbound access and retry
`docker compose build --no-cache api`.

## Stop and reset

```bash
docker compose down
```

Destructive local reset (removes the development database volume):

```bash
docker compose down --volumes
```

## Phase boundary

No application migrations, pharmacy inventory tables, stock movements,
contracting workflows, claims, patient data, costing or financial postings
are included. A successful health check is not a business acceptance test or
production-readiness approval.
