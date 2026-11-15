# INV-B technical acceptance — dynamic deliberation

- Task: harden the merged supplier draft register and produce repeatable acceptance evidence.
- Date: 2026-11-15.
- Repository base: master after PR #62 merge; implementation branch: `fix/invb-technical-acceptance`.
- Scope: test coverage, audit-actor safety, CI workflow and supplier UI checks. No qualification or purchasing behavior.
- Evidence: supplier entities, EF mapping/migration/snapshot, API, BFF, UI, unit tests, workflow and smoke-test scripts inspected.

| Stable role | Selected profile | Challenge / contribution |
|---|---|---|
| Architect | .NET/PostgreSQL application architect | Add authenticated API lifecycle tests, BFF same-origin tests, database persistence/audit checks, and English/Arabic UI coverage. |
| Devil's Advocate | Application security and database integrity reviewer | Reject accepting an authenticated write when no stable subject claim exists; the old fallback wrote misleading `unknown-subject` audit records. Require fail-closed behavior and a non-admin negative test. |
| Clueless Client | Pharmacy procurement clerk / owner-operator perspective | Reject a test suite that proves endpoints work but leaves the screen ambiguous; verify that the supplier tab clearly labels records Draft and evidence Unverified in both languages. |
| SME | QA automation and PostgreSQL/EF Core test engineer | Check constraints, filtered unique pending-review index, transactional audit writes, duplicate handling, date validation, authorization and migration/snapshot parity. |
| Maestro | Senior technical delivery and reliability architect | Determination: proceed with additive test hardening and fail-closed audit attribution. Do not claim acceptance until GitHub checks execute all steps and pass. |

## Deliberation and revision

- Initial proposal: rely on existing unit tests, EF snapshot check and general application smoke tests.
- Devil's Advocate rejection: general smoke tests do not exercise supplier APIs; CI explicitly sets `SKIP_AUTHENTICATION_SMOKE_TESTS=true`. A write with no subject claim is attributed to `unknown-subject`, weakening audit accountability.
- Clueless Client rejection: supplier register UI was not included in the Playwright route/tab assertions, so a passing generic RTL check would not show that staff can find the supplier directory or understand its Draft-only boundary.
- SME analysis: supplier database mapping includes Draft-only, Unverified-only and Pending-only constraints; supplier code is unique; one pending review per supplier is protected by a filtered unique index. Migration and model snapshot both include these mappings. Source inspection is not proof of PostgreSQL execution.
- Architect revision: add authenticated create/detail/evidence/review tests, duplicate and invalid-date negative cases, non-admin write denial, BFF session/origin tests, database row/audit assertions, supplier tab checks in EN/AR and fail-closed audit subject handling.
- Retesting required: shell syntax, .NET build/tests, migration/snapshot parity, PostgreSQL startup/migration, API/BFF checks and browser checks must execute in CI.
- Maestro determination: technically stronger test coverage is authorized. Technical acceptance remains pending until a full green CI run and evidence review.

## Approval boundary

- Owner authorization: INV-OWN-001 permits staged implementation, subject to gates.
- Still pending: Q51 / INV-OWN-002 supplier qualification and operating policy; INV-SEC-001 security review/residual-risk acceptance; INV-REL-001 controlled production release.
- Disabled: supplier qualification/approval, legal or licence verification, purchasing eligibility, receipt linkage, supplier transmission, payment, stock posting and GL posting.
- No VM/production migration or deployment is authorized by this task.
