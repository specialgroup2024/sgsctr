# INV-B technical acceptance work package

- Status: **blocked — technical acceptance not established**; PR #63 is merged, but the required checks did not execute.
- Date: 2026-11-15.
- Base: master after PR #62 merge commit `74970b4ffdb968c95388c4d0fe4e9aab6102c543`.
- Work branch: `fix/invb-technical-acceptance`.
- Scope: automated acceptance, fail-closed audit attribution and bilingual supplier UI verification.
- No supplier qualification, licence verification, purchasing/receipt eligibility, stock/GL posting, VM migration or production deployment is included.

## Dynamically selected perspectives

See [INV-B technical acceptance deliberation](../roles/invb-technical-acceptance-deliberation.md). The selected profiles are simulated analytical perspectives, not independent agents or qualified professional approvals.

## Changes on this branch

- Extend authenticated API smoke tests for supplier creation, detail, duplicate-code rejection, evidence capture, expiry-date validation, pending review creation, duplicate pending-review rejection and queue visibility.
- Verify anonymous supplier API access is rejected and non-Administrator writes are forbidden.
- Verify supplier BFF authenticated reads, same-origin write enforcement and Draft-only response.
- Verify supplier/evidence/review rows and their three audit events are persisted in PostgreSQL in CI.
- Add the supplier tab and Draft/unverified boundary to English and Arabic Playwright checks.
- Expand supplier input boundary unit tests.
- Fail closed if an authenticated supplier write has no stable subject claim; do not write an `unknown-subject` audit actor.
- Remove the CI setting that skipped authenticated smoke tests.

## Acceptance evidence required

| Check | Required result | Status |
|---|---|---|
| .NET restore/build/test | All succeed | Blocked before runner execution |
| Supplier unit tests | All pass | Blocked before runner execution |
| EF Core AppDbContext snapshot parity | No pending model changes | Blocked before runner execution |
| PostgreSQL migration | Fresh CI database migrates successfully | Blocked before runner execution |
| API authorization and lifecycle | All positive/negative cases pass | Blocked before runner execution |
| Audit persistence | Supplier, evidence, review and audit rows verified | Blocked before runner execution |
| BFF session/origin behavior | Authenticated same-origin succeeds; missing Origin rejected | Blocked before runner execution |
| UI | Supplier tab and guardrails render in English/Arabic on desktop/mobile | Blocked before runner execution |
| Production readiness | Separate security, professional and release gates approved | Blocked |

## CI execution blocker

PR #63 was merged by the repository owner. Its GitHub Actions jobs failed before runner assignment (`runner_id: 0`), with empty step lists and no downloadable logs; the rerun produced the same result. No build, test, migration, API, database, BFF or browser command is evidenced as having started. The failure is an infrastructure/runner blocker, not evidence that the code passed or that a code assertion failed. PR #64 separately fixed the duplicate `Evidence type` and `Expires on` translation keys and was also merged by the owner (master merge commit `f92b9bb4d18ddf76a3f9d63570e61dec0e2f479c`). The duplicate-key source scan passed, but TypeScript/Docker build and browser checks remain unverified. The Markdown files changed in this work package are each below 200 lines, but the repository-wide line-limit script was not executed.

## Release boundary

Passing CI can establish technical behavior for this draft slice only. It cannot approve supplier qualification, legal identity/licensing criteria, due diligence, reviewer authority, purchasing policy or production release. Q51, INV-OWN-002, INV-SEC-001 and INV-REL-001 remain pending in the central approval register.


## PR #66 — supplier draft onboarding intake

PR #66 adds the owner-approved INV-OWN-003 non-operative intake slice on branch feat/invb-supplier-draft-onboarding-intake. The build-and-smoke-test and markdown-line-limit checks failed immediately with no executed steps or downloadable logs. No application build, unit tests, EF snapshot/migration validation, PostgreSQL integration, API authorization, BFF or browser command is evidenced as having started. Treat the failure as a CI runner/execution blocker; technical acceptance remains unverified. The PR is open and unmerged. No production or VM migration is authorized.
