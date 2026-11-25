# Curated project change log

Append-only record of material repository/governance state changes. Detailed evidence remains in the linked canonical records.

## 2026-11-17 — INV-03/INV-04 PostgreSQL integration evidence and test harness
- Repository event: commits on branch `feat/inv04-stock-transfer-requests` adding forward migration `PharmacyStockTransferLocationCheck` (`CK_StockTransferRequests_DifferentLocations`) and a Testcontainers.PostgreSql 4.17.0 integration suite (disposable postgres:18-alpine; the owner's configured database is never touched by tests).
- Runtime evidence: the owner's local Compose stack was rebuilt from the branch; API startup auto-applied all migrations to `sgsctr_dev` (17 rows in `__EFMigrationsHistory`, including the INV-03 ledger and INV-04 transfer migrations). Read-only psql inspection confirmed the three inventory tables and constraints; `/health/ready` returned HTTP 200 with both contexts connected. Local Development observation only — not production migration, not release evidence.
- Test evidence: 164/164 passed (`dotnet test Sgsctr.slnx --configuration Release`), including 9 new integration tests covering migration apply, constraint presence, constraint rejections, restrict and cascade deletes. Build 0 errors; `has-pending-model-changes` clean.
- Dependency note: Testcontainers.PostgreSql 4.17.0 was added after the owner's "implement missing" instruction following the audit that flagged the harness authorization requirement. It is a test-only dependency.
- Approval status: unchanged. Q12/Q13, Q33, Q53, security review and release gates remain open; no posting, valuation or production use was enabled.
- Canonical documents updated: [current state](current-state.md); deliberation addendum in .ai/roles/inv04-stock-transfer-requests-deliberation.md.

## 2026-11-17 — SDK pin fact reconciliation
- Repository evidence: owner commit `e685aa3` ("fix", 2026-11-16) changed global.json from SDK 10.0.403 to 10.0.115.
- Correction: current-state.md and architecture/system-context.md previously stated the pin as 10.0.403; both now record 10.0.115 with the commit reference. global.json remains authoritative.
- No approval, release or dependency-policy decision is implied; the pin change was made by the owner.

## 2026-11-17 — INV-04-02 draft-only stock transfer requests (branch feat/inv04-stock-transfer-requests)
- Repository event: commits `5c184f2` and `3497632` on branch `feat/inv04-stock-transfer-requests`, based on master merge commit `1965a609fb18023e4c958623b8adbfbf54f272af` which contains the owner's direct `phase02`/`phase INV03 execute`/`INV-04-01` commits.
- Implementation: additive migration `20261117140845_PharmacyStockTransferRequests` with regenerated snapshot; Draft-only transfer request endpoints (create/list/detail/submit/send-for-approval/approve/reject/cancel); `CanSendForApproval` and `AreLocationsDistinct` state-machine rules; separation of duties on approve/reject; 43 new rule tests. Approval creates Draft StockMovement rows only; no posting or balance effect.
- Technical validation: verified locally — build 0 errors, tests 155/155, `has-pending-model-changes` clean. Migration not applied to any database; PostgreSQL integration, BFF/UI coverage, CI and runtime evidence remain outstanding.
- Approval status: unchanged. Q12/Q13, Q53, security review and release gates remain open; the merge of the owner's phase commits and this branch do not approve costing, posting or production use.
- Canonical documents updated: [current state](current-state.md); deliberation record .ai/roles/inv04-stock-transfer-requests-deliberation.md.

## 2026-11-16 — AI context integrity acceptance (PR #81)
- Repository event: PR #81 merged to master at ef831fc7878ffa5229ad18310fb41a790e1cf893.
- Implementation: deterministic context manifest/index, repository-relative link checking and regression-test coverage are present on master.
- Technical validation: BLOCKED. CI jobs showed no assigned runner or visible steps; exact checked-in regression tests and full-tree checks were not executed from a clean checkout. Equivalent isolated fixture 3/3 is limited evidence, not full acceptance.
- Business/professional approvals: unchanged; no approval was granted by merge.
- Canonical detail: [AI context technical acceptance](../delivery/ai-context-index-technical-acceptance.md).

## 2026-11-16 — AI context documentation completion proposal (PR #82)
- Branch: docs/complete-ai-context-docs; PR: https://github.com/specialgroup2024/sgsctr/pull/82.
- Six empty project documents populated; root instruction ownership separated; machine-readable minimum-load profiles added.
- Generated context manifest/index updated to 132 source Markdown documents and zero empty placeholders at the branch head recorded in PR #82.
- This is an open documentation PR, not a merge or technical acceptance. Full-tree checks remain unrun.
- Business, professional, security/privacy and production-release approvals unchanged.

## 2026-11-25 — Pharmacy Group Option B boundary matrix

- Owner decision: PHARM-OWN-002 selects four independent operational modules (Regular Medications, Chemotherapy Drugs, Medical Supplies and Cosmetics), with module-level management financial records/reporting and group-level oversight/consolidation.
- Evidence snapshot: master commit `94236489089407e598cd68ead41ee7454c47c3e8`; source inspection found generic catalogue/family proposal, supplier and receipt drafts, stock movement ledger and stock-transfer request APIs. Movement/transfer approval remains draft-only and no posting/dispatch/receipt effect was evidenced in inspected routes.
- Reconciliation: current-state addendum corrects the earlier 2026-11-16 snapshot where it said no ledger/transfer artifacts existed on master. Five provisional product-family labels do not equal the four selected modules.
- Canonical matrix: [Pharmacy Group four-module boundary matrix](../domain/pharmacy-four-module-boundary-matrix.md); per-task deliberation: [role selection](../roles/phase0-pharmacy-four-module-boundary-matrix.md).
- Open decisions Q58-Q65 record shared supplier, site/module ownership, inter-module transfers, taxonomy, management accounting, costing and permissions.
- No application code, database schema, migrations, operational rules, stock posting, financial calculations or production configuration were changed. Local scripts, builds, tests and runtime checks were not run; repository evidence only.

## 2026-11-25 — Future 25 full legacy-to-Pharmacy reconciliation baseline

- Source: owner-designated read-only `futher_md/` corpus (12 files); recovered SQL Anywhere DDL contains 321 tables, 475 FK clauses, 36 indexes and one view. The DDL is transaction-log recovery, not an authenticated live catalog export.
- Added complete table-name/disposition register, 5,068-column inventory, complete FK register, 36-index and one-view inventories, 46-row first-pass source-to-target field mapping, and 17-family workflow/capability mapping under `.ai/delivery/future25-legacy-*`; main record preserves [O]/[I]/[U] confidence boundaries.
- Compared source evidence with current `AppDbContext`, Pharmacy API, UI and tests. Confirmed partial catalogue, supplier-draft, receipt-draft, stock movement/transfer and regulatory foundations; full purchasing/PO, dispensing/claims, GL/costing, payroll and fixed-assets workflows are not evidenced as implemented.
- Updated Pharmacy boundary matrix, Q66 status, AI context entrypoint and context manifest. Option B remains the selected four-module model; non-Pharmacy legacy families are not automatically in scope.
- No application code, schema, migration, operational rule, financial posting, stock effect or production configuration changed. No local scripts, build, tests, database or VM checks were run; GitHub source inspection only.
- Branch: `feat/future25-full-pharmacy-reconciliation-2026-11-25`. PR pending. PR #105 governance/source-authority change is already merged to master.

## 2026-11-25 — Documentation line-limit scope aligned with immutable legacy evidence

- Initial PR workflow run found that `scripts/check_markdown_line_limit.py` scanned all Markdown, including the owner-designated read-only `futher_md/` source corpus (multiple source documents exceed 200 lines).
- Root `AGENTS.md` now limits the rule to maintained project documentation. The checker excludes only the root `futher_md/` evidence corpus and generated `.ai/index.md`; regression tests verify that long legacy/generated evidence is exempt while long maintained Markdown still fails.
- No source file under `futher_md/` was changed. GitHub Actions rerun is pending; do not claim the correction passed until the new run completes.
