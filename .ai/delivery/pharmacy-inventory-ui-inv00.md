# Pharmacy inventory UI — INV-00 screen implementation

> Historical baseline: this document records the discovery/INV-00 state before the generic INV-01 implementation branch. For current repository state, read [current-state](../memory/current-state.md), [INV-01 approval pack](pharmacy-inventory-inv01-approval-pack.md) and [ADR-0004](../architecture/ADR-0004-generic-pharmacy-catalogue.md). The generic branch is not merged or runtime-verified.

- Date: 2026-11-14.
- Status: implemented as a connected, non-posting UI prototype; not a production inventory module.
- Branch: feat/pharmacy-inventory-ui-inv00.
- Governance: AGENT.md, AGENTS.md and .ai operating model applied; five perspectives were simulated in one assistant, not independent agents.

## Dynamic specialist selection

- Architect: Next.js application architect / ASP.NET Core BFF integration.
- Devil's Advocate: application security, data-integrity and UX assurance; challenged fake balances, direct browser-to-database access and premature write actions.
- Clueless Client: hospital-branch pharmacist / warehouse operator; challenged discoverability, navigation and the need to distinguish unavailable stock data from zero stock.
- Subject Matter Expert: pharmacy inventory and supply-chain systems analyst with Egyptian regulatory-source review; not a licensed pharmacist or Egyptian counsel.
- Maestro: senior application/platform delivery architect; technical sequencing only, not business or professional approval.

## Delivered UI

- /pharmacies/inventory is an authenticated inventory workspace route.
- Navigation exposes Pharmacy Inventory as a distinct workspace item.
- The Pharmacies landing page links to Inventory and Regulatory Intelligence.
- Workspace sections: Overview, Product Catalogue, Receiving, Stock Transfers, Batches & Expiry, and Reports.
- Overview reads active Pharmacies-sector locations from the existing authenticated /api/organization BFF, which reads the PostgreSQL-backed Organization API.
- API liveness and PostgreSQL readiness are shown separately using /api/system-status; the browser does not connect directly to PostgreSQL.
- Refresh is available and health/location data refreshes every 30 seconds.
- Empty states explicitly say when no product, receipt, batch, movement or stock data exists. No sample balances, fake products, expiry alerts or transactions are shown.
- Workflow controls that would create records are visibly disabled pending approval and persistence work.
- The direct branch-to-branch transfer route is explained as a required capability; no transfer is created or posted.
- Regulatory Intelligence remains separately accessible.

## Not delivered by this UI phase

- No inventory API endpoints, EF entities, DbSets, migration, seed data or inventory tables.
- No product, supplier, purchase order, receipt, stock balance, movement, batch, transfer, count, recall, valuation or GL records.
- No costing calculations or accounting posting.
- No new authentication or Data Protection verification; those checks remain on hold per owner instruction.
- No live VM/Docker deployment verification from this repository change.

## Approval gates preserved

- Q37: site licence/classification and operator.
- Q38/Q46: product taxonomy, identifiers, units and catalogue boundary.
- Q39–Q41: receipt authority, storage and retention.
- Q42: EPTTS applicability.
- Q43–Q44: purchasing cost inputs and accountant-approved costing examples.
- Q33/Q34: stock ledger, transfer lifecycle, custody and costing controls.

## Acceptance and verification

- Authenticated route uses the existing server-side readSession gate.
- Location data comes from the existing BFF/API path; errors and empty records are visible.
- API and database health are distinct indicators sourced from the existing server-side status endpoint.
- All inventory write actions remain disabled; no client-side persistence or direct database access was added.
- Run npm run typecheck and npm run build from web/ in CI before merge. VM rebuild and browser verification remain necessary after merge.

## Next phase

After named owner and qualified pharmacy/regulatory/accounting approvals, define INV-01 scope and implement approved reference-data persistence (product, unit, location metadata and supplier master as explicitly approved), with server-side authorization, validation, audit, migrations and PostgreSQL integration tests. Do not enable stock posting until subsequent approved work packages and costing gates are complete.
