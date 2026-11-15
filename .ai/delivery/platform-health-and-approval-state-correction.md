# Platform health and pharmacist approval correction

- Date: 2026-11-15.
- Scope: correct approval migration history and make API/PostgreSQL health visible and startup ordering explicit.
- Authority: within staged Pharmacy Inventory development authorization INV-OWN-001; no professional approval or production release is implied.

## Evidence and root causes

1. PRs #43 and #45 introduced AppDbContext migrations that add `DemoApproved` to the approval status constraint and can set `INV-PRO-001` to that synthetic state.
2. PR #44 removed the demo status from the UI/application model but did not add a forward migration to reverse already-applied database changes.
3. `AppDbContextModelSnapshot.cs` still listed `DemoApproved`, while `AppDbContext` excludes it. Latest CI built successfully and passed 27 API tests but failed the AppDbContext EF snapshot check.
4. Compose previously started web when API was merely started, not when API readiness and both PostgreSQL contexts were healthy.
5. The web system-status route treated any non-2xx liveness response as API unreachable and skipped database readiness details whenever liveness was not 2xx.

## Correction

- PR #47 merged migration `20261115120000_RemovePharmacistApprovalDemo`: only a row with `ApprovalCode=INV-PRO-001` and `Status=DemoApproved` is restored to Pending; synthetic decision metadata is cleared; the database constraint no longer permits DemoApproved.
- PR #47 updated the EF snapshot to match the application model. Historical migrations remain intact.
- PR #47 installed curl in the API runtime image and added a Compose healthcheck against `/health/ready`, which verifies AppDbContext and AuthDbContext PostgreSQL connectivity.
- PR #47 makes web wait for API `service_healthy`, not merely `service_started`.
- PR #47 reports API liveness separately from database readiness, including HTTP status codes. Smoke tests require API and readiness HTTP 200 and database connected.

## Inventory boundary preserved

- INV-01 generic product, unit and conversion records remain Draft-only.
- INV-02 family, identifier, evidence and lifecycle records remain proposals/pending review.
- No supplier, purchasing, receiving, stock, lot, transfer, dispensing, claims, costing or financial posting capability is enabled.
- `INV-PRO-001` remains Pending. Owner-supplied demo examples remain in their separate reference document/UI only.
- Real authentication verification and Data Protection volume verification remain on hold per prior owner instruction.

## Verification required

- CI: .NET build/tests, EF snapshot checks, Docker startup, API readiness, web `/api/system-status`, authenticated approval API and UI smoke tests.
- Local VM: rebuild API/web images, inspect API health and logs, verify `/health/live`, `/health/ready`, web `/api/system-status`, and confirm persisted INV-PRO-001 is Pending.
- No PostgreSQL volume reset, database recreation, manual SQL or destructive migration is required.
- This repository change cannot update or inspect the owner's running VM. Do not claim runtime recovery until the owner performs deployment/verification and supplies results.
