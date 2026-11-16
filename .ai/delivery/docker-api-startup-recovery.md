# Docker API startup-crash recovery

Status: diagnostic and recovery procedure; the root cause of the reported crash is not yet established.
Scope: local Docker Compose development stack only. This document does not claim the owner's VM was accessed or repaired.

## Observed incident evidence — owner supplied 2026-11-16

- `docker compose ps -a`: `sgsctr-api` is `Restarting (139)`; `sgsctr-db` is `Up (healthy)`; `sgsctr-web` is `Created`.
- The Compose service key is `api`; `sgsctr-api` is its container_name. Use `docker compose logs api`, not `docker compose logs sgsctr-api`.
- `docker inspect`: `OOMKilled=false`, process exit code `139`, process path `dotnet`, argument `Sgsctr.Api.dll`.
- Docker health state is `unhealthy` with no health-check log entries. This is secondary while the process repeatedly terminates.
- PostgreSQL's container health check passes. This proves the server accepts readiness probes, not that API credentials, schema or migrations are correct.
- Owner-provided Compose rendering showed API health checks `http://127.0.0.1:8080/health/ready`; web depends on `api: service_healthy`.
- The owner previously reported a .NET startup log mentioning `libgssapi_krb5.so.2` and an earlier EF migration duplicate-index error. Neither is established as the cause of this specific exit-139 event.

## Dynamic role selection and deliberation

Selected profiles for this incident:
- Architect: .NET container/runtime and Linux platform architect — establish process, image and native dependency boundaries.
- Devil's Advocate: container security / SRE failure analyst — challenge premature package installation, health-check masking and destructive database "fixes".
- Clueless Client: local developer/operator — prioritize one reproducible recovery path and preserve working PostgreSQL data.
- SME: .NET runtime, Linux ABI/native-library and EF Core/PostgreSQL migration specialist — distinguish SIGSEGV from managed exceptions and database failures.
- Maestro: senior platform engineering authority — select evidence-led diagnostic sequence; no VM access or independent human review is claimed. These are simulated analytical perspectives, not independent agents or qualified human reviewers.

Architect proposal: diagnose the exact process crash inside the built image, then make only the evidence-supported Dockerfile/runtime or application correction. Keep web gated on real API readiness.

Devil's Advocate challenge: installing GSSAPI libraries merely because an older log mentioned one could hide the actual defect, add unnecessary attack surface, and leave a native segmentation fault unresolved. Disabling health checks or removing the web dependency would mask failure rather than fix it.

Clueless Client challenge: asking the operator to repeatedly rebuild or reinstall host .NET does not help when the application runs inside Docker. Diagnostic commands must use the Compose service key `api`, avoid secrets in output, and preserve named volumes.

SME analysis: exit code 139 conventionally indicates SIGSEGV (signal 11), but does not identify the crashing native component. `OOMKilled=false` argues against Docker reporting an OOM kill. A managed exception normally produces application logs and a non-zero managed process exit, but native runtime/interop faults can terminate before useful logs. PostgreSQL health and API process health are separate. An EF migration failure remains a possible startup defect only if logs show migration execution before the crash.

Architect response and retest: collect container logs, image OS/architecture, .NET runtime details, native dependency resolution and application startup sequence before editing. Test the selected correction with a clean image build, container startup, readiness, web startup and smoke test. Never remove the database or Data Protection volumes.

Maestro determination: **diagnostic-first; no speculative Dockerfile package change**. The repository currently uses .NET 10 SDK and ASP.NET runtime images, and installs `curl` in the runtime stage for the health check. The prior missing-library log is a lead, not sufficient evidence to add a package. Correct the Dockerfile/runtime only after the failing library or incompatible binary is identified. If no native dependency fault is found, investigate the application startup path and EF migration state separately.

## Safe diagnostic sequence on the owner's Linux VM

Run from the repository root. These commands do not remove or reset named volumes.

1. Confirm service and container state:
   ```bash
   docker compose ps -a
   docker inspect sgsctr-api --format 'OOMKilled={{.State.OOMKilled}} ExitCode={{.State.ExitCode}} StartedAt={{.State.StartedAt}} FinishedAt={{.State.FinishedAt}}'
   ```

2. Capture complete recent API output (Compose service name is `api`):
   ```bash
   docker compose logs --no-color --timestamps --tail=300 api
   docker logs --timestamps --tail=300 sgsctr-api
   ```
   Redact connection strings, tokens, email addresses and personal data before sharing.

3. Inspect image OS, architecture, runtime and native loader:
   ```bash
   docker image inspect sgsctr-api --format 'OS={{.Os}} Architecture={{.Architecture}}'
   uname -m
   docker compose run --rm --no-deps --entrypoint sh api -c '
     cat /etc/os-release
     dotnet --info
     command -v dotnet
     ldd "$(command -v dotnet)" || true
     (ldconfig -p 2>/dev/null || true) | grep -Ei "gssapi|krb5" || true
   '
   ```
   If the temporary container cannot start, record that fact and inspect the image metadata; do not infer a missing package from that alone.

4. If logs indicate a native crash but do not identify it, collect a core dump or run a controlled diagnostic image with suitable native tracing/debugging tools. Do not add debugging packages to the production runtime stage merely for convenience. Preserve the exact image digest and logs.

5. If logs show an EF migration/model-parity failure, inspect migration history and PostgreSQL schema read-only before proposing a forward-only repair. Never drop an index/table or edit migration history blindly. Back up the database before any approved schema repair.

   The migration-history query below is ordinary SQL and preserves PostgreSQL's case-sensitive EF column names:
   \`\`\`bash
   docker compose exec db sh -lc '
     psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" \
       -c "SELECT \"MigrationId\", \"ProductVersion\"
           FROM public.\"__EFMigrationsHistory\"
           ORDER BY \"MigrationId\";"
   '
   \`\`\`

   To inspect the history table's columns, use \`information_schema\` SQL:
   \`\`\`bash
   docker compose exec db sh -lc '
     psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" \
       -c "SELECT column_name, data_type
           FROM information_schema.columns
           WHERE table_schema = 'public'
             AND table_name = '__EFMigrationsHistory'
           ORDER BY ordinal_position;"
   '
   \`\`\`
   Do not pass psql's interactive \`\d\` meta-command through nested \`sh -lc '...'\` quoting as though it were SQL; quoting can strip the backslash and PostgreSQL then reports a syntax error near \`d\`. The information_schema query above avoids that ambiguity.

   To inspect actual indexes without changing the database:
   \`\`\`sql
   SELECT schemaname, tablename, indexname, indexdef
   FROM pg_indexes
   WHERE schemaname = 'public'
   ORDER BY tablename, indexname;
   \`\`\`

## Evidence-based correction decision table

| Finding | Required correction |
|---|---|
| Missing native library, proven by loader/error evidence | Install the matching runtime package in the API runtime image; verify package name against the image's actual OS release and architecture; rebuild and retest. |
| Native .NET/runtime crash | Align SDK/runtime image versions and architecture; identify incompatible native dependency/interop; fix the specific incompatibility. |
| EF Core migration/schema mismatch | Reconcile migration history, model snapshot and actual PostgreSQL schema; use a reviewed forward-only migration where needed; backup and verify data preservation. |
| ASP.NET Core application startup defect | Correct the responsible startup/hosted-service/configuration code; add a regression test. |
| Build/runtime architecture mismatch | Align Docker build platform, published binaries and runtime architecture; verify image metadata and host architecture. |
| Health-check-only defect after API process is stable | Correct the health-check command/path/timeout; do not weaken readiness or make web start against an unhealthy API. |

Do not apply multiple speculative fixes together: each correction must identify the failing layer and have a regression check.

## Required recovery and acceptance checks

After the evidence-supported change is reviewed and committed, on the owner's VM:

```bash
docker compose build --no-cache api
docker compose up -d api
docker compose ps -a
docker compose logs --tail=200 api
curl --fail --silent --show-error http://127.0.0.1:8080/health/live
curl --fail --silent --show-error http://127.0.0.1:8080/health/ready
docker compose up -d web
docker compose ps -a
bash scripts/smoke-test.sh
```

Acceptance requires:
- API remains running (no restart loop) and its container health is healthy.
- `/health/live` returns HTTP 200.
- `/health/ready` returns HTTP 200 and reports database, application context and identity context connected.
- Web starts only after API readiness and can reach the API through internal Compose DNS (`api:8080`).
- The full repository smoke test passes.
- Existing PostgreSQL records and named volumes are preserved; any migration is backed up and verified.
- Exact commit, image digest, commands, outputs and environment are recorded. A GitHub CI pass is not a substitute for owner-VM verification.

## Credentials exposed in diagnostic output

The owner pasted a rendered Compose configuration containing database, bootstrap administrator and pgAdmin credentials. Treat all exposed values as compromised:
- Rotate the PostgreSQL role password and update the local `.env` and dependent services consistently.
- Rotate the bootstrap administrator password through the supported account-management path; do not assume changing the bootstrap environment variable changes an existing account.
- Rotate the pgAdmin password using its supported account-management path; do not assume changing its environment variable resets an existing persisted account.
- Generate a new high-entropy `AUTH_SESSION_SECRET`; account for session invalidation.
- Keep values in the ignored local `.env` or a secret manager. Never commit them, paste them into issues/logs, or print the rendered Compose configuration unredacted.
- Verify `.env` is ignored by Git and scan the repository history for accidental committed secrets. If a secret was committed, revoke/rotate it; history rewriting is a separate controlled operation.

## Non-negotiable data safety

- Never run `docker compose down -v`, `docker volume rm`, `docker system prune --volumes`, or delete PostgreSQL/Data Protection volumes as a crash workaround.
- Do not drop PostgreSQL indexes/tables or edit `__EFMigrationsHistory` to force startup.
- Do not disable the API health check or remove web's `service_healthy` dependency to make the dashboard appear available.
- Do not claim the incident is fixed until the owner supplies successful runtime evidence from the VM.
