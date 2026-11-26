# Future 25 pharmacy UI reconstruction — increment 1

- Date: 2026-11-26.
- Status: implementation branch; draft UI increment only. Runtime verification pending.
- Legacy source: owner-designated read-only `futher_md/`; especially `future_25_app_ui.md`, `future_25_app_modules.md`, `future_25_app_workflow.md` and `future25_schema_report.md`.
- SGSCTR scope: Option B — Regular Medications, Chemotherapy Drugs, Medical Supplies and Cosmetics.

## What this increment implements

- Adds a Pharmacy landing screen with four distinct module entry points.
- Adds authenticated routes for each module workspace.
- Uses the existing SGSCTR application shell, localization provider, navigation and responsive workspace styles.
- Reconstructs module-specific workflow sections from the static Future 25 evidence: catalogue, supplier/procurement, receiving, stock/traceability, dispensing/sales, payer/claims, quality and management reporting as applicable.
- Presents the sections as design/review work queues, not as enabled transactions.
- Exposes the existing shared inventory and regulatory foundation separately from the four module workspaces.
- Provides English and Arabic labels and preserves the existing login gate.

## Source limitations

The legacy UI inventory is a static catalogue of PowerBuilder windows and DataWindows. No executable was launched, PBD bytecode was not decompiled, and no runtime screenshots or click traces were captured. The new web screens are therefore workflow reconstructions, not pixel-perfect reproductions or proof of legacy behavior. Individual legacy DataWindow/report lineage remains a follow-up.

## Database decision for this increment

No legacy DDL was imported and no PostgreSQL migration was added.

Reasons:
1. The 321-table SQL Anywhere DDL was recovered from a translated transaction log, not an authenticated live catalog export.
2. No approved, verified legacy data snapshot was supplied for data migration.
3. The first-pass table/column/FK disposition registers are not semantic field mappings or approved target schemas.
4. Option B selects four independent operational modules, but detailed decisions remain open for shared suppliers, physical locations, stock ownership, cross-module movement, product taxonomy, permissions and management/statutory accounting boundaries.
5. Current SGSCTR already has PostgreSQL-backed generic product/unit/conversion, supplier/receipt drafts, stock movement/transfer scaffolding and governance/regulatory foundations. Importing the legacy schema would duplicate or conflict with these models.

## Database upgrade sequence required before transactional implementation

1. Approve the four-module ownership model for catalogue, suppliers, procurement, receiving, inventory, lots, sales/dispensing, claims and management records.
2. Decide shared supplier identity, shared physical-site custody, location-to-module assignment and inter-module movement policy.
3. Approve product taxonomy and module-specific attributes with pharmacist, quality and regulatory reviewers.
4. Complete semantic mapping from each in-scope legacy table/column/relationship to current PostgreSQL entities, APIs, screens and reports.
5. Design additive EF Core migrations against the current model snapshot; do not edit applied migrations or replay SQL Anywhere DDL.
6. Import data only from an authorized, verified legacy export with source counts, transformation/reconciliation rules, dry-run, backup and rollback evidence.
7. Keep all posting, valuation, dispensing, claims and financial effects disabled until their corresponding professional/owner approvals are recorded.

## Verification status

- Source inspection: completed for the cited static UI/module/workflow documents and current SGSCTR landing/inventory foundation.
- Code changes: pending CI.
- Typecheck/build/browser/VM/Docker: not run in this tool-mediated repository change; CI and owner VM verification are required.
- Database migration: intentionally not created in this increment.
- No production data was accessed or changed.
