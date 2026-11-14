# INV-00 five-role deliberation record

- Date: 2026-11-14.
- Status: technical recommendation; no business, accounting, pharmacy or legal approval.
- Scope: pharmacy inventory requirements preparation only.
- Evidence baseline: master after PR #27 merge; EDA GSDP v05/2025; EDA warehouse licensing EDREX:GL.CALI/CIP.002 v05/2026; EPTTS Phase 1 FAQ v03/2026; repository governance and proposed transfer design.
- Limitation: five roles are simulated analytical perspectives in one assistant, not independent agents or qualified human reviewers.

## Stage 1 — selected profiles

- Architect: pharmacy inventory / enterprise application architect; relevant to .NET modular monolith, ledger, location and costing boundaries.
- Devil's Advocate: inventory-control / database-concurrency / security assurance; relevant to stock integrity, traceability and access.
- Clueless Client: branch pharmacist / warehouse receiver perspective; relevant to usability and operational adoption. This is a perspective, not an interview.
- Subject Matter Expert: pharmaceutical supply-chain and inventory-systems analyst with Egyptian regulatory-source review; not a licensed pharmacist or Egyptian counsel.
- Maestro: senior technology architecture / delivery authority; recommends technical sequence but cannot approve reserved decisions.

## Stage 2 — initial proposal

Architect: Keep inventory inside the Pharmacy module of the existing .NET modular monolith. Separate product catalogue, receiving, stock ledger, location balances, quality status, transfers and costing. Treat the movement ledger as the source of truth; balances are derived projections. Keep financial valuation separate until approved.

## Stage 3 — technical confrontation

Devil's Advocate: The biggest risk is building the wrong control model for the sites. Mokattam is called a main warehouse, but its licence and legal classification have not been verified. The July 2026 EDA warehouse guide has requirements that must not automatically be imposed on hospital pharmacy branches. A second serious risk is treating a quantity transfer as a simple balance update: partial receipts, damaged goods, temperature excursions, recalls and concurrent dispatches can corrupt stock if custody and audit events are not designed first.

Clueless Client: The system must make receiving and transferring understandable. A branch should be able to request stock directly from another branch, see what is actually in transit, and record a partial receipt. If every receipt requires too many screens and repeated data entry, staff will bypass it or enter incorrect batch information. Barcode scanning and clear exception handling should be considered, but not assumed to be available at every site.

Subject Matter Expert: EDA GSDP v05/2025 supports stock records updated after each operation, reconciliation, expiry monitoring, FEFO, controlled receipt, quarantine and recall traceability. The EDA warehouse licensing guide v05/2026 adds warehouse-specific record and retention provisions. EPTTS Phase 1 also has importer reporting and serialization requirements for covered products; that does not prove every pharmacy branch transfer is reportable. Moving weighted average is not one complete policy until its cost pool, receipt timing, returns, transfers and in-transit treatment are decided. No qualified pharmacist, accountant or regulatory adviser has approved these decisions.

## Stage 4 — forced evolution

Architect revision: Prepare a requirements baseline and non-posting worked examples first. Make site/product applicability explicit. Keep lot, expiry, storage, quarantine and recall data in the proposed capability model, but leave the exact rules configurable only after professional approval. Make direct branch-to-branch transfers a first-class route. Do not create database tables or stock balances yet.

Devil's Advocate retest: This is safer, but the requirements remain incomplete until site licences, product classifications, custody, role authority, supplier eligibility and opening-stock evidence are confirmed. The costing examples must show alternatives rather than silently selecting the owner's earlier proposed purchase-return rule.

Clueless Client retest: The first usable release should be staged. Start with approved reference data and a simple catalogue workflow; do not force branches to adopt purchasing, dispensing, claims and accounting all at once. Make it obvious when stock is quarantined or unavailable.

Subject Matter Expert retest: A product cannot be made available just because a receiving quantity was entered. The authorized quality/release decision and required evidence must be recorded. Storage limits must come from applicable product and site requirements, not one global hard-coded temperature.

## Stage 5 — Maestro determination

Proceed with INV-00 requirements preparation and worked costing examples only. Do not begin INV-01 catalogue persistence, EF migrations, stock balances or any stock-changing workflow until the owner, pharmacy operations/licensed pharmacist, regulatory reviewer and accountant resolve the relevant questions and record approvals. This is a technical recommendation, not professional or business approval.

## Alternatives considered

- Immediate full inventory implementation: rejected because key site, product, workflow, accounting and regulatory decisions are unresolved.
- Catalogue-only schema now: deferred because product identity, units, regulatory classification and data ownership are not approved.
- Requirements and costing examples first: selected because it creates reviewable, testable decisions without production data or stock side effects.

## Residual risks and required approvals

- Site licence/classification and ownership: owner, legal/regulatory adviser.
- Product classes, lot/expiry, storage, quality release and recall: licensed pharmacist/quality lead.
- EPTTS applicability: regulatory-affairs professional.
- Cost pool, return basis, transfer/in-transit value and rounding: accountant.
- Opening stock, count, migration and cutover: owner, pharmacy operations and accountant.

## Acceptance of this deliberation

This record is an agent-generated technical recommendation. It does not record human approval. Q37–Q46 in .ai/memory/open-questions.md remain open until named owners decide and the evidence is attached.
