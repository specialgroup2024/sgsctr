# INV-01 reference-data dictionary — review draft

- Prepared: 2026-11-14 (Africa/Cairo).
- Status: technical proposal for review; not an approved schema or production contract.
- Scope approved by owner: product identity/catalogue, units and explicit packaging conversions, pharmacy-location reference metadata. Supplier master and transactional/financial workflows are excluded.

## 1. Decision boundary

This document turns the approved phase boundary into a reviewable candidate model. It does not authorize entities, migrations, seed data, imports, write endpoints or production data changes. Q38 category-specific requirements require a licensed pharmacist, quality and regulatory reviewer. Owner/security decisions on permissions, identity, imports and duplicate resolution also remain open.

The four owner-defined families are regular medicines, chemotherapy drugs, medical supplies/devices and cosmetics. Whether chemotherapy is a separate top-level category or a cross-cutting attribute is unresolved.

## 2. Proposed logical records

| Record | Candidate responsibility | Excluded |
|---|---|---|
| Product | Stable internal identity and lifecycle | Stock, price, clinical advice, dispense authorization |
| Product attribute revision | Effective-dated, source-backed descriptive/regulatory attributes | Silent historical overwrites |
| Product identifier | Identifier, namespace/issuer, packaging level, source, verification and validity | Assumed universal barcode uniqueness |
| Unit of measure | Controlled unit code, label, dimension and permitted precision | Free-text conversion |
| Product packaging/unit definition | Product-specific unit/package relationship and exact conversion | Unapproved procurement/issue rules |
| Pharmacy location reference | Existing organization location plus approved pharmacy metadata | Inferred legal/licence classification |

These are logical concepts only. Final aggregate boundaries and relational mapping require technical review.

## 3. Candidate common product identity fields

| Field | Candidate meaning | Approval gate |
|---|---|---|
| InternalProductId | Immutable system identifier | Technical proposal |
| InternalCode | Human-facing internal code/SKU | Owner + pharmacy operations: format, uniqueness, generation and non-reuse |
| DisplayName | Search/display name; Arabic/English variants if required | Owner + users |
| ProductFamily | Controlled family from approved taxonomy | Q38 pharmacist + quality + regulatory |
| Brand / manufacturer | As labelled or evidence-backed; nullable if unknown | Q38 and provenance rules |
| LifecycleStatus | Draft, under review, active, retired (candidate states) | Owner: activation/retirement authority |
| EffectiveFrom / EffectiveTo | Validity interval for approved revisions | Technical + business review |
| Source / evidence reference | Provenance of imported or externally verified attributes | Owner: accepted source policy |
| Created / updated metadata | Actor, UTC timestamps, revision/version | Security/audit approval |

Do not make every candidate field mandatory. Do not infer EDA registration, controlled status, prescription status, clinical equivalence, product approval, storage conditions or EPTTS applicability from a name or category.

## 4. Identifier model — candidate only

Keep identifiers separate from product identity. Candidate attributes: identifier type, value, issuing namespace/authority, packaging level, source document/reference, verification status, valid-from/to and reviewer.

- A barcode may identify a particular packaging level, not every pack of the same product.
- Duplicate detection must consider identifier namespace, packaging level and validity; no automatic merge.
- Preserve source and verification history; an unverified supplier spreadsheet is not authoritative.
- Medical-device UDI is a distinct regulated identifier model and must not be conflated with an ordinary retail barcode.
- Product/location identifiers used by EPTTS must be evaluated separately from this catalogue identifier model.

## 5. Units and packaging conversions

Candidate unit master: code, Arabic/English label, dimension, precision/scale and active status.

Candidate product-unit definition: product, unit, packaging level, exact conversion to a nominated base unit, validity interval, source/evidence, reviewer and status.

Open decisions:
- Which units represent procurement, storage, dispensing/issue and counting?
- Are fractional quantities allowed for each family and unit?
- What precision and conversion direction are permitted?
- Can pack definitions change over time, and how are old references preserved?
- Who approves conversion creation or correction?

No conversion may be inferred from words such as box, strip, bottle, vial or carton. Avoid floating-point conversion. A rational numerator/denominator representation is a technical candidate, not a selected implementation.

## 6. Pharmacy-location reference

Reuse the existing OrganizationLocation identity and API as the starting point; do not create a parallel location register without a demonstrated requirement. Candidate pharmacy-specific metadata is limited to owner-approved operational reference data.

Mokattam is owner-confirmed as an EDA-licensed pharmaceutical warehouse under Chairman Decree 725/2024, but its licence document/details are not verified in this repository. Student Hospital, Qasr El-Aini Hospital and Manial Hospital must each be classified separately. Do not set legal operator, licence holder, licence status or site type from inference.

## 7. Bounded Egyptian regulatory scan

Review timestamp: 2026-11-14 (Africa/Cairo). Official EDA sources checked:
- Warehouse licensing guideline EDREX:GL.CALI/CIP.002, v05, issued/effective 07/2026, under Chairman Decree 725/2024: https://edaegypt.gov.eg/media/gzxpsmon/الدليل-التنظيمى-لمخازن-الادوية_ar2026.pdf
- Medical-device UDI guideline EDREX:GL.CAMD.005, v02/2026, issued/effective 05/2026. It describes UDI-DI and UDI-PI, packaging-level identification and device-specific scope: https://edaegypt.gov.eg/media/v5ci5unc/5-gl-udi-1-_up-6-2026.pdf
- EPTTS Phase 1 FAQ EDREX:NP.CIP.009, v03/2026, dated 23-Apr-2026. It describes Phase 1 scope for human/biological medicinal products, importer reporting accountability, GTIN/serial/expiry/lot elements and secondary-pack serialization: https://edaegypt.gov.eg/media/fs1folht/egyptian-track-trace-for-pharmaceutical-eptts-technical-faq-v3_20262.pdf
- EDA notice-to-applicant index lists EPTTS materials and July 2026 implementation/operating documents: https://edaegypt.gov.eg/en/the-regulatory-reference-of-the-egyptian-drug-authority-eda/notice-to-applicant/notice-to-applicant-central-administration-for-inspection-of-pharmaceutical-establishments/

Impact: keep ordinary product identifiers, device UDI and EPTTS product/location identifiers distinct. The catalogue may store source-qualified identifiers, but this draft does not define reporting obligations or certify applicability. The warehouse guide must not be generalized to hospital branches. The in-app EDA monitor was not checked during this repository-only task; latest owner-provided scan remains 2026-11-11. UPA and other non-EDA sources were not rechecked in this bounded review.

## 8. Five-role technical deliberation

- Architect — .NET/EF Core/PostgreSQL reference-data architect: reuse Pharmacy ownership and existing OrganizationLocation; separate stable identity, identifiers, unit definitions and effective-dated attributes.
- Devil's Advocate — data-integrity/security reviewer: flat tables, global barcode uniqueness, floating-point conversions, silent merges and editable historical values are serious corruption risks.
- Clueless Client — hospital pharmacy catalogue user: search should support Arabic/English names and common identifiers; pack/unit labels must be clear; unknown values must be visibly unknown, not guessed.
- SME — pharmaceutical master-data / Egyptian regulatory evidence analyst: device UDI and EPTTS have different scopes; product-family-specific fields require qualified review. This is not licensed sign-off.
- Maestro — platform architecture lead: approve this as a review draft only; defer schema/API implementation until Q38, identity, access, import and audit decisions are approved.

## 9. Technical direction for review

If gates are satisfied, prefer Pharmacy-owned reference-data tables in the existing ASP.NET Core / EF Core / PostgreSQL application. Use stable IDs, controlled vocabularies, source-qualified identifiers, explicit unit conversions, effective-dated revisions, optimistic concurrency and server-side authorization. Keep location reads linked to Organization API; the browser must not access PostgreSQL.

The inspected AppDbContext contains OrganizationLocations and Regulatory Intelligence sets only. OrganizationLocation currently has ID, code, name, sector, location type, notes, record status, active flag and timestamps. No product entity, inventory DbSet, product API or inventory migration was found in the inspected master tree.

## 10. Acceptance tests to design after approval

- Stable IDs and internal-code uniqueness follow approved scope; retired codes cannot be silently reused.
- Identifier duplicates are detected by approved namespace/packaging rules and sent to review.
- Attribute revisions preserve prior values and provenance.
- Unit conversions are exact, effective-dated and reject invalid/ambiguous ratios.
- Concurrent edits detect stale versions.
- Location metadata cannot change legal/licence classification without approved evidence.
- Unauthenticated, unauthorized and cross-location writes are denied server-side.
- No catalogue operation creates stock, purchasing, receipt, dispensing, costing or accounting effects.

## 11. Required decisions before production implementation

1. Q38: signed family taxonomy and required/optional fields for each family; chemotherapy modelling; regulatory identifiers; batch/expiry/serial/GTIN relevance; storage and movement implications.
2. Internal code: format, owner, uniqueness scope, generation and non-reuse.
3. Unit model: base unit, package levels, conversion precision, fractional quantities and effective-date policy.
4. Identity/provenance: authoritative sources by field, evidence requirements and verification states.
5. Access: creator, editor, reviewer, approver and read-only permissions by sector/location.
6. Duplicate resolution: matching rules, merge authority, conflict workflow and audit.
7. Audit: event catalogue, retention, evidence references, access and export policy.
8. Import: whether any initial import is approved, accepted sources, staging, validation and activation authority.

Until these are signed, this remains a design artifact. No production schema, API, migration, seed data or import is authorized.
