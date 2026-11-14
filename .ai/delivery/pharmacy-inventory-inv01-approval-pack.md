# Pharmacy inventory INV-01 — reference-data approval pack

- Prepared: 2026-11-14.
- Status: **generic catalogue foundation owner-authorized and implemented on branch `feat/inv01-generic-product-catalogue`; Q38 professional review remains pending; branch is not merged or runtime-verified**.
- Purpose: record the approved scope without inventing pharmacy, regulatory, procurement or accounting policy.
- Prerequisites: read AGENT.md, AGENTS.md, .ai/README.md, dynamic role selection, deliberation protocol, pharmacy profile and Egypt compliance-review skill.

## 1. Phase boundary

On 2026-11-14, the owner explicitly approved this initial INV-01 scope in ChatGPT:

- Persistent pharmacy product catalogue and product identity.
- Units of measure and explicit packaging conversions.
- Pharmacy-location reference metadata.
- Supplier master data is **deferred and excluded** from this approval; it requires a separate decision.

INV-01 does not include purchasing orders, receiving, stock balances, lots, movements, dispensing, transfers, valuation, claims or GL posting.

PR #29 is merged to master as commit 7114e0cd499e371d2e08c71f8f86bcd6148c6deb. The INV-00 UI was extended on the current feature branch with the generic draft catalogue. The branch adds generic product, unit, conversion and catalogue-audit persistence/API/BFF/UI; it is not yet merged or runtime-verified.

**Approval meaning:** the owner has approved the phase boundary and the general implementation principles listed below. This does not approve the detailed product data dictionary, category-specific mandatory fields, regulatory classification, internal-code semantics, create/edit/retire permissions, import sources, duplicate-resolution rules, supplier master, or any stock/financial workflow.

**Implementation gate and owner-approved carve-out:** Q38 product taxonomy and family-specific mandatory fields still require qualified pharmacist, quality and regulatory review. On 2026-11-14 the owner explicitly authorized generic implementation while Q38 remains pending. This latest approval supersedes the earlier blanket implementation hold only for the category-neutral, draft-only foundation described in section 11. It does not waive Q38 or authorize regulated fields, identifiers, classification, activation, import, supplier, stock or financial workflows.

### Owner approvals recorded — 2026-11-14

The owner explicitly approved the following implementation directions in ChatGPT:
- Product identity/catalogue: proceed with a persistent product identity and catalogue within the INV-01 boundary. Exact internal-code format, uniqueness scope, category taxonomy and duplicate-resolution behavior remain undecided.
- Units and packaging: model units of measure and explicit packaging conversions. Precision, fractional quantities, rounding, effective-date behavior and family-specific applicability remain subject to detailed technical and qualified review.
- Security and audit: protected catalogue operations must use server-side authorization and auditable changes. The exact role/permission matrix, event catalogue, retention, evidence and export rules remain to be specified and reviewed.
- Implementation: proceed with the generic catalogue foundation while Q38 is pending, preserving the restrictions in section 11. This is an explicit owner-approved carve-out from the earlier blanket persistence hold, not a waiver of professional review.

These approvals are owner-level direction, not pharmacist, quality, regulatory, legal or accounting sign-off. No family-specific fields or operational rules are approved by them.

## 2. Dynamic five-role deliberation

Profiles selected for this task:
- **Architect:** .NET modular-monolith and reference-data architect; owns bounded context, stable identifiers, extensibility and migration design.
- **Devil's Advocate:** data-integrity, application-security and regulatory-control challenger; tests duplicate identity, unsafe edits, false product classifications and unauthorized supplier changes.
- **Clueless Client:** hospital pharmacy storekeeper / pharmacist catalogue user; tests search, recognition, pack/unit clarity, barcode workflows and correction burden.
- **Subject Matter Expert:** pharmacy master-data and pharmaceutical supply-chain analyst, with Egyptian regulatory-source review. This is an analytical profile, not a licensed pharmacist or regulatory counsel.
- **Maestro:** senior platform/data architecture lead; determines technical sequencing only and cannot approve reserved business or professional decisions.

### Architect proposal

Use a Pharmacy-owned catalogue aggregate with a stable internal identifier, human-readable code, controlled category, lifecycle status and separately versioned product attributes. Model units and conversion definitions as explicit reference records, not free-text pack sizes. Keep regulatory identifiers and external codes in source-qualified identifier records. Do not put stock quantities or costs in master data.

### Devil's Advocate challenge

A single flat product table can silently conflate medicines, chemotherapy products, medical devices/supplies and cosmetics. A barcode is not guaranteed to be globally unique at every packaging level, and supplier SKU is not a product identity. Replacing product attributes in place can corrupt historical interpretation. Duplicate imports can create parallel products or overwrite approved values.

### Clueless Client challenge

Operators need to find the exact item quickly by name, strength/form where applicable, brand/manufacturer, package and barcode. They must understand which unit is purchased, stored and issued. The UI must not ask a storekeeper to decide legal classification or guess a conversion. Corrections need a clear review path and visible change history; inactive products must remain searchable for historical records.

### SME analysis and revised proposal

Separate stable product identity from versioned descriptive/regulatory attributes, packaging identifiers and unit definitions. Category-specific fields should be enabled only after a qualified reviewer defines them. Keep source, evidence, reviewer, effective date and verification status for externally sourced identifiers/classification. Do not infer registration, controlled status, EPTTS applicability, storage conditions or clinical handling from product names or generic category labels. A catalogue import must enter a staging/review process and never activate records automatically.

### Maestro technical determination — updated by owner authorization 2026-11-14

Implement only category-neutral draft product identity, unit masters, exact rational product-unit conversion references, server-side authorization and application-layer append-only audit events. Do not add family-specific fields, external identifiers, activation/retirement, import staging, suppliers, stock, purchasing, receiving or financial behavior. No default product or unit catalogue is seeded.

## 3. Proposed reference-data boundaries (not approved fields)

| Record | Candidate attributes for review | Explicit exclusions |
|---|---|---|
| Product identity | Internal immutable ID, display name, owner-approved category, manufacturer/brand where known, active/retired state | No inferred EDA registration, clinical equivalence or sale/dispense authorization |
| Product details | Strength, dosage/form, presentation, device model/specification or cosmetic variant only where relevant and approved | No clinical instructions or treatment advice |
| External identifiers | Identifier type, value, issuer/source, packaging level, valid-from/to, verification status | Do not assume one barcode per product or global uniqueness without policy |
| Unit of measure | Code, label, dimension, precision/scale and active state | No implicit conversion based on text such as box/strip/bottle |
| Product-unit mapping | Product, unit, packaging level, exact conversion factor, effective dates, approval evidence | No rounding or fractional issue policy until approved |
| Location metadata | Existing organization location reference plus verified pharmacy role, legal operator, licence reference and status | No new legal/site classification without Q37 evidence |

Fields above are discussion candidates, not a schema contract. Supplier master is excluded from the approved initial scope. Product-specific regulatory classification and field requirements must be supplied by qualified reviewers for medicines, chemotherapy, devices/supplies and cosmetics separately.

## 4. Decisions required before implementation

| Gate | Decision required | Approver/evidence |
|---|---|---|
| Q37 | Mokattam is owner-confirmed as an EDA-licensed pharmaceutical warehouse under Chairman Decree 725/2024. Verify current licence number/copy, holder, operator, validity, address and scope; classify each hospital branch separately | Owner confirmation recorded 2026-11-14; documentary check by Egyptian regulatory/legal reviewer remains required |
| Q38 | Approve category taxonomy and product-specific mandatory fields, identifiers, lot/expiry/serial/GTIN applicability and permitted movement scope | Licensed pharmacist + quality + regulatory reviewer |
| Q46 | Initial phase boundary approved: product catalogue/identity, units/conversions and pharmacy-location reference metadata; supplier master deferred; transactional inventory and financial workflows excluded | Owner approval in ChatGPT, 2026-11-14. Detailed fields, permissions, imports and duplicate resolution remain open |
| Identity | Decide internal SKU/code ownership, uniqueness scope, generation and reuse prohibition | Owner + pharmacy operations |
| Units | Approve purchase/storage/issue units, packaging levels, conversion precision and effective-date changes | Pharmacist + accountant |
| Supplier | Decide separately whether supplier master should be included in a later phase, evidence types, verification owner and renewal workflow | Owner + procurement + regulatory reviewer |
| Access | Approve creator, editor, reviewer, approver and read-only roles by sector/location | Owner + security |
| Audit | Approve retention, change reason, evidence and who may view/export history | Owner + legal/security |

No approval is implied by a blank, suggested value or technical recommendation.

## 5. Candidate acceptance criteria after approval

- Every active record has a stable internal ID and an approved identity rule.
- Product categories and mandatory attributes follow the signed category-specific data dictionary.
- Packaging identifiers record their issuer/source and packaging level; duplicates are detected and reviewed, not silently merged.
- Unit conversions are explicit, exact, effective-dated and covered by tests; no free-text conversion is accepted.
- Imports are staged, provenance-preserving, validated and human-reviewed before activation.
- Changes to identifiers, category or conversion preserve history and record actor, timestamp, reason and evidence reference.
- Retired records remain resolvable by historical references and cannot be silently reused.
- All writes are server-authorized and audited; location/sector boundaries are enforced server-side.
- No product record can create or alter stock, purchasing, pricing, valuation or financial postings in INV-01.
- PostgreSQL integration tests cover unique constraints, concurrent edits, duplicate detection, effective dates, rollback and authorization denial.

## 6. Regulatory and evidence boundary

The 2026-11-14 INV-00 scan records EDA GSDP v05/2025, EDA pharmaceutical warehouse licensing guideline v05/2026 (EDREX:GL.CALI/CIP.002, issue 5, July 2026), and EPTTS Phase 1 FAQ v03/2026. EDA's official guideline identifies Chairman Decree 725/2024 as its legal basis. The owner confirmed on 2026-11-14 that Mokattam is licensed by EDA as a pharmaceutical warehouse under that decree. This is owner-provided information; the licence itself, licence holder, operator, validity, approved activities and exact scope have not yet been inspected or independently verified. Apply warehouse-specific analysis to Mokattam provisionally, subject to licence verification. Do not generalize this classification to Student Hospital, Qasr El-Aini Hospital or Manial Hospital; each site's legal operator and licence/activity must be established separately. EPTTS applicability must not be inferred for every product or intra-group transfer. Official EDA sources: warehouse guideline https://edaegypt.gov.eg/media/gzxpsmon/الدليل-التنظيمى-لمخازن-الادوية_ar2026.pdf and Decree 725/2024 https://edaegypt.gov.eg/media/op1iuxvk/minestreal-decree-725-2024.pdf. The in-app EDA monitor's latest live status was not checked; last owner-provided scan remains 2026-11-11.

Before implementation, repeat the mandatory current Egyptian primary-source review under .ai/skills/egypt-compliance-review/SKILL.md, inspect the in-app monitor if deployed, record source failures/coverage, and update the evidence and requirements registers. Do not treat a search result, supplier file or market article as a legal determination.

## 7. Remaining implementation and release sequence

1. Review the generic implementation branch and the proposed technical ADR; resolve any code-review findings.
2. Run .NET build/tests, Next.js typecheck/build, PostgreSQL migration upgrade test and browser/API smoke tests in the repository environment.
3. Verify audit persistence and Administrator-only write authorization; define the final role matrix and audit retention/export policy before production release.
4. Complete Q38 with qualified pharmacist, quality and regulatory reviewers before adding family-specific fields, identifiers, classifications or activation.
5. Resolve detailed product identity, import provenance, duplicate-resolution and Q37 site metadata decisions before expanding the model.
6. Obtain owner acceptance and a separate release decision. Do not merge or deploy without the required review and explicit release authorization.

## 8. Current disposition

**The generic INV-01 foundation is implemented on a review branch, not yet merged or runtime-verified.** The branch contains draft-only product identity, unit masters, exact product-unit conversion references, API/BFF/UI, additive EF migration and catalogue audit events. No product/unit seed data was added. Q38 remains OPEN; Q37 documentary verification remains pending. Detailed code/duplicate, permission, audit retention/export and import decisions remain open. Authentication and Data Protection verification remain on hold per owner instruction.


## 9. INV-01 next-phase review artifacts

The owner-approved boundary has been translated into two review-only artifacts:
- [Candidate reference-data dictionary](pharmacy-inventory-inv01-data-dictionary-draft.md) — logical records, candidate common fields, identifier separation, unit/conversion questions, location boundary, technical direction and acceptance-test proposals.
- [Q38 qualified review worksheet](pharmacy-inventory-inv01-q38-review-worksheet.md) — family-by-family pharmacist, quality and regulatory decisions.

These documents are proposals, not approved schema or production contracts. The 2026-11-14 bounded EDA source refresh identified the current medical-device UDI guideline EDREX:GL.CAMD.005 v02/2026 in addition to the warehouse licensing guideline and EPTTS Phase 1 FAQ already recorded. Device UDI, ordinary barcodes and EPTTS identifiers must remain distinct. See the data dictionary for exact source URLs and limitations.

Next gate: complete and sign Q38 with qualified human reviewers; then resolve internal code, unit model, provenance, permissions, duplicate-resolution, audit and import decisions. Only after those decisions and technical/security review may production persistence be designed for implementation.


## 10. Q38 evidence assessment update — 2026-11-14

A bounded EDA-primary-source desk assessment for regular human medicines, chemotherapy, medical supplies/devices and cosmetics is recorded at .ai/delivery/pharmacy-inventory-inv01-q38-evidence-assessment.md. It distinguishes human-product registration, EPTTS, medical-device UDI and cosmetics notification/claims evidence and proposes family-specific catalogue considerations.

This is an AI-assisted evidence assessment, not qualified pharmacist, quality, regulatory-affairs or legal sign-off. Q38 remains OPEN. The professional worksheet at .ai/delivery/pharmacy-inventory-inv01-q38-review-worksheet.md remains uncompleted and must be validated by designated qualified reviewers. No production fields, activation rules, storage rules, regulatory applicability or stock controls are approved by this assessment.


## 11. Generic implementation boundary — owner-approved 2026-11-14

The owner explicitly answered yes to proceeding with generic implementation while Q38 remains pending. This authorization is limited to:
- Generic product display name, immutable UUID and Draft-only status; free-text descriptions are excluded to avoid storing unreviewed regulatory or clinical attributes.
- Generic unit code/name/symbol.
- Product-scoped unit conversions stored as positive, reduced integer numerator/denominator pairs. The API does not calculate quantities or apply rounding.
- Authenticated reads; Administrator-role writes as a temporary least-privilege control pending the final role matrix.
- Catalogue audit rows written in the same EF SaveChanges transaction as the associated catalogue change. Audit is append-only by application behavior only; no tamper-proof or retention claim is made.
- No seed products or units, imports, human SKU, barcode/GTIN/UDI/EPTTS identifiers, family/category fields, registration/notification fields, storage, lot, serial, expiry, clinical or claims fields.
- No product activation, retirement or deletion. Product and conversion status is always Draft.
- No supplier master, purchasing, receiving, stock, dispensing, transfer, valuation, claims, accounting or GL workflow.
- Location metadata is not changed by this branch; Q37 site licensing classification remains pending.

Implementation branch: `feat/inv01-generic-product-catalogue`. Application build, test execution, migration execution and VM/browser verification have not yet been performed through the available repository connection. This branch is a code implementation proposal awaiting CI/review, not a production release.
