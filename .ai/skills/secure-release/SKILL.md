---
name: secure-release
description: Prepare or verify secure builds, deployment, observability, backup, recovery, release and rollback for SGSCTR.
---

# Workflow
1. Confirm approved scope, target environment, release owner and approval-register gates.
2. Inspect CI workflows, Docker/Compose files, configuration, secret sources, dependencies and migration sequence.
3. Threat-model build artifacts, supply chain, credentials, exposed ports, data protection and operational access.
4. Verify API and database readiness separately; do not treat process liveness as database readiness.
5. Define backup/restore evidence, migration recovery, monitoring, alerting, incident ownership and rollback triggers.
6. Run relevant build, tests, dependency/security checks and deployment smoke checks in the authorized environment.
7. Record exact commit, environment, commands, outputs, failures, rollback decision and approvals.

# Guardrails
- Never put secrets or production records in Git or logs.
- Do not deploy, migrate production, change network exposure or perform destructive actions without explicit authorization.
- Distinguish CI results from owner-VM and production runtime evidence.
- Do not claim release readiness while required approvals, restore tests or critical checks are missing.

# References
See delivery/definition-of-done.md, delivery/release-and-rollback.md, security/backup-and-recovery.md and governance/approval-register.md.
