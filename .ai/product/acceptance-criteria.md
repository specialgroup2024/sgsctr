# Product and technical acceptance

Acceptance is layered. Technical success does not grant business, legal, pharmacy, accounting, security-risk or production approval.

## Universal criteria
- Scope is owner-authorized with exclusions; requirements, assumptions, dependencies and risks are recorded.
- UI, API and persistence agree. Draft/prototype states are not presented as operational.
- Server-side authorization denies unauthorized users and scopes resources by approved entity/sector/location.
- Validation covers missing, invalid, boundary, duplicate, stale and conflicting inputs.
- State transitions are explicit, auditable and fail closed.
- Sensitive data/secrets are absent from UI errors, logs, tests and docs.
- English/Arabic states are tested where affected, including root lang/dir and mixed-direction values.
- Tests cover positive/negative behavior, persistence, concurrency and relevant integrations.
- ADRs, open questions, current state and generated context metadata are reconciled.

## Technical acceptance
Record exact commit/environment, commands, tool versions, totals, failures, skips, CI run IDs and inspectable logs. All applicable checks pass or an approved exception records scope, owner and expiry.

Runner never starts, missing logs, skipped test or unexecuted command = Blocked/Not Run, not Passed. PR merge is not acceptance evidence.

## Domain acceptance
- Pharmacy: qualified pharmacist/operations and quality review; verified product/site classification; approved receipt, lot/expiry, storage, recall, transfer, costing and exception policies; separation-of-duties tests and reconciliation. Draft catalogue/pending records do not satisfy operational acceptance.
- Contracting: owner approval of project/contract states, commercial calculations, procurement/subcontractor controls, variations, billing, retention and project-cost rules; accountant approval for postings.
- Finance: accountant/tax approval of legal entity, accounts, dimensions, currency, precision, rounding, tax, costing, posting, close and reconciliation, with worked examples.
- Identity: approved role/permission matrix, positive/negative authorization, account lifecycle, session/security, audit and sector/location boundary tests.

## Release acceptance
Production requires INV-REL-001, applicable professional/owner/security approvals, backup/restore, migration rehearsal, deployment plan, health checks, monitoring and explicit release authorization.

## Separate status fields
Implementation: Not started / In progress / Implemented / Removed.
Technical validation: Not run / Blocked / Failed / Passed.
Business approval: Pending / Approved / Rejected / Withdrawn.
Professional approval: Pending / Approved / Rejected / Not applicable with reason.
Release: Not authorized / Authorized / Released / Rolled back.

Never collapse these dimensions into Done or Approved.
