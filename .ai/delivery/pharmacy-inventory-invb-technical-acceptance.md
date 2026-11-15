# INV-B technical acceptance work package

- Status: **in progress — not technically accepted**.
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
| .NET restore/build/test | All succeed | Pending CI |
| Supplier unit tests | All pass | Pending CI |
| EF Core AppDbContext snapshot parity | No pending model changes | Pending CI |
| PostgreSQL migration | Fresh CI database migrates successfully | Pending CI |
| API authorization and lifecycle | All positive/negative cases pass | Pending CI |
| Audit persistence | Supplier, evidence, review and audit rows verified | Pending CI |
| BFF session/origin behavior | Authenticated same-origin succeeds; missing Origin rejected | Pending CI |
| UI | Supplier tab and guardrails render in English/Arabic on desktop/mobile | Pending CI |
| Production readiness | Separate security, professional and release gates approved | Blocked |

## Release boundary

Passing CI can establish technical behavior for this draft slice only. It cannot approve supplier qualification, legal identity/licensing criteria, due diligence, reviewer authority, purchasing policy or production release. Q51, INV-OWN-002, INV-SEC-001 and INV-REL-001 remain pending in the central approval register.
