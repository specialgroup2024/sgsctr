# INV-B technical acceptance work package

- Status: **blocked — technical acceptance not established**; PR #66 is merged, but both PR-triggered workflows and their reruns failed before any job steps were reported.
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
| .NET restore/build/test | All succeed | Not evidenced — workflow job failed before steps; no executable acceptance result |
| Supplier unit tests | All pass | Not evidenced — workflow job failed before steps; no executable acceptance result |
| EF Core AppDbContext snapshot parity | No pending model changes | Not evidenced — workflow job failed before steps; no executable acceptance result |
| PostgreSQL migration | Fresh CI database migrates successfully | Not evidenced — workflow job failed before steps; no executable acceptance result |
| API authorization and lifecycle | All positive/negative cases pass | Not evidenced — workflow job failed before steps; no executable acceptance result |
| Audit persistence | Supplier, evidence, review and audit rows verified | Not evidenced — workflow job failed before steps; no executable acceptance result |
| BFF session/origin behavior | Authenticated same-origin succeeds; missing Origin rejected | Not evidenced — workflow job failed before steps; no executable acceptance result |
| UI | Supplier tab and guardrails render in English/Arabic on desktop/mobile | Not evidenced — workflow job failed before steps; no executable acceptance result |
| Production readiness | Separate security, professional and release gates approved | Blocked |

## CI execution blocker

PR #63 was merged by the repository owner. Its GitHub Actions jobs failed before runner assignment (`runner_id: 0`), with empty step lists and no downloadable logs; the rerun produced the same result. No build, test, migration, API, database, BFF or browser command is evidenced as having started. The failure is an infrastructure/runner blocker, not evidence that the code passed or that a code assertion failed. PR #64 separately fixed the duplicate `Evidence type` and `Expires on` translation keys and was also merged by the owner (master merge commit `f92b9bb4d18ddf76a3f9d63570e61dec0e2f479c`). The duplicate-key source scan passed, but TypeScript/Docker build and browser checks remain unverified. The Markdown files changed in this work package are each below 200 lines, but the repository-wide line-limit script was not executed.

## Release boundary

Passing CI can establish technical behavior for this draft slice only. It cannot approve supplier qualification, legal identity/licensing criteria, due diligence, reviewer authority, purchasing policy or production release. Q51, INV-OWN-002, INV-SEC-001 and INV-REL-001 remain pending in the central approval register.


## PR #66 — supplier draft onboarding intake

PR #66 was merged to master on 2026-11-15 (merge commit `ed7a99eb49329e766c1b500db4febfb79e3df0bf`; head `2671e92854cfe3862bc6126775d98aae55f2adc6`). It adds the owner-approved INV-OWN-003 non-operative intake slice. The `build-and-smoke-test` and `markdown-line-limit` workflow runs both failed; both failed jobs were rerun, and both reruns also failed before reporting any steps. The job step lists are null and log download returned 404. No .NET/web build, unit test, EF snapshot/migration validation, PostgreSQL integration, API authorization, BFF or browser command is evidenced as having executed. The failure is an execution/runner evidence blocker, not a demonstrated code assertion failure and not a pass. PR #66 has no submitted reviews or discussion comments in the live connector response. No production or VM migration is authorized.

## 2026-11-26 — evidence traceability and receipt draft observations

A bounded follow-up was implemented on branch `feat/supplier-evidence-receipt-observations-2026-11-26`:

- Supplier assurance requests now select an evidence reference already belonging to the selected supplier; the assurance list resolves the linked evidence title from that supplier's evidence collection. The API continues to validate supplier/evidence ownership and does not interpret or verify the evidence.
- Receipt drafts now support append-only observation/discrepancy notes through the existing audit-event store. Notes are scoped to a receipt draft, record actor/time/correlation, and are visible in the receiving workspace.
- The observation endpoints require the existing Administrator/local-development write policy. They do not change receipt status, line quantities, stock balances, stock movements, supplier eligibility, acceptance, rejection, quarantine or quality release. No schema migration is introduced.
- English/Arabic labels and boundary messaging were added for the UI.

**Not yet technically accepted:** no .NET build/test, TypeScript typecheck, Next.js build, EF model check, PostgreSQL integration, API/BFF authorization test, browser test or owner-VM runtime test has been run for this branch. The CI and runtime states must be recorded from actual results before merge/release claims. Existing INV-B technical acceptance and production/security/professional gates remain unchanged.

## 2026-11-26 — owner VM UI-02 feedback and correction

The owner reported both supplier assurance and receiving observation acceptance as **Failed**, with the specific feedback: "No UI found \"saved\"." This is a browser-level failure report, not evidence of API/database persistence failure or success.

Source inspection identified discoverability and confirmation defects:
- Supplier assurance is nested inside a selected supplier detail. The UI did not explain the required sequence from creating/selecting a supplier to reaching the assurance form and locating the saved request.
- Receiving observations are available only after a receipt draft exists and the user opens **View / add notes** in the recent-drafts table. The prerequisite and sequence were not prominent.
- The receiving observation reload helper caught its own GET errors. The POST handler could therefore display success even when the follow-up read failed.

A focused correction is proposed on branch `fix/ui02-save-discoverability-2026-11-26`: add bilingual step-by-step workflow guidance, show the observation confirmation beside the observation form, and propagate observation reload failures so success is displayed only after the saved observations are fetched again.

**Acceptance remains Failed / pending retest.** No claim is made that the changes compile, pass CI, work on the owner's VM, or establish persistence. UI-03 remains blocked. Supplier qualification, evidence verification, goods acceptance, stock effects and financial posting remain outside this work package.

