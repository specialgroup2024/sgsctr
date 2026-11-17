# Deployment architecture and environments

Status: development guidance based on repository configuration. Production topology, hosting region and security settings are not approved here.

## Current shape
- Repository contains ASP.NET Core 10 API, PostgreSQL 18 Compose service and Next.js web application.
- pgAdmin is optional local administration, not an application dependency.
- API connects to PostgreSQL; browser/mobile clients use application APIs, never database connections.
- React Native is the mobile direction; no mobile app deployment is evidenced.
- Inspect Compose, Dockerfiles, env files and health checks before changing topology.

## Local development
- Use Compose for repeatable API/database/web startup.
- Keep PostgreSQL internal; its host development port remains loopback-only.
- Publish only the Next.js web UI on the VM LAN interface when LAN testing is required; default host port is 3000 and can be restricted with WEB_BIND_ADDRESS=127.0.0.1.
- Keep API, PostgreSQL and pgAdmin host ports loopback-only. Never expose pgAdmin or the database publicly.
- LAN testing requires WEB_BASE_URL to match the exact browser origin and a host/hypervisor firewall rule limited to the trusted subnet. This development HTTP topology is not a production ingress pattern.
- Use synthetic data. Production/patient data requires explicit authorization and safeguards.
- Keep secrets in untracked env files or secret manager; commit placeholder examples only.

## CI
- Build clean checkout with pinned SDK/runtime/dependencies.
- Run format, build, unit/integration tests, EF parity/migration checks, documentation integrity and security scans as configured.
- Use ephemeral databases and synthetic data; redact logs/artifacts.
- A workflow failing before runner allocation is Blocked/Not Run, not a test failure or pass.

## Production controls (proposed, not release authorization)
- Hardened PostgreSQL, private networking, encryption, least-privilege roles and tested backups/restores.
- Controlled TLS ingress, HTTPS, secure cookies, managed secrets and restricted/rotated data-protection keys.
- Separate web/API/worker identities and network permissions.
- Define health checks, logs, metrics, traces, alerts and incident owner.
- Agree RPO/RTO, retention, data residency, privacy and disaster recovery before hosting selection.
- Never expose database/admin ports publicly.

## Operations
- Fail closed on missing production secrets or unsafe settings. Development auth bypass is forbidden in staging/production.
- Liveness and readiness are distinct; readiness reports API and DB dependencies separately without connection details.
- Run migrations as a controlled release step; prevent concurrent replica migration races.
- Use graceful shutdown and bounded retries. Record commit, image digest, config and migration versions.

## Related
[System context](system-context.md) · [Local development](../delivery/local-development.md) · [Release](../delivery/release-and-rollback.md)
