# INV-04 stock transfer request continuation deliberation

- Date: 2026-11-17. Branch: `feat/inv04-stock-transfer-requests` (commits `5c184f2`, `3497632`).
- Trigger: owner's direct master commits `44a4ad8 phase02`, `304529c phase INV03 execute`, `78b39f7 INV-04-01` started the INV-04 transfer slice (entity, model configuration, pure rules) but stopped before persistence, API and tests.
- Proportionality note: this is a reversible, non-posting continuation of an already owner-established pattern (INV-03), so a full live transcript was unnecessary; this concise record applies the five challenge stages and does not claim independent agents or human professionals participated.
- Selected lenses: .NET API architecture; PostgreSQL/EF Core migrations; pharmacy inventory operations; fail-closed security review; delivery verification.

## Evidence inspected
- `src/Sgsctr.Api/Data/StockTransferRequest.cs`, `Data/AppDbContext.cs` lines 423–467, `PharmacyInventory/StockTransferRequestRules.cs` (owner's INV-04-01 code).
- INV-03 reference pattern: `PharmacyStockMovementExtensions.cs`, migration `20261117123041_20261117120000_StockMovementLedger`.
- Task profile: transfer workflow, domain model, API contract, persistence design, acceptance criteria, technical design.
- Approval register: INV-OWN-001/INV-OWN-004 authorize staged non-posting implementation; Q12/Q13, Q53, security and release gates remain pending.

## Proposal and challenges
- Architect: complete INV-04 with an additive migration, Draft-only endpoints, Program wiring and rule tests, mirroring INV-03; no posting, dispatch, receipt or BFF/UI in this slice.
- Devil's Advocate: the owner's state machine was incomplete — `Submitted` could never reach `PendingApproval`, making Approve/Reject unreachable except by arbitrary status writes; also, model/snapshot parity was broken (`has-pending-model-changes` would fail), so any `dotnet ef` operation would stall or mislead. Both were substantiated by source inspection.
- Clueless Client: an operator cannot use endpoints that exist only in a proposal document; endpoint shapes must match the implemented INV-03 conventions (`/api/v1/pharmacy/inventory/...`, ValidationProblem errors, local Development write fallback), not the aspirational contract routes.
- SME: EF scaffolding (not hand-editing) keeps the snapshot authoritative; nullable FK addition to `StockMovements` is safe for existing rows; approve-time Draft `TransferOut`/`TransferIn` pairs match the owner's entity doc comment and keep balances unaffected because balances read `Posted` rows only.
- Architect response: added `CanSendForApproval` (Submitted → PendingApproval) instead of inventing alternate flows; kept every transition an explicit command; separation of duties (requester ≠ approver/rejecter) enforced fail-closed; `AreLocationsDistinct` added as a domain rule so AT-04 is testable at the domain layer.
- Maestro determination: proceed with the minimal additive slice; do not add the DB-level same-location check constraint or BFF/UI now (owner's reviewed model config is authoritative; INV-03 had no BFF/UI); report parity and SDK-pin discrepancies rather than silently rewriting canonical docs.

## Outcome and residual risks
- Implemented: migration `20261117140845_PharmacyStockTransferRequests` (additive; not applied to any database), endpoints (create/list/detail/submit/send-for-approval/approve/reject/cancel), rule completions, 43 new rule tests.
- Verified locally: build 0 errors; tests 155/155; `has-pending-model-changes` clean.
- Residual risks: no PostgreSQL integration/concurrency/idempotency tests exist (no harness in the repo); approve-created draft movements are unposted by design; approval-lifecycle policy (who may approve, thresholds) is not configurable until the role matrix is approved.
- Approvals still required: Q12/Q13 costing and procedures, Q53 transfer lifecycle, security review, release gates. This record changes no approval status.
- Review trigger: owner review of the branch, or any new evidence about posting, eligibility or role-matrix decisions.
