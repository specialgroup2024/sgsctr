# Pharmacy Inventory — pharmacist approval demo record

- Recorded: 2026-11-15.
- Approval ID: INV-PRO-001.
- Record type: **synthetic demonstration data**, requested by the project owner.
- Application status: `DemoApproved`.
- Display label: **Approved (demo)**, shown in red.

## Purpose

The owner requested a demonstration of how the Pharmacy Inventory UI and PostgreSQL approval register should display an approved pharmacist / pharmacy-operations item. The database migration changes only the seeded INV-PRO-001 governance record to the dedicated `DemoApproved` status. The UI renders this status with a red badge and an explicit demo warning.

## What this record means

This is a synthetic example representing an approved-state scenario. The displayed approver is labelled “DEMO: authorized pharmacist”; it is not a person's identity. No pharmacist name, licence, qualification, delegation evidence, signed review, or professional decision document was supplied or verified by this implementation.

**This does not constitute pharmacist approval.** It does not close the real INV-PRO-001 professional gate, authorize receiving, FEFO, quarantine, recall, returns, product classification, dispensing, stock movements, or any pharmacy operation. The professional gate remains open and requires a qualified human reviewer with recorded identity, qualification, exact decision scope, evidence and date.

## Data and UI safeguards

- The database status is `DemoApproved`, not `Approved`, so it cannot be mistaken for a normal approval by API consumers.
- The allowed database status constraint explicitly recognizes `DemoApproved`.
- The API returns the demo status and its explanatory decision notes/conditions.
- The Inventory → Approvals UI labels it “Approved (demo)” in red and displays a warning that the real professional gate remains pending.
- CI smoke tests assert the demo status, the synthetic-only decision notes, the warning condition, and that the other six professional/owner gates remain Pending.
- No approval decision-write endpoint is added. No stock, financial or pharmacy workflow is enabled.

## Replacing the demo with a real approval

A qualified pharmacist / authorized pharmacy-operations professional must review the exact scope and provide verifiable identity and qualification, a dated decision, evidence, limitations and conditions. The project owner must then authorize adoption where required. A controlled follow-up change must replace the demo state with a properly evidenced real decision while preserving the demo history.
