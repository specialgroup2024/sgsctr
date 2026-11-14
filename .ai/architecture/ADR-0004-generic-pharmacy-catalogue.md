# ADR-0004 — generic draft-only pharmacy catalogue foundation

- Status: **proposed technical design; generic implementation explicitly owner-authorized on 2026-11-14; code review and runtime validation pending**.
- Scope: INV-01 category-neutral product identity, unit reference and exact conversion reference only.
- Owner boundary: see [INV-01 approval pack](../delivery/pharmacy-inventory-inv01-approval-pack.md).

## Context

The owner authorized a persistent catalogue, units and packaging conversions, server-side authorization and audit. The owner later explicitly authorized a generic implementation while Q38 remains pending. Q38 still requires qualified pharmacist, quality and Egyptian regulatory review for regular medicines, chemotherapy, medical supplies/devices and cosmetics. The technical design must not encode those unreviewed decisions.

Repository baseline: ASP.NET Core 10, EF Core/Npgsql, PostgreSQL 18 and Next.js 15.5.7. Existing AppDbContext and Next.js BFF are reused.

## Decision proposal

1. Keep generic catalogue persistence in the existing Pharmacy API/AppDbContext.
2. Product identity consists only of immutable UUID, display name, Draft status, version and creation/update metadata. No free-text description is stored in this generic phase. UUID is not a human SKU or external identifier.
3. Unit master contains code, name and optional symbol. Code is normalized to uppercase and unique.
4. Product-unit conversion stores a product, source unit, target unit and positive reduced integer numerator/denominator. Meaning: one source unit equals numerator divided by denominator target units. The API stores the ratio; it does not calculate quantities, round, or validate dimensional compatibility.
5. Product and conversion records are always Draft. There is no activation, retirement or deletion endpoint.
6. API authorization protects reads. Administrator role is the interim write permission when authentication is enabled; only in Development with Authentication:Enabled=false, the existing local-development mode may write. Production cannot disable authentication. Final role/location matrix remains open.
7. Catalogue change and audit event are saved together in one EF Core SaveChanges transaction. Audit rows are append-only by application behavior, not claimed tamper-proof. Retention/export and database-level tamper-evidence remain unapproved.
8. Use Next.js server-side BFF routes; browser never connects to PostgreSQL.
9. Additive PostgreSQL migration only; no seed data.

## Implemented branch scope

Branch: `feat/inv01-generic-product-catalogue`.

- Entities: CatalogueProduct, UnitOfMeasure, ProductUnitConversion, CatalogueAuditEvent.
- API: authorization-protected product/unit/conversion read endpoints; Administrator-only writes when authentication is enabled, with the existing local Development/authentication-disabled exception.
- UI: product search, create/edit draft product, create unit and add draft conversion.
- Tests added for ratio normalization and unit-code normalization.
- No product-family/category fields, internal SKU, barcode/GTIN/UDI/EPTTS, registration/notification, manufacturer, strength, dosage/form, batch, serial, expiry, storage, pricing or clinical data.
- No supplier, purchasing, receiving, stock, dispensing, transfers, valuation, claims, accounting or GL.
- No location metadata changes.

## Alternatives considered

- Wait for all Q38 review before any schema: rejected for the generic-only scope because the owner explicitly authorized this limited carve-out.
- Add one flat product table with all four families and nullable fields: rejected because it silently embeds unreviewed family assumptions.
- Add a flexible JSON regulatory-attributes bag: rejected because it weakens validation, queryability and provenance and invites unreviewed fields.
- Use decimal conversion factors: rejected for this draft reference layer because exact integer ratios avoid binary floating-point representation. No conversion arithmetic is enabled.

## Risks and unresolved decisions

- Administrator-only writes may be too narrow or too broad; the local Development exception is not a production control. Final role/sector/location permissions need owner/security approval.
- Unit code semantics, dimensions and compatibility rules are not approved.
- Ratio values are bounded to browser-safe positive integers; no arithmetic engine uses them.
- Product name duplicates are allowed; no automatic merge or identity resolution is attempted.
- Audit retention, export, database-level tamper resistance and legal evidentiary requirements remain open.
- Q37 site classification and Q38 product-family review remain open.
- EF migration generation parity, build, test execution, PostgreSQL upgrade and browser/API verification are pending CI/runtime access.

## Acceptance and release gates

- CI: .NET build/test, web typecheck/build, Markdown line-limit check.
- PostgreSQL: apply additive migration against a preserved database; verify no existing migration history or data is reset.
- API: authenticated read; non-Administrator write denied when authentication is enabled; Administrator write succeeds; local Development/authentication-disabled writes remain local-only; invalid/duplicate units and invalid ratios rejected; product version conflict rejected.
- Audit: create/update/unit/conversion events commit atomically with resource changes; no sensitive payloads are stored.
- UI: read persisted records, create/edit draft product, create units and add draft conversions; display Q38 pending and no operational use.
- Owner acceptance and explicit merge/release decision required. Q38 professional sign-off is required before family-specific extensions or product activation.

## Approval boundary

Owner approval authorizes implementation of the generic foundation only. This ADR is not professional pharmacy, quality, regulatory, legal, accounting or tax approval. It does not establish product registration, legal classification, safe handling, storage, dispensability, stock transfer permission or compliance.
