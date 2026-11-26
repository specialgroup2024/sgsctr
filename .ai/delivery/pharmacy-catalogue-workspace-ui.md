# INV-02 — dedicated product catalogue workspace

- Status: implemented on feature branch; review and CI pending.
- Scope: expose the existing INV-01 catalogue manager as a first-class authenticated Pharmacy workspace.
- Authority: INV-OWN-001 and the generic INV-01 carve-out in the [approval pack](pharmacy-inventory-inv01-approval-pack.md). Q38 remains pending.
- This is a UI navigation/presentation change. It does not expand the catalogue data contract or activate products.

## Changes

- Added authenticated route `/pharmacies/catalogue`; unauthenticated requests redirect to `/login`.
- Added a direct Product catalogue entry to the shared application navigation.
- Reused the existing `CatalogueManager` rather than creating a second implementation of product/unit/conversion APIs.
- Retained the server-side Next.js BFF and existing ASP.NET Core authorization. Browser code does not connect to PostgreSQL.
- Retained product create/edit as Draft-only, unit reference maintenance, exact integer-ratio conversion records, audit visibility and provisional governance submissions.
- Repeated the Q38/provisional-data notice on the dedicated page.

## Explicit non-goals

No product-family fields or classification decisions, identifier verification, activation/retirement, supplier master, import, purchasing, receiving acceptance, stock mutation, batch/expiry, dispensing, pricing, costing, claims, accounting or financial posting.

No schema, EF migration, API endpoint or business rule was changed in this slice.

## Acceptance checks

- Authenticated user can open `/pharmacies/catalogue` from the sidebar.
- Anonymous user is redirected to login.
- Catalogue manager reads through existing authenticated BFF endpoints.
- Read-only users cannot create/edit; API remains authoritative for write permission.
- Administrator-authorized users can create/edit generic Draft product identity and maintain units/conversions under existing validation and audit behavior.
- Product family and lifecycle submissions remain provisional; no activation or stock effect is possible.
- Verify EN/AR, RTL, responsive layout, loading/empty/error/forbidden states.
- Run web typecheck/build, i18n checks, API tests and browser/API/database smoke tests in CI/runtime before acceptance.

## Verification record

- GitHub source inspection completed for root agent instructions, task routing, approval register, INV-01 approval pack, existing catalogue manager, BFF routes, API endpoint, application shell and inventory workspace.
- Files written to branch: `web/components/app-shell.tsx`, `web/app/pharmacies/catalogue/page.tsx`, `web/app/pharmacies/catalogue/CatalogueWorkspacePage.tsx`.
- Local build, typecheck, i18n, browser, API and PostgreSQL checks: **Not Run** in this execution environment.
- PR review/merge and deployment: pending.
