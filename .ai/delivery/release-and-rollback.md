# Release and rollback

Status: controlled guidance, not production authorization. INV-REL-001 and all applicable professional approvals remain authoritative.

## Pre-release gate
1. Record commit, environment, scope, owner and release authority.
2. Verify every required approval is Approved for this exact scope and remains valid.
3. Confirm technical acceptance: build, tests, migration/model parity, security checks, docs checks and inspectable CI logs.
4. Missing runner, logs, skipped command or unexecuted check is Blocked/Not Run. Merge is not test evidence.
5. Review migration SQL, compatibility, locks, backfill, constraints and irreversible changes.
6. Verify encrypted backup and appropriate restore rehearsal; record backup ID and recovery owner.
7. Prepare deploy, smoke tests, monitoring, communications and rollback/forward-fix.
8. Confirm TLS, secrets, access controls, audit and production configuration; disable development bypasses.
9. For regulated, pharmacy, supplier or finance workflows, verify professional sign-offs and keep gated actions disabled until approved.

## Deployment
- Apply compatible, approved schema changes before dependent application rollout.
- Use one controlled migration executor; deploy API/workers with bounded concurrency.
- Deploy clients after compatible API behavior is available.
- Smoke-test liveness/readiness, API/DB, authentication, authorization denial, critical journeys and audit events.
- Monitor errors, latency, DB health, queue lag and security alerts; record observation window.
- Record commit, artifact digests, migration/config versions, operator and timestamps.

## Rollback
- Authorized release owner decides rollback; stop on health, integrity, security or critical acceptance failure.
- Prefer application rollback only when previous code is schema-compatible.
- Do not automatically reverse database migrations after data changes. Prefer tested forward-fix.
- Restore backup only with explicit authorization, known data-loss window and reconciliation plan.
- Never delete/rewrite financial, inventory, audit or regulatory history.
- Feature flags may disable behavior only if designed, tested and approved.

## After release
Verify health, journeys, authorization, audit and reconciliation. Record incidents and corrective actions. Update current-state only after evidence inspection. Deployment success never changes approval status.

## Evidence
Record release ID, commit, environment, approvals, CI run/results, artifact digests, backup/restore, migration review, operator, timestamps, smoke tests, monitoring, incidents and approver.

[Approval register](../governance/approval-register.md) · [Definition of done](definition-of-done.md) · [Deployment](../architecture/deployment.md)
