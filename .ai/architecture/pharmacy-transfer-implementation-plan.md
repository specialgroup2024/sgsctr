# Pharmacy stock-transfer implementation plan

- Status: **Ready for technical review; business/accounting approvals outstanding**
- Delivery approach: incremental, test-first, no production posting before approval.
- Related: [domain model](pharmacy-transfer-domain-model.md), [API contract](pharmacy-transfer-api-contract.md), [persistence design](pharmacy-transfer-persistence-design.md), [workflow](../domain/pharmacy-stock-transfer-workflow.md), [acceptance criteria](../quality/pharmacy-stock-transfer-acceptance.md).

## 1. Repository baseline

At the time of this plan, the repository is documentation-focused: root `AGENTS.md`, `.ai` governance documents and a minimal README were inspected. No application solution, API project, EF Core model, migration set or automated test project was identified in the files inspected. This is not a claim that no other repository files exist; confirm the full tree before implementation.

## 2. Work packages

| ID | Work package | Deliverables | Exit condition |
|---|---|---|---|
| PT-00 | Baseline and decisions | Full repo inventory; pinned SDK/toolchain; architecture decision | Existing code/data and conventions understood |
| PT-01 | Business sign-off | Approved lifecycle, location register, roles, custody, exceptions | Named owner and operations approval recorded |
| PT-02 | Accounting sign-off | Costing examples, in-transit treatment, reconciliation, period close | Accountant approval recorded |
| PT-03 | Technical foundation | .NET solution, module boundaries, config, health, logging, API versioning | Build and baseline tests pass |
| PT-04 | Reference data | Legal entity, sector, locations, items, units and lots | Validated seed/import and authorization tests |
| PT-05 | Transfer request | Draft, lines, submit, read/list, validation | AT-01 to AT-04 domain/API tests pass |
| PT-06 | Approval and picking | Approve/reject, pick, role policy and audit | Policy and separation tests pass |
| PT-07 | Dispatch/in-transit | Atomic stock movement, idempotency, concurrency | AT-05, AT-14, AT-16, AT-17 pass on PostgreSQL |
| PT-08 | Receipt/discrepancy/return | Partial receipt, exception and return movements | AT-07 to AT-09, AT-15, AT-18 pass |
| PT-09 | Security/observability | Access scopes, audit, safe logs, metrics | AT-10 to AT-13, AT-19 to AT-21 pass |
| PT-10 | Pilot and release | UAT, reconciliation, backup/restore, runbooks | Signed UAT and release gate |

## 3. Recommended implementation order

1. Inventory the repository completely and preserve existing files/data.
2. Confirm .NET SDK, PostgreSQL and React Native versions; pin versions in repo.
3. Establish solution structure and CI build/test workflow before feature code.
4. Implement domain types and pure state-transition tests before persistence.
5. Implement PostgreSQL schema and EF Core mapping only after PT-01/PT-02 and PT-04 decisions.
6. Implement application commands and server-side authorization.
7. Implement API endpoints and OpenAPI contract tests.
8. Add real-PostgreSQL integration tests for atomicity, idempotency and concurrency.
9. Build a non-posting internal prototype and run operations UAT.
10. Enable stock posting only after all approval, reconciliation, security and release gates are met.

## 4. Suggested solution layout

```text
src/
  Sgsctr.Api/
  Modules/
    Pharmacy/
      Domain/
      Application/
      Infrastructure/
      Contracts/
    Identity/
    Shared/
tests/
  Sgsctr.Pharmacy.UnitTests/
  Sgsctr.Pharmacy.IntegrationTests/
  Sgsctr.Api.Tests/
docs/
  runbooks/
```

This is a proposed layout, not an existing repository structure. Keep module internals private; expose use-case interfaces rather than cross-module table access. Do not create placeholder projects until baseline inventory and version choices are confirmed.

## 5. Quality gates

- Unit tests: state machine, quantity rules, lot policy, transition authorization.
- Integration tests: PostgreSQL constraints, transaction rollback, concurrent dispatch, partial receipt, idempotency.
- API tests: authentication, location scope, authorization denial, validation and error semantics.
- Security: least privilege, secret scanning, dependency scanning, log redaction and audit integrity.
- Operational: health/readiness, structured logs, correlation, backup/restore and reconciliation report.
- Migration: review generated SQL; test upgrade from representative existing data; rollback or forward-fix plan documented.
- CI: format, build, unit/integration tests, analyzers and security checks; report actual run results only.

## 6. Release gates

No production stock posting until:
- Legal entity and pharmacy location register are verified.
- Pharmacy operations approves workflow, custody, roles, limits and exceptions.
- Accountant approves weighted-average costing, in-transit valuation, returns, discrepancies and reconciliation.
- Automated acceptance tests pass on the supported PostgreSQL version.
- Security review and backup/restore test pass.
- Named users complete UAT with opening/closing stock reconciliation.
- Business owner signs release approval.

## 7. Immediate next actions

1. Perform complete repository tree and code inventory; confirm whether any application code or data migrations already exist.
2. Ask operations/accountant to review the proposed documents; keep unresolved decisions explicit.
3. Pin supported runtime/database/tool versions after checking current repository and deployment constraints.
4. Only then create the backend solution and CI skeleton on a separate implementation branch.

Do not infer approvals from document creation or enable live inventory changes before release gates are satisfied.
