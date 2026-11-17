# Curated project change log

Append-only record of material repository/governance state changes. Detailed evidence remains in the linked canonical records.

## 2026-11-17 — INV-04-02 draft-only stock transfer requests (branch feat/inv04-stock-transfer-requests)
- Repository event: commit `5c184f2` on branch `feat/inv04-stock-transfer-requests`, based on master merge commit `1965a609fb18023e4c958623b8adbfbf54f272af` which contains the owner's direct `phase02`/`phase INV03 execute`/`INV-04-01` commits.
- Implementation: additive migration `20261117140845_PharmacyStockTransferRequests` with regenerated snapshot; Draft-only transfer request endpoints (create/list/detail/submit/send-for-approval/approve/reject/cancel); `CanSendForApproval` state-machine rule; separation of duties on approve/reject; 41 new rule tests. Approval creates Draft StockMovement rows only; no posting or balance effect.
- Technical validation: verified locally — build 0 errors, tests 153/153, `has-pending-model-changes` clean. Migration not applied to any database; PostgreSQL integration, BFF/UI coverage, CI and runtime evidence remain outstanding.
- Approval status: unchanged. Q12/Q13, Q53, security review and release gates remain open; the merge of the owner's phase commits and this branch do not approve costing, posting or production use.
- Canonical document updated: [current state](current-state.md).

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
