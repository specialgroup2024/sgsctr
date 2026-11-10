# Product scope and phase boundaries

Status: discovery/foundation. This document describes staged scope; it does not approve production business operations.

## Product domains

- Pharmacies: medicines, medical supplies and cosmetics across owner-identified locations.
- Specialized Contracting: a separate business domain whose project, contract, procurement and cost-control workflows remain to be defined.
- Shared platform: identity, organization reference data, audit, notifications and technical operations, subject to approved ownership and access boundaries.

## Current implementation phase

Phase 3 authenticated workspace (implementation branch; merge and runtime verification pending):
- Keycloak OIDC Authorization Code with PKCE through a Next.js BFF; encrypted HttpOnly session cookie.
- Protected navigation and pages, session refresh and sign-out.
- Authenticated organization sector directory and PostgreSQL-backed location register.
- Location create/edit/deactivate gated by an explicit, empty-by-default subject allowlist.
- Legal identity remains provisional; no legal-entity edits or operational transactions.

## Explicitly not in scope yet

- Approved enterprise role/permission matrix, user provisioning lifecycle, MFA/recovery policy and sector/location resource authorization.
- Legal-entity identity/registration editing.
- Pharmacy stock, dispensing, purchasing, transfers, claims, patient balances or costing.
- Contracting projects, contracts, procurement, progress billing or project cost postings.
- Accounting, tax, e-invoice, statutory reporting or financial calculations.
- Production deployment or compliance certification.

## Approval boundaries

- Confirm registered legal identity, legal operators and location ownership/licensing with owner and qualified advisers.
- Obtain pharmacy-operations and accountant approval for stock workflows, transfer controls and costing.
- Obtain contracting-owner/accountant approval for project and commercial workflows.
- Obtain owner/security approval for user lifecycle, MFA/recovery, role catalogue and sector/location authorization.
- Do not treat UI labels, proposed models or technical implementation as evidence of legal or professional approval.
