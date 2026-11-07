# Special Group — Contracting and Pharmacies Platform

This repository contains the technical foundation and governed design for the
Special Group Pharmacies and Specialized Contracting platform.

## Current build

Phase 1 foundation: ASP.NET Core 10 API, PostgreSQL 18 development database,
EF Core/Npgsql connectivity, health/readiness endpoints and a container smoke test.

No pharmacy stock-transfer, contracting, claims, patient-balance or financial
posting features are enabled.

## Prerequisites

Linux workstation with Git, Docker Engine and Docker Compose v2. Internet access
is needed for the first image/package downloads. Optional: .NET SDK 10.0.403
for running the API directly from the host.

## Start locally

```bash
git clone https://github.com/specialgroup2024/sgsctr.git
cd sgsctr
git checkout phase-1-local-foundation
cp .env.example .env
docker compose up --build -d
```

Check status and logs:

```bash
docker compose ps
docker compose logs -f api
```

Run the smoke test:

```bash
bash scripts/smoke-test.sh
```

Open:
- API root: http://localhost:8080/
- Liveness: http://localhost:8080/health/live
- Database readiness: http://localhost:8080/health/ready
- System information: http://localhost:8080/api/v1/system/info

PostgreSQL is published on localhost port 5433 to reduce conflicts with a
local PostgreSQL service. Database settings are in the ignored local `.env`.

## Stop

```bash
docker compose down
```

To also delete the local development database volume and its test data:

```bash
docker compose down --volumes
```

## Run API from the .NET SDK

Start PostgreSQL with `docker compose up -d db`, then:

```bash
export ConnectionStrings__DefaultConnection='Host=localhost;Port=5433;Database=sgsctr_dev;Username=sgsctr;Password=local_dev_only_change_me'
dotnet run --project src/Sgsctr.Api
```

## Safety and scope

- `.env` is local-only and ignored by Git. Never commit real passwords.
- Compose credentials are for local testing, not production.
- EF Core context is intentionally empty; no business schema or migration exists.
- Readiness verifies database connectivity, not business correctness or production readiness.
- Review `.ai/architecture` and `.ai/delivery/roadmap.md` before feature work.
