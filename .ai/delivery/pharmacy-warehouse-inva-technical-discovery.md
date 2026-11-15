# Pharmacy warehouse INV-A — verified technical discovery

- Date: 2026-11-15.
- Branch: `feat/pharmacy-warehouse-inva-discovery`.
- Status: discovery evidence; not an implementation-complete claim.
- Authority: owner authorization recorded in `pharmacy-inventory-owner-authorization-and-execution.md`.
- Scope: Pharmacy warehouse and inventory across PostgreSQL/EF Core, ASP.NET Core, Next.js, authorization, audit and tests.

## 1. Verified current baseline

- Master contains the authenticated `/pharmacies/inventory` workspace with Overview, Product Catalogue, Receiving, Stock Transfers, Batches & Expiry and Reports tabs.
- The workspace reads organization locations, system status and the pharmacy catalogue through the Next.js BFF.
- The catalogue API persists generic Draft products, units, exact-ratio unit conversions and catalogue audit events.
- Product-governance APIs persist provisional family proposals, identifiers, regulatory evidence and pending lifecycle requests. These do not activate products.
- The organization workspace owns the location register; the inventory workspace must consume it rather than create duplicate location identities.
- The inventory UI explicitly states that receiving and transfer posting are disabled and that no stock ledger exists.
- No supplier master, purchase orders, receipts, stock balances, stock movement ledger, lots, transfer ledger, stock counts, recall workflow, valuation or GL posting is implemented on master.
- Existing technical design documents describe transfer and persistence concepts, but proposals are not deployed schema or executable behavior.

## 2. Owner-confirmed operating context

- Locations: Mokattam main warehouse; Student Hospital, Qasr El-Aini Hospital and Manial Hospital branches.
- Branches are administratively connected and separately accountable for location stock reporting.
- Direct branch-to-branch transfers are required; routing through Mokattam must not be forced.
- Product scope includes regular medicines, chemotherapy medicines, medical supplies and cosmetics.
- Moving weighted-average costing is requested; its pool, timing, event treatment, precision, rounding and close policy remain subject to accountant approval.
- Mokattam's EDA warehouse licence is owner-confirmed, but the licence copy, holder, operator, validity and scope have not been independently verified. Other sites require separate classification.

## 3. Five-role technical deliberation

Profiles selected: modular-monolith/API architect; security and data-integrity challenger; hospital-pharmacy warehouse operator as client lens; pharmacy supply-chain and quality analyst as SME lens; senior delivery architect as Maestro. These are simulated perspectives, not independent agents or qualified reviewers.

**Architect proposal:** keep inventory in the Pharmacy module; use a movement ledger as the source of truth, location/lot balance projections, explicit receipt/transfer aggregates, authenticated APIs and PostgreSQL transactions.

**Devil's Advocate challenge:** building a mutable quantity table first would permit silent stock drift, duplicate command effects and unsafe concurrent dispatch. A generic product record cannot prove lot/expiry/serial requirements. A single transfer status would lose the distinction between requested, dispatched, received and disputed quantities.

**Clueless Client challenge:** warehouse staff must know which location owns stock, whether stock is usable, what is in transit, and which lot was actually received. The interface must not display missing data as zero, allow the sender to self-approve where separation is required, or hide shortages and damage.

**SME analysis:** use append-only movement events and transactionally maintained projections; preserve separate available, reserved, quarantined, rejected, expired, recalled and in-transit quantities. Make commands idempotent and concurrency-safe. Keep product-family and site-specific controls pending qualified review.

**Maestro determination:** this is the technical direction for discovery and draft/non-posting work only. It does not approve stock-state definitions, custody procedures, roles, limits, legal classifications, transfer SOPs or costing policy.

## 4. Required implementation increments

1. **INV-A:** complete code/schema/test/identity/audit discovery and a traceable implementation test matrix.
2. **INV-B:** supplier register and evidence, draft/review only, after supplier scope and review authority are approved.
3. **INV-C:** purchase-order drafts and approval records; no supplier transmission or financial commitment.
4. **INV-D:** receipt drafts, inspection evidence and proposed accepted/rejected/quarantined dispositions; no usable-stock release until signed procedure.
5. **INV-E:** append-only stock ledger and location/lot projections, with idempotency, PostgreSQL transaction, concurrency and rollback tests. Posting stays disabled until stock-state and permission policies are signed.
6. **INV-F:** lot/expiry, FEFO candidates, quarantine, recall traceability, counts, adjustments and reconciliation after pharmacist/quality decisions.
7. **INV-G:** direct warehouse↔branch and branch↔branch transfer lifecycle, dispatch, in-transit, partial receipt and discrepancy records after signed transfer SOP and custody/role decisions.
8. **INV-H:** moving weighted-average valuation only after accountant-approved worked examples and cost policy; no GL posting without separate approval.
9. **INV-I:** reports, operational acceptance, security review, migration rehearsal, opening-stock reconciliation and controlled release.

## 5. Non-negotiable engineering and safety controls

- Preserve existing data and migrations; use additive forward migrations; never reset database volumes.
- All writes pass through ASP.NET Core; no browser-to-database access.
- Enforce sector/location authorization on the server and separation of duties.
- Append-only movement/audit events; corrections use linked reversal or adjustment events.
- Commit movement events and balance projections atomically; protect concurrent stock changes and use persisted idempotency keys.
- Keep in-transit, available, reserved, quarantined, rejected, expired and recalled quantities distinct.
- Do not add dispensing, patient balances, payer claims, tax or GL workflows to this warehouse scope.
- Do not infer EDA/EPTTS applicability, storage limits or site licence status from names or UI labels.
- No production stock posting, opening balance, valuation or financial posting without the relevant recorded approvals.

## 6. Completion evidence required for every increment

Record changed files; migration and schema effect; API routes and authorization; UI routes and real API connectivity; domain invariants; unit and PostgreSQL integration tests; CI run; known limitations; required owner/professional approvals; and whether the capability is draft-only, test-enabled or production-approved.

## 7. Immediate discovery tasks still to verify

- Inventory all existing EF entities, migrations, indexes and database constraints before designing new persistence.
- Trace organization-location IDs and current server-side sector/location authorization conventions.
- Trace current audit event storage, actor identity, correlation and retention behavior.
- Inventory API integration-test fixtures and real PostgreSQL test infrastructure.
- Reconcile the open frontend TypeScript repair PR before extending the inventory UI.
- Complete the pharmacy requirements-to-code-to-test traceability matrix and migration/recovery review.

## 8. Explicitly unresolved approval gates

Q37 site licence evidence/classification; Q38 product-family fields and traceability; Q39 receipt/release roles; Q40 storage monitoring; Q41 retention/legal hold; Q42 EPTTS role/SKU/site applicability; Q43 purchase/receipt pricing; Q44 costing examples; Q45 reviewer/source owners; Q51 supplier qualification; Q52 receiving/stock procedures; Q53 transfer SOP/custody/exceptions; Q55 costing and GL boundary. See `.ai/memory/open-questions.md` and the owner authorization record.

**Disposition:** the repository has a useful UI and generic catalogue foundation, not a functioning warehouse. INV-A is a discovery checkpoint; the remaining increments must be implemented and verified before the warehouse can be called complete.
