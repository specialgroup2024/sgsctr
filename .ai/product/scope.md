# Product scope and phase boundaries

Status: technical foundation, application shell, organization reference workspace and generic INV-01 catalogue foundation are on master (PR #36). INV-02 provisional product-governance implementation is on branch `feat/inv02-regulated-product-profiles`; CI/runtime validation pending. Business discovery and professional gates remain open.

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
- Master has persistent generic Draft-only product identity, unit masters and exact rational conversion references, with API/BFF/UI and catalogue audit rows. INV-02 branch adds provisional family assignments, product-level identifier proposals, regulatory evidence references and activation/retirement review requests; all remain pending and do not activate products.
- API readiness requires PostgreSQL reachability through both application and Identity contexts. Owner VM checks returned HTTP 200 for readiness and web-to-API system status on 2026-11-11.

## Current boundary
The application is a technical foundation, not a completed ERP. No transactional pharmacy or contracting operations are enabled. The generic catalogue remains Draft-only. INV-02 review records do not approve family-specific mandatory fields or activate products. Q38 qualified review remains required before verified classification, regulated product attributes, traceability requirements or activation. Requirements and costing examples remain subject to owner and qualified professional review. See [UI implementation record](../delivery/pharmacy-inventory-ui-inv00.md), [requirements](../delivery/pharmacy-inventory-inv00-requirements.md) and [costing examples](../delivery/pharmacy-inventory-costing-worked-examples.md).

## Explicitly not implemented
- Master includes the generic Draft-only catalogue (PR #36). INV-02 branch adds provisional family, identifier, evidence and lifecycle review records only. Supplier master, purchasing, receiving, batches/expiry, stock balances, transfers and inventory valuation are not implemented.
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
