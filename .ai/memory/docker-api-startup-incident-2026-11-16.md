# Docker API startup incident — 2026-11-16

Status: open; root cause unknown; no repair or VM access claimed.

## Owner-provided runtime evidence
- Compose reports `sgsctr-api` restarting with exit code 139.
- Inspect output: `OOMKilled=false`; process path `dotnet`; arguments `Sgsctr.Api.dll`.
- `sgsctr-db` is reported healthy.
- `sgsctr-web` remains Created because Compose requires API `service_healthy`.
- Compose service key is `api`, explaining why `docker compose logs sgsctr-api` returned "no such service".
- API health inspect reports unhealthy with no health-check log entries.
- Rendered Compose output showed Development environment, automatic migrations enabled, API readiness URL on port 8080 and web dependency on API health. Credentials were present in the output but are deliberately not repeated here.

## Interpretation
Exit code 139 is consistent with SIGSEGV, not a diagnosis of its source. OOMKilled=false makes a Docker-reported OOM kill less likely. PostgreSQL's container health check does not prove API authentication, schema or migration success. The API's failed process startup is primary; web not starting is expected dependency behavior.

An earlier owner-provided log mentioned `libgssapi_krb5.so.2`; a prior migration incident mentioned duplicate index `IX_RegulatoryDocuments_SourceId`. Neither is evidence that the same condition caused this later crash.

## Repository evidence
- `compose.yaml`: API service key `api`; web depends on `api` with `condition: service_healthy`; API health check calls `/health/ready`.
- `Dockerfile`: .NET 10 SDK build stage and ASP.NET 10 runtime stage; runtime installs `curl` for the health check.
- `README.md` and `.ai/delivery/local-development.md`: expected local endpoints and smoke-test procedure.
- `scripts/smoke-test.sh`: verifies liveness, readiness, database/application/identity contexts and web-to-API status.

## Decision
Follow [Docker API startup-crash recovery](../delivery/docker-api-startup-recovery.md). No speculative package installation, runtime downgrade, migration-history edit, health-check bypass, web dependency removal or volume deletion is authorized by this incident record.

## Next evidence required
Timestamped API logs; image OS/architecture; host architecture; container `dotnet --info`; native loader output; and evidence of whether EF migrations begin before the process terminates. After an evidence-supported correction, obtain owner-VM proof for API stable/healthy, HTTP 200 liveness/readiness, web startup, smoke-test pass and preserved database records.

## Security follow-up
The owner pasted rendered Compose output containing credentials. Treat the exposed values as compromised and rotate them through the appropriate database/account/session mechanisms. Store replacements in ignored local `.env` or a secret manager. Do not repeat secrets in repository memory, issues, commits or logs.
