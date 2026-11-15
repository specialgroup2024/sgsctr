# Governance test-readiness workspace

- Status: implementation proposed on branch `feat/governance-test-readiness-workspace`; not yet merged or deployed.
- Scope: PostgreSQL-backed test case catalogue and append-only Development test execution records for platform foundation and all seven Pharmacy Inventory approval gates.
- Authority: owner-authorized staged Pharmacy Inventory development. This work does not approve business rules, professional decisions, security risk or production release.

## Operating boundary

- The central approval register remains authoritative. Test execution is a separate record and never changes an approval status.
- A test can be marked Passed only with an evidence reference. Failed and Blocked results require notes.
- Cases blocked by a missing professional approval or unimplemented workflow cannot be marked Passed or Failed.
- Test-result writes are limited to an authenticated Administrator in the Development environment. No production write route is enabled.
- Results are append-only; a correction is a new execution, not an overwrite.
- The supplied pharmacist examples remain reference/demo-only. The real INV-PRO-001 status remains Pending.
- No user accounts, professional identities, qualifications, licence numbers, legal interpretations or approvals are fabricated.

## Coverage

- Platform foundation: API liveness, PostgreSQL readiness through AppDbContext and AuthDbContext, web health reporting, additive migration and preserved approval state.
- INV-PRO-001: demo separation is testable; genuine pharmacist verification and regulated pharmacy workflows are blocked.
- INV-REG-001: current Egyptian primary-source/site/product applicability and evidence provenance require qualified review.
- INV-QLT-001: inspection, storage, deviations, quarantine and recall require approved quality controls.
- INV-ACC-001: moving weighted-average, transfer/return/adjustment/tax worked examples require accountant approval.
- INV-OWN-002: supplier, purchasing, receiving, authority, separation-of-duties and opening-stock policies require owner decisions.
- INV-SEC-001: authentication/authorization and Data Protection/restore tests remain blocked under the owner's prior explicit hold and pending role/security decisions.
- INV-REL-001: regression, migration, recovery and release authorization remain blocked until all applicable gates close.

## Test execution API and UI

- UI: Pharmacy Inventory → Test readiness.
- Read API: `GET /api/v1/pharmacy/catalogue/test-readiness`.
- Development-only write API: `POST /api/v1/pharmacy/catalogue/test-readiness/executions`, Administrator role required.
- BFF routes require an existing authenticated web session and preserve the bearer-token boundary.
- PostgreSQL stores test definitions and append-only executions. No files are uploaded; evidence is referenced by a controlled ID/CI URL.
- The initial seed has 19 cases: 4 platform, 3 pharmacist, 2 regulatory, 2 quality, 2 accounting, 2 owner, 2 security and 2 release cases.

## Deployment and verification

- Apply the additive EF migration through the existing Development API startup migration process.
- Verify `/health/ready`, the readiness API count and the Inventory Test readiness tab.
- Use a development Administrator session to record platform checks with real CI/VM evidence references.
- Do not run the held authentication or Data Protection checks until the owner explicitly reopens them.
- Do not reset PostgreSQL volumes, delete data, mark approval gates approved or release production as part of this work.
