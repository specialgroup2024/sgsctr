# Pharmacy inventory INV-00 — requirements baseline

- Version: 0.1, prepared 2026-11-14.
- Status: **Draft for owner, pharmacy-operations, regulatory and accountant review; not approved for implementation.**
- Scope: inventory only for the Pharmacies Sector; no dispensing, payer claims, patient balances or GL posting.
- Related: [Phase 0 discovery](pharmacy-inventory-discovery.md), [costing examples](pharmacy-inventory-costing-worked-examples.md), [Egypt regulatory scan](../governance/egypt-pharmacy-inventory-scan-2026-11-14.md).

## 1. Confirmed context and boundaries

- Owner-identified locations: Mokattam main warehouse; Student Hospital, Qasr El-Aini and Manial Hospital branches.
- Branches are administratively connected but separately accountable for location stock reporting.
- Direct branch-to-branch transfers are required; routing through Mokattam is not required.
- Categories named by owner: regular medicines, chemotherapy medicines, medical supplies and cosmetics.
- Moving weighted-average costing is the requested method, not an approved costing policy.
- No inventory feature, production balance, migration or stock movement is implemented by this document.

## 2. Proposed user capabilities (draft requirements)

| ID | Capability | Testable outcome | Decision owner |
|---|---|---|---|
| INV-R01 | Location register | Each authorized warehouse/branch has a verified code, type, legal operator, licence and stock custodian. | Owner/legal |
| INV-R02 | Product catalogue | Product identity, category, manufacturer/brand, strength/form where relevant, identifiers and active status are controlled without duplicate ambiguity. | Pharmacist |
| INV-R03 | Units and packs | Purchase, storage and issue units plus conversion factors are explicit, versioned and tested; no silent rounding. | Pharmacist/accountant |
| INV-R04 | Supplier register | Supplier identity, licence/authorization evidence, agreements and validity are recorded for applicable product classes. | Procurement/regulatory |
| INV-R05 | Purchase order | Draft, approval, supplier, lines, unit, expected quantity, price evidence and reference are auditable. | Procurement/owner |
| INV-R06 | Receiving | Actual quantities, product, batch/lot, manufacture/expiry, packaging and shipment/storage evidence are checked against documents. | Pharmacy/quality |
| INV-R07 | Receipt disposition | Accepted, rejected and quarantined quantities are distinct; unapproved stock cannot become available. | Pharmacist/quality |
| INV-R08 | Stock ledger | Every posted quantity change has an immutable movement, actor, timestamp, source document, location and reason. | Pharmacy/technical |
| INV-R09 | Location balance | On-hand, reserved, available, quarantine, expired, recalled and in-transit are not conflated. | Pharmacy/accountant |
| INV-R10 | Expiry rotation | FEFO suggestions and near-expiry reports use batch expiry; overrides require authorized reason. | Pharmacist |
| INV-R11 | Storage evidence | Storage profiles, location/equipment, temperature/humidity observations, calibration and deviation evidence are traceable where applicable. | Quality |
| INV-R12 | Transfers | Warehouse↔branch and direct branch↔branch transfers preserve custody, lot and quantities through dispatch, transit, partial receipt and resolution. | Pharmacy/owner |
| INV-R13 | Counts | Count sessions compare blind/expected and observed quantity; variances are investigated and adjusted only with authority. | Pharmacy/accountant |
| INV-R14 | Returns and damage | Returned, damaged, expired and recalled stock is isolated from available stock until authorized disposition. | Pharmacist/quality |
| INV-R15 | Recall | Search and reconcile affected batches across receipts, transfers, issues and locations; preserve daily and final reconciliation evidence where required. | Quality/regulatory |
| INV-R16 | Reports | Stock by location/item/lot/status, expiry, movement history, discrepancy, supplier and in-transit reports reconcile to ledger. | Owner/accountant |
| INV-R17 | Audit and access | Server-side sector/location authorization; separation of duties; immutable event history; no client-side database writes. | Owner/security |
| INV-R18 | Retention | Documents and records follow applicable site/product/legal retention schedule with retrievable evidence. | Legal/regulatory |

## 3. Proposed receiving and stock-state flow

1. Purchase order or other approved source document is referenced.
2. Receiving records supplier, delivery, item, quantities, units, lot, expiry, packaging and relevant transport/storage evidence.
3. Inspection splits quantities into accepted, rejected and quarantined outcomes; discrepancy reason and evidence are mandatory.
4. Accepted quantity becomes available only after the designated release authority and any required checks.
5. Rejected/quarantined quantity remains segregated and cannot be picked, transferred as usable stock or dispensed.
6. Every posting creates a ledger event and updates a balance projection atomically.

This flow is a proposal; the signed SOP and product-specific acceptance criteria control actual operation.

## 4. Proposed transfer flow

Draft → Submitted → Approved/Rejected → Picking → Dispatched/In transit → Partially received/Received → Closed. A dispatched transfer is never deleted; returns and corrections use linked events. A transfer must preserve the direct source-to-destination route, including branch-to-branch. Partial receipts and discrepancies remain visible until resolved. Exact states, approver separation, custody, emergency process and discrepancy closure need owner/pharmacy approval.

## 5. Cross-cutting acceptance conditions

- No expired, recalled, damaged, rejected or quarantined stock can be selected as available.
- No lot-controlled quantity is moved without the required lot and expiry data.
- FEFO is a candidate selection rule, subject to pharmacist-approved exceptions.
- Every operation is idempotent and protected against concurrent overspending; failed transactions leave no partial balance or ledger change.
- Counts never overwrite history; adjustments require reason, evidence and approved authority.
- Recall lookup can identify every known affected location and movement path.
- All location views reconcile to the movement ledger; in-transit stock reconciles separately.
- Monetary/costing fields remain non-posting until accountant approval.

## 6. Approval decisions required (no defaults selected)

- Site class/licence, operator, ownership and whether Mokattam is an EDA-licensed pharmaceutical warehouse.
- Product taxonomy, controlled/misuse-potential classification, track-and-trace scope, serial/lot/expiry policy and device/cosmetic distinctions.
- Units, pack conversion, barcode/GTIN and duplicate-resolution rules.
- Supplier eligibility, PO approval, receiving checks, rejection/quarantine and document retention.
- Storage profiles, temperature excursion handling, FEFO override, near-expiry thresholds, recall and returned-goods disposition.
- Balance statuses, reservation, negative stock, count cadence, adjustment authority and audit retention.
- Transfer roles, approval thresholds, separation of duties, custody, partial receipt, emergency and discrepancy rules.
- Moving weighted-average pool (company/sector/location/item/lot), update timing, transfer, return, loss, expiry, rounding and period-close treatment.
- Opening-stock source, physical count, reconciliation, migration cutover and legacy retention.

## 7. Delivery gate

INV-01 may begin only after owner and pharmacist approve product/location/unit requirements and site classification. No production schema, migration, seeded catalogue, opening balance or stock posting is authorized by this draft. Costing and financial posting remain blocked until signed accountant examples are approved.
