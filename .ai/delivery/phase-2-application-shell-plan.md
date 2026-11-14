# Phase 2 — Application shell and organization workspace

Status: implementation is present on master. This document records the delivered scope and remaining boundaries; it is not authority to add business operations.

## Objective
Provide a navigable responsive web shell and read-only organization reference workspace without inventing business policy or enabling operational records.

## Delivered scope
- Shared navigation shell for Overview, Organization, Pharmacies and Specialized Contracting.
- Route-aware navigation and responsive page structure.
- Organization API returns owner-provided sector and pharmacy location reference data.
- Pharmacy location records are persisted through an EF migration.
- Legal identity is explicitly marked VerificationPending.
- Location create/edit/deactivate is guarded by an organization-manager subject allowlist, empty by default.
- Owner VM tests on 2026-11-11 confirmed the web system-status endpoint can reach the API and report API online/database connected.

## Current boundaries
- The presence of Pharmacies and Contracting routes does not mean their operational workflows exist.
- No stock transfers, inventory balances, dispensing, patient/claim records, contracting transactions, accounting or financial postings are enabled.
- Authentication implementation is present, but local Compose defaults Authentication:Enabled to false in Development unless overridden. Verify actual sign-in and authorization behavior before treating the workspace as protected.
- No enterprise role/permission matrix or sector/location scope model is approved.

## Original acceptance intent
1. Overview remains available at /.
2. Organization register is available at /organization.
3. Shared navigation links resolve to real pages; future sector routes state that operational features are not enabled.
4. Navigation exposes current page semantically and supports keyboard navigation.
5. Layout is usable at desktop and narrow mobile widths.
6. Organization labels distinguish owner-provided facts from legal verification and proposed design.
7. No route in this phase creates or modifies business, stock or financial data.
8. npm typecheck/build results must be evidenced by CI or local output; do not infer success from merge alone.
9. All Markdown files remain below 200 lines.

## Follow-on gates
- Verify native Identity login, session lifecycle, CSRF protections and authorization before claiming enforced application authentication.
- Obtain owner approval for user lifecycle, MFA/recovery and role/permission/entity-sector/location scopes before permission-aware menus or business operations.
- Verify legal identity, legal operators, location ownership/custody and owner-approved organization model before legal-entity CRUD.
- Keep Pharmacy and Contracting workflows behind their respective business/professional approvals.
