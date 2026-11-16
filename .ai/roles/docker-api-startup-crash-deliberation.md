# Docker API startup-crash — role deliberation

Date: 2026-11-16
Status: technical determination for diagnosis; root cause unknown.

## Context and evidence
Owner reports Docker Compose API restarts with exit code 139, OOMKilled=false, PostgreSQL healthy and web not started because it depends on API health. The service key is `api`; container name is `sgsctr-api`. Runtime image uses .NET 10 ASP.NET runtime; Dockerfile installs curl for readiness health checks. An older owner-supplied log mentioned `libgssapi_krb5.so.2`; an earlier migration failure mentioned duplicate `IX_RegulatoryDocuments_SourceId`. Neither is proven to cause this current SIGSEGV.

## Dynamically selected profiles
- Architect — .NET container/runtime and Linux platform architect.
- Devil's Advocate — container security and SRE failure analyst.
- Clueless Client — local developer/operator.
- SME — .NET runtime, Linux ABI/native-library and EF Core/PostgreSQL migration specialist.
- Maestro — senior platform engineering authority.
These perspectives are simulated in one model; they are not independent agents or qualified human reviews.

## Debate and retesting
- Architect: inspect exact image/runtime and application startup; correct only the demonstrated failing layer.
- Devil's Advocate: rejected speculative GSSAPI installation, health-check bypass and database reset; these can conceal the fault or add risk without explaining SIGSEGV.
- Clueless Client: rejected host-level .NET installation as a first response because application execution is containerized; require commands using Compose service `api` and preserve database data.
- SME: exit 139 is consistent with SIGSEGV but does not identify its source. OOMKilled=false makes an OOM kill less likely. Native dependency/interop, runtime incompatibility and startup code remain candidates. Migration failure is only implicated if current logs show it.
- Architect response: collect timestamped logs, image OS/architecture, `dotnet --info`, native loader output and migration evidence before editing. Then apply one isolated correction and rerun API/readiness/web/smoke checks.
- Retest: no VM access, diagnostic output or runtime test is available to this repository change; root cause and fix remain unverified.

## Maestro determination
Use the diagnostic-first recovery runbook at [docker-api-startup-recovery.md](../delivery/docker-api-startup-recovery.md). Do not alter Dockerfile packages, runtime versions, migrations or health-check semantics until evidence identifies the failing layer. Keep web dependent on API readiness. Preserve PostgreSQL and Data Protection volumes.

## Acceptance and approval boundary
Acceptance: stable API process; healthy API container; HTTP 200 liveness and readiness with both EF contexts connected; web starts and reaches `api:8080`; smoke test passes; database data and named volumes remain intact. Record owner-VM evidence separately from CI evidence.

No owner approval is required to perform non-destructive diagnostics. A source-code/Dockerfile correction within local development scope may be proposed after evidence. Any database schema repair requires backup and reviewed forward-only migration. Production deployment, destructive data operations and release remain separately gated. Security review of credential exposure/rotation is required; do not place secrets in this record.
