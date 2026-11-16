# Memory state-update protocol

Purpose: prevent stale, contradictory and repetitive one-off corrections in SGSCTR project memory.

## Canonical evidence order
1. Current repository tree, source code, migrations, tests and configuration establish what is present in the inspected commit.
2. CI/workflow run details and inspectable logs establish what actually executed and passed.
3. Owner-provided runtime output establishes only the observed environment, timestamp and scope; it is not independent repository evidence.
4. The approval register and linked decision records establish approval status. A merge, test result or agent recommendation never changes approval.
5. Curated project facts and current-state summarize the above; memory never overrides primary evidence.

## Update rules
- Update the canonical document that owns the fact. Do not create a new standalone note for every correction.
- Keep current-state as a concise, dated snapshot with links to detailed delivery/acceptance/incident records.
- Keep historical changes in the append-only memory/change-log.md. Never silently rewrite historical entries.
- Add a change-log entry only for material changes to implementation, validation, approvals, runtime observations or project governance.
- Each entry records date/time, repository commit/PR or runtime source, exact scope, status dimensions, evidence, what remains unknown and the canonical document updated.
- Correct a stale summary by updating its current value and adding a superseding change-log entry; retain the earlier event in history.
- Do not duplicate long incident logs, test output, PR descriptions or approval tables inside memory.
- Distinguish implementation, technical validation, business approval, professional approval and release authorization as separate statuses.
- Record owner-provided facts as owner-provided until documentary or independent evidence verifies them.
- Use explicit dates and immutable commit/run identifiers. Avoid relative terms such as "latest" without a timestamp.
- Never store credentials, patient records, personal data or raw production exports.

## Review cadence
Reconcile current-state after a material merge, release, failed verification, owner decision or runtime incident. For routine edits, update the owning document only. Periodically check for stale PR references, duplicated status claims, missing evidence links and approval-state contradictions.
