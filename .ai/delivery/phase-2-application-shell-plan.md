# Phase 2 — Application shell and organization workspace

Status: implementation scope for the phase-2-application-shell branch. Review and merge are pending.

## Objective

Turn the existing single-page foundation dashboard into a navigable, responsive web application shell and provide a read-only organization directory. This phase establishes UI structure without inventing business policy or creating operational records.

## Dynamic specialist perspectives

These are simulated analytical perspectives, not independent agents or credentialed professionals:
- Architect — Next.js application structure, shared layout and route boundaries.
- Devil's Advocate — client-side trust, misleading status indicators, accessibility and accidental operational actions.
- Clueless Client — navigation clarity, understandable labels and obvious read-only boundaries.
- Subject Matter Expert — Next.js App Router, React component composition, TypeScript and responsive UX.
- Maestro — recommends a small shared shell plus an evidence-backed organization register; defer authentication and business CRUD.

## Included

- Shared responsive navigation shell for Overview, Organization, Pharmacies and Specialized Contracting.
- Route-aware active navigation and accessible navigation labels.
- Organization register using only owner-provided sectors and pharmacy location names.
- Explicit provisional/legal-verification and read-only status messaging.
- Clear statement that no stock transfer or financial/contracting operation can be performed.
- Update project scope and current-state documentation to match actual repository evidence.

## Excluded

- Authentication UI, login, logout, session handling or user profile claims. A secure Next.js BFF flow is a separate implementation work package.
- Business users, roles, permissions, approval limits or sector/location access rules.
- Create/update/delete operations for legal entities, sectors, branches or warehouses.
- Pharmacy catalogue, stock balances, stock movements, patient/claim records or inventory costing.
- Contract/project/procurement transactions, accounting, tax or financial postings.
- Database schema, EF migrations, production data or seed data.

## Acceptance criteria

1. Existing overview remains available at /.
2. Organization register is available at /organization.
3. Shared navigation links resolve to real pages; future sector routes clearly state that operational features are not enabled.
4. Navigation exposes the current page semantically and works with keyboard navigation.
5. Layout remains usable at desktop and narrow mobile widths.
6. Organization labels distinguish owner-provided facts from legal verification and proposed design.
7. No route in this phase can create or modify business, stock or financial data.
8. npm run typecheck and npm run build complete successfully before merge; results must be recorded from actual CI/local execution.
9. All Markdown files remain below 200 lines.

## Follow-on gates

- Implement a server-side Keycloak OIDC BFF (Authorization Code + PKCE, state/nonce validation, secure HttpOnly cookies, server-held tokens, CSRF protections) and test it before claiming application login works.
- Obtain owner approval for user lifecycle, MFA/recovery and role/permission/entity-sector/location scopes before permission-aware menus or business operations.
- Build organization CRUD only after legal identity, legal operators, location ownership/custody and the owner-approved organization model are verified.
- Keep Pharmacy and Contracting workflows behind their respective business/professional approvals.
