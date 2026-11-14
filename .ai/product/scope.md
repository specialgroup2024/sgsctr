# Product scope and phase boundaries

Status: technical foundation and application shell implemented; business discovery and approval gates remain open. This document does not approve production business operations.

## Product domains
- Pharmacies: medicines, medical supplies and cosmetics across owner-identified locations.
- Specialized Contracting: a separate business domain whose project, contract, procurement and cost-control workflows remain to be defined.
- Shared platform: identity, organization reference data, audit, notifications and technical operations, subject to approved ownership and access boundaries.

## Implemented technical foundation
- ASP.NET Core 10 API with PostgreSQL 18 and EF Core/Npgsql.
- Next.js web shell with Overview, Organization, Pharmacies and Specialized Contracting routes.
- PostgreSQL-backed organization location reference register seeded with owner-provided location names.
- Native ASP.NET Core Identity and Next.js BFF session implementation are present on master; effective local Compose configuration defaults authentication off in Development. Real login, refresh/logout, authorization denial and account lifecycle must be tested before claiming enforced authentication.
- EDA regulatory-ingestion MVP is merged; one owner-provided VM scan log records five sources, 100 links, 12 new documents and zero failures. See architecture/eda-regulatory-ingestion.md for limitations.
- API readiness requires PostgreSQL reachability through both application and Identity contexts. Owner VM checks returned HTTP 200 for readiness and web-to-API system status on 2026-11-11.

## Current boundary
The application is a technical foundation, not a completed ERP. No production pharmacy or contracting operations are enabled. Pharmacy inventory is at Phase 0 discovery; see [inventory discovery](../delivery/pharmacy-inventory-discovery.md) and the [2026-11-14 Egypt inventory scan](../governance/egypt-pharmacy-inventory-scan-2026-11-14.md).

## Explicitly not implemented
- Product catalogue, suppliers, purchasing, receiving, batches/expiry, stock balances, transfers or inventory valuation.
- Dispensing/sales, provider contracts, patient copay/exemption, claims, remittances, patient balances or collections.
- Contracting projects, contracts, procurement, subcontractors, progress billing or project cost postings.
- General ledger, statutory accounting, tax, e-invoice or financial calculations.
- Mobile React Native client.
- Approved enterprise role/permission matrix, user lifecycle, MFA/recovery policy and sector/location resource authorization.
- Production deployment, backup/restore evidence or compliance certification.

## Approval boundaries
- Confirm registered legal identity, legal operators and location ownership/licensing with owner and qualified advisers.
- Obtain pharmacy-operations and accountant approval for stock workflows, transfer controls and costing.
- Obtain contracting-owner/accountant approval for project and commercial workflows.
- Obtain owner/security approval for user lifecycle, MFA/recovery, role catalogue and sector/location authorization.
- Do not treat UI labels, proposed models or technical implementation as evidence of legal or professional approval.
