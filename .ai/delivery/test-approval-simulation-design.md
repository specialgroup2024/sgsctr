# Approval workflow simulator — technical design proposal

- Status: **Proposed; discovery/design authorized, application implementation awaits design acceptance.**
- Date: 2026-11-15.
- Scope: non-operative testing of approval workflow paths using synthetic data only.
- Related foundation: [Governance test-readiness workspace](governance-test-readiness-workspace.md) and the authoritative [approval register](../governance/approval-register.md).

## 1. Verified repository baseline

- `GovernanceApprovals` is the authoritative PostgreSQL approval register; its API is read-only.
- The approval API exposes no decision-write endpoint.
- Historical `DemoApproved` migrations were corrected by PR #47; the real INV-PRO-001 gate remains Pending.
- `PharmacistReviewExamples.tsx` and its source document hold illustrative examples separately from `GovernanceApprovals`.
- `GovernanceTestReadinessEndpoints` stores append-only test executions. Writes are Development-only and Administrator-role restricted; approval-blocked cases cannot be marked Passed or Failed.
- The current test-readiness UI records test outcomes, not simulated approval workflow transitions.
- Source files verified on master: `src/Sgsctr.Api/PharmacyCatalogue/GovernanceApprovalEndpoints.cs`, `GovernanceTestReadinessEndpoints.cs`, `GovernanceTestReadinessRules.cs`, `web/app/pharmacies/inventory/TestReadiness.tsx`, and `PharmacistReviewExamples.tsx`.

## 2. Goal and non-goals

**Goal:** let authorized developers/testers walk through generic approval workflow scenarios and verify labels, transitions, exception handling and user comprehension without creating a genuine approval.

**Non-goals:** changing business approval policy; approving suppliers, products, pharmacy procedures or transactions; creating reviewer accounts/credentials; simulating legal or professional evidence as genuine; changing any `GovernanceApprovals` row; enabling PO, receiving, stock, accounting or other operational actions.

## 3. Recommended architecture

Add a separate **Approval Workflow Simulator** entry within the Development test workspace. It is a test harness, not an approval-register feature.

- Use deterministic, hard-coded synthetic scenarios and synthetic actor identifiers such as `TEST-REVIEWER-01`; never use real people, employee accounts, licence numbers or production evidence.
- Keep scenario state in component memory only. Refresh/reset discards it. No localStorage, cookies, API writes, database tables, EF migration, audit approval event or external integration.
- Keep it visually and navigationally separate from **Approvals** and **Test readiness**.
- Gate the server-rendered route with an explicit opt-in feature flag (default false) and a server-side Development-environment check. Fail closed if either condition is absent. Hiding a client-side button alone is insufficient.
- Do not add a production API endpoint. Existing approval API remains read-only.
- Add component/state-machine tests proving that simulation does not call approval, supplier, purchasing, receiving, stock or finance APIs.
- Use the existing Test Readiness workspace to record actual test execution evidence (CI/test report references) separately; a simulated scenario result is not test evidence by itself.

## 4. Scenario catalogue

These are generic software test paths, not approved business rules:

| Scenario | Simulator-only outcome | What the tester verifies |
|---|---|---|
| Normal approval | `SimulatedApproved` | Status display and next-step UI remain simulation-only |
| Rejection | `SimulatedRejected` | Rejection reason is displayed without changing a real record |
| Conditional path | `SimulatedConditional` | Conditions are visible and do not become operational controls |
| Delegation path | `SimulatedDelegated` | Synthetic delegate path is shown; no role or authority is granted |
| Emergency path | `SimulatedEmergencyOverride` | Exception path is demonstrated; no override is applied to a real transaction |
| Pending / expiry | `Pending` / `SimulatedExpired` | Waiting, timeout and re-review screens are testable |
| Cancel / reset | `SimulatedCancelled` / reset | Scenario state is discarded and cannot leak into the approval register |

Do not infer approval limits, expiry periods, escalation SLAs, required evidence or business decision criteria. Scenario text must say that these are illustrative software paths pending business-policy approval.

## 5. Mandatory safety invariants

1. Every screen and result carries the persistent label **SIMULATION ONLY — NOT A REAL APPROVAL**.
2. Every simulated state uses a distinct `Simulated*` value; never serialize it as `Approved`, `Rejected` or a real gate status.
3. The authoritative approval register and API remain unchanged and read-only.
4. No simulated actor is a real user, professional, reviewer or approver; no impersonation or credential fabrication.
5. No downstream command, permission, purchasing/receiving eligibility, stock movement, valuation or financial posting can be triggered.
6. No scenario data is persisted, exported as approval evidence, or mixed with real audit records.
7. The feature is unavailable by default and outside Development.
8. The simulator must not display real patient, employee, supplier or customer information.

## 6. Security and privacy

- Server-side Development + explicit feature-flag checks; default deny.
- No authorization decision is made by the simulator and no user role is elevated.
- Do not accept user-supplied names, licence numbers, evidence URLs or arbitrary payloads in the initial increment.
- Keep scenario definitions in reviewed source code; use bounded, fixed templates.
- Add negative tests for production environment, missing/false flag, anonymous access where authentication is active, and attempts to invoke operational APIs.
- Any future persistence, shared test accounts, user-supplied data, API-backed transitions or evidence upload requires a new security/privacy review and design approval.

## 7. Acceptance criteria

- Development route is inaccessible unless both the explicit feature flag and Development environment are confirmed server-side.
- UI is clearly separate from Approvals and Test readiness and displays the warning on every simulator screen.
- All scenario outcomes are prefixed `Simulated` and cannot be mapped to real approval enums.
- Reload/reset clears all scenario state.
- Tests prove no request/write reaches approval, supplier, PO, receiving, inventory, accounting or finance endpoints.
- Approval API response and `GovernanceApprovals` remain unchanged throughout tests.
- EN/AR labels and RTL behavior are covered.
- No migration, persistent test-approval record, production route or release is introduced.

## 8. Approval gates and delivery sequence

| Gate | Required decision | Status |
|---|---|---|
| Owner scope | Discovery/design for a non-operative synthetic simulator only | Authorized by this request; recorded as TEST-OWN-001 |
| Technical design | Accept route gating, in-memory-only state and no side effects | **Pending owner confirmation** |
| Security review | Review server-side exposure, feature-flag handling and test isolation | Required before implementation merge |
| Domain/professional review | Not required for generic UI simulation while no domain rules or real evidence are encoded; required if scope expands | Conditional |
| Implementation | Separate branch/PR, component tests, route-gate tests and bilingual checks | Not started |
| Production release | Not authorized; simulator must remain Development-only | Not authorized |

## 9. Alternatives considered

- **Insert fake rows in `GovernanceApprovals`: rejected.** This recreates the historical false-approval defect and risks operational misinterpretation.
- **Persist simulation rows in the application database:** rejected for the first increment; separation and retention create unnecessary risk.
- **Client-side visibility toggle only:** rejected; it is not a security boundary.
- **Separate Development-only, in-memory test harness:** recommended; smallest attack surface and no database or operational side effects.

## 10. Rollback

Remove the simulator route/component and its tests/translation keys; no data cleanup or migration rollback is required because the design adds no persisted data. Keep the real approval register untouched.
