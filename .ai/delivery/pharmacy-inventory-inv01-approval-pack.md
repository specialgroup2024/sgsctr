# Pharmacy inventory INV-01 — reference-data approval pack

- Prepared: 2026-11-14.
- Status: **initial reference-data boundary owner-approved on 2026-11-14; Q38 professional review and detailed field/permission decisions remain pending**.
- Purpose: record the approved scope without inventing pharmacy, regulatory, procurement or accounting policy.
- Prerequisites: read AGENT.md, AGENTS.md, .ai/README.md, dynamic role selection, deliberation protocol, pharmacy profile and Egypt compliance-review skill.

## 1. Phase boundary

On 2026-11-14, the owner explicitly approved this initial INV-01 scope in ChatGPT:

- Persistent pharmacy product catalogue and product identity.
- Units of measure and explicit packaging conversions.
- Pharmacy-location reference metadata.
- Supplier master data is **deferred and excluded** from this approval; it requires a separate decision.

INV-01 does not include purchasing orders, receiving, stock balances, lots, movements, dispensing, transfers, valuation, claims or GL posting.

PR #29 is merged to master as commit 7114e0cd499e371d2e08c71f8f86bcd6148c6deb. The INV-00 UI exists at /pharmacies/inventory. It remains a non-posting prototype; no inventory API, entity, DbSet, migration or product records exist.

**Approval meaning:** the owner has approved the phase boundary only. This does not approve the detailed product data dictionary, category-specific mandatory fields, regulatory classification, create/edit/retire permissions, import sources, duplicate-resolution rules, supplier master, or any stock/financial workflow.

**Implementation gate:** Q38 product taxonomy and mandatory fields still require qualified pharmacist, quality and regulatory review. The owner-approved scope does not waive professional approval, security review, or the remaining detailed design decisions. No production schema, seed data, import or write endpoint is authorized until the Q38 review and detailed implementation gates are recorded. The UI may be refined as a non-posting prototype.

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

### Maestro technical determination

Proceed with approval and data-dictionary preparation only. After required approvals, implement reference-data-only endpoints and persistence with server-side authorization, audit, effective-dated changes, import staging, duplicate review and PostgreSQL tests. No stock or financial tables, costing, purchase workflow, receiving or production data mutation in INV-01. No default product catalogue should be seeded from assumptions.

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

## 7. Implementation sequence after signed approvals

1. Freeze the approved data dictionary and Q37 site register as versioned decision records.
2. Inspect current API patterns, Identity authorization, audit facilities, AppDbContext, migrations, tests and web BFF again at implementation time.
3. Produce an ADR and reviewable logical schema; obtain technical/security review.
4. Implement domain validation and unit tests before persistence.
5. Implement EF Core entities, DbSets, migration and PostgreSQL constraints; review generated SQL and test upgrade/rollback strategy without resetting existing data.
6. Add authorized API/BFF read/write endpoints, audit and import staging; keep activation/review states explicit.
7. Add catalogue screens with search, duplicate-review and controlled edit workflows; remove disabled controls only for approved actions.
8. Run build, unit/integration/security tests and VM/browser verification; obtain user acceptance before release.

## 8. Current disposition

**The initial INV-01 scope boundary is owner-approved; production implementation remains gated.** The approved boundary is product catalogue/identity, units/conversions and pharmacy-location reference metadata. Supplier master is deferred. Q38 product taxonomy and mandatory fields still require qualified pharmacist, quality and regulatory review. Detailed field, permission, import-source and duplicate-resolution decisions remain to be approved. Q37 Mokattam licence details and other-site classifications remain pending documentary/regulatory verification. This pack is a scope-approval record, not a claim that product catalogue persistence has been implemented. Authentication verification and Data Protection volume verification remain on hold per owner instruction.


## 9. INV-01 next-phase review artifacts

The owner-approved boundary has been translated into two review-only artifacts:
- [Candidate reference-data dictionary](pharmacy-inventory-inv01-data-dictionary-draft.md) — logical records, candidate common fields, identifier separation, unit/conversion questions, location boundary, technical direction and acceptance-test proposals.
- [Q38 qualified review worksheet](pharmacy-inventory-inv01-q38-review-worksheet.md) — family-by-family pharmacist, quality and regulatory decisions.

These documents are proposals, not approved schema or production contracts. The 2026-11-14 bounded EDA source refresh identified the current medical-device UDI guideline EDREX:GL.CAMD.005 v02/2026 in addition to the warehouse licensing guideline and EPTTS Phase 1 FAQ already recorded. Device UDI, ordinary barcodes and EPTTS identifiers must remain distinct. See the data dictionary for exact source URLs and limitations.

Next gate: complete and sign Q38 with qualified human reviewers; then resolve internal code, unit model, provenance, permissions, duplicate-resolution, audit and import decisions. Only after those decisions and technical/security review may production persistence be designed for implementation.
