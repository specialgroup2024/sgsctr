# Product scope and phase boundaries

Status: discovery/foundation. This document describes staged scope; it does not approve production business operations.

## Product domains

- Pharmacies: medicines, medical supplies and cosmetics across owner-identified locations.
- Specialized Contracting: a separate business domain whose project, contract, procurement and cost-control workflows remain to be defined.
- Shared platform: identity, organization reference data, audit, notifications and technical operations, subject to approved ownership and access boundaries.

## Current UI phase

Phase 2 application shell and organization workspace:
- Shared responsive navigation.
- Overview dashboard with live API/database connection checks.
- Read-only organization register using owner-provided sector and location information.
- Explicit provisional status for legal identity and unverified structure.

## Explicitly not in scope yet

- Application login/session UI or business authorization.
- Organization/branch CRUD.
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
