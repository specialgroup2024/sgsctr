# Testing strategy

Status: proposed; refine after Phase 0 and architecture validation.

## Test layers
- Unit: domain policies and validation, using approved examples only.
- Integration: PostgreSQL constraints, transactions, migrations and module persistence.
- Architecture: module dependency rules and prohibition of direct cross-module writes.
- API/contract: authorization, validation, idempotency, error contracts and versioning.
- End-to-end: approved user workflows with synthetic data.
- Security/privacy: role isolation, least privilege, sensitive-data redaction and audit access.
- Operational: backup restore, migration rollback where supported, retry and recovery behavior.

## Financial and inventory test controls
- Each numeric assertion must reference a signed-off worked example and policy/agreement version.
- Include currency, precision, rounding, effective date and approved calculation sequence.
- Test reversals, adjustments, duplicates, retries, concurrency and period boundaries.
- Reconcile inventory movements, valuation and ledger outputs independently.
- Keep payer receivables separate from patient balances and collections.
- Never use production patient or customer data in test fixtures.

## Phase 0 restriction
Scenario outlines in phase-0-example-test-cases.md are not executable financial specifications. Do not implement or assert numeric results until the relevant owner/professional approves the examples.
