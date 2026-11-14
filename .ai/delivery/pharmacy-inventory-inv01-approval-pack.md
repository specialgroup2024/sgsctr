# Pharmacy inventory INV-01 — reference-data approval pack

- Prepared: 2026-11-14.
- Status: **decision package only — no business or professional approval recorded**.
- Branch: feat/pharmacy-inventory-inv01-approval-pack.
- Purpose: make INV-01 implementation-ready without inventing pharmacy, regulatory, procurement or accounting policy.
- Prerequisites: read AGENT.md, AGENTS.md, .ai/README.md, dynamic role selection, deliberation protocol, pharmacy profile and Egypt compliance-review skill.

## 1. Phase boundary

INV-01 is limited to controlled reference data: product identity/catalogue, units and conversions, location metadata, and supplier master only to the extent explicitly approved under Q46. It does not include purchasing orders, receiving, stock balances, lots, movements, dispensing, transfers, valuation, claims or GL posting.

PR #29 is merged to master as commit 7114e0cd499e371d2e08c71f8f86bcd6148c6deb. The INV-00 UI exists at /pharmacies/inventory. It remains a non-posting prototype; no inventory API, entity, DbSet, migration or product records exist.

**Implementation gate:** Q37, Q38 and Q46 must be resolved by the owner and qualified pharmacy/regulatory/procurement reviewers before production catalogue persistence. The UI may be refined as a non-posting prototype, but no production schema, seed data, import or write endpoint is authorized by this pack.

## 2. Dynamic five-role deliberation

Profiles selected for this task:
- **Architect:** .NET modular-monolith and reference-data architect; owns bounded context, stable identifiers, extensibility and migration design.
- **Devil's Advocate:** data-integrity, application-security and regulatory-control challenger; tests duplicate identity, unsafe edits, false product classifications and unauthorized supplier changes.
- **Clueless Client:** hospital pharmacy storekeeper / pharmacist catalogue user; tests search, recognition, pack/unit clarity, barcode workflows and correction burden.
- **Subject Matter Expert:** pharmacy master-data and pharmaceutical supply-chain analyst, with Egyptian regulatory-source review. This is an analytical profile, not a licensed pharmacist or regulatory counsel.
- **Maestro:** senior platform/data architecture lead; determines technical sequencing only and cannot approve reserved business or professional decisions.

### Architect proposal

Use a Pharmacy-owned catalogue aggregate with a stable internal identifier, human-readable code, controlled category, lifecycle status and separately versioned product attributes. Model units and conversion definitions as explicit reference records, not free-text pack sizes. Keep regulatory identifiers and external codes in source-qualified identifier records. Keep supplier identity and authorization evidence in a separate supplier aggregate if Q46 approves it. Do not put stock quantities or costs in master data.

### Devil's Advocate challenge

A single flat product table can silently conflate medicines, chemotherapy products, medical devices/supplies and cosmetics. A barcode is not guaranteed to be globally unique at every packaging level, and supplier SKU is not a product identity. Replacing product attributes in place can corrupt historical interpretation. A supplier's uploaded licence is not proof that the licence is current or applicable. Duplicate imports can create parallel products or overwrite approved values.

### Clueless Client challenge

Operators need to find the exact item quickly by name, strength/form where applicable, brand/manufacturer, package and barcode. They must understand which unit is purchased, stored and issued. The UI must not ask a storekeeper to decide legal classification or guess a conversion. Corrections need a clear review path and visible change history; inactive products must remain searchable for historical records.

### SME analysis and revised proposal

Separate stable product identity from versioned descriptive/regulatory attributes, packaging identifiers and unit definitions. Category-specific fields should be enabled only after a qualified reviewer defines them. Keep source, evidence, reviewer, effective date and verification status for externally sourced identifiers/classification. Do not infer registration, controlled status, EPTTS applicability, storage conditions or clinical handling from product names or generic category labels. A catalogue import must enter a staging/review process and never activate records automatically.

### Maestro technical determination

Proceed with approval and data-dictionary preparation only. After approvals, implement reference-data-only endpoints and persistence with server-side authorization, audit, effective-dated changes, import staging, duplicate review and PostgreSQL tests. No stock or financial tables, costing, purchase workflow, receiving or production data mutation in INV-01. No default product catalogue should be seeded from assumptions.

## 3. Proposed reference-data boundaries (not approved fields)

| Record | Candidate attributes for review | Explicit exclusions |
|---|---|---|
| Product identity | Internal immutable ID, display name, owner-approved category, manufacturer/brand where known, active/retired state | No inferred EDA registration, clinical equivalence or sale/dispense authorization |
| Product details | Strength, dosage/form, presentation, device model/specification or cosmetic variant only where relevant and approved | No clinical instructions or treatment advice |
| External identifiers | Identifier type, value, issuer/source, packaging level, valid-from/to, verification status | Do not assume one barcode per product or global uniqueness without policy |
| Unit of measure | Code, label, dimension, precision/scale and active state | No implicit conversion based on text such as box/strip/bottle |
| Product-unit mapping | Product, unit, packaging level, exact conversion factor, effective dates, approval evidence | No rounding or fractional issue policy until approved |
| Supplier | Legal/trading name, approved supplier code, contacts, licence/authorization evidence reference and validity review status | No supplier approval based only on imported document or unverified claim |
| Location metadata | Existing organization location reference plus verified pharmacy role, legal operator, licence reference and status | No new legal/site classification without Q37 evidence |

Fields above are discussion candidates, not a schema contract. Product-specific regulatory classification and field requirements must be supplied by qualified reviewers for medicines, chemotherapy, devices/supplies and cosmetics separately.

## 4. Decisions required before implementation

| Gate | Decision required | Approver/evidence |
|---|---|---|
| Q37 | Classify Mokattam and each hospital site; identify licence holder, operator, activity and current licence scope | Owner + Egyptian regulatory/legal reviewer; licence copies |
| Q38 | Approve category taxonomy and product-specific mandatory fields, identifiers, lot/expiry/serial/GTIN applicability and permitted movement scope | Licensed pharmacist + quality + regulatory reviewer |
| Q46 | Approve exact INV-01 scope: product, unit, location and supplier fields; who can create/edit/retire; source/import authority; duplicate resolution | Owner + pharmacist + procurement |
| Identity | Decide internal SKU/code ownership, uniqueness scope, generation and reuse prohibition | Owner + pharmacy operations |
| Units | Approve purchase/storage/issue units, packaging levels, conversion precision and effective-date changes | Pharmacist + accountant |
| Supplier | Decide whether supplier master is included now, evidence types, verification owner and renewal workflow | Owner + procurement + regulatory reviewer |
| Access | Approve creator, editor, reviewer, approver and read-only roles by sector/location | Owner + security |
| Audit | Approve retention, change reason, evidence and who may view/export history | Owner + legal/security |

No approval is implied by a blank, suggested value or technical recommendation.

## 5. Candidate acceptance criteria after approval

- Every active record has a stable internal ID and an approved identity rule.
- Product categories and mandatory attributes follow the signed category-specific data dictionary.
- Packaging identifiers record their issuer/source and packaging level; duplicates are detected and reviewed, not silently merged.
- Unit conversions are explicit, exact, effective-dated and covered by tests; no free-text conversion is accepted.
- Imports are staged, provenance-preserving, validated and human-reviewed before activation.
- Changes to identifiers, category, conversion or supplier authorization preserve history and record actor, timestamp, reason and evidence reference.
- Retired records remain resolvable by historical references and cannot be silently reused.
- All writes are server-authorized and audited; location/sector boundaries are enforced server-side.
- No product or supplier record can create or alter stock, purchasing, pricing, valuation or financial postings in INV-01.
- PostgreSQL integration tests cover unique constraints, concurrent edits, duplicate detection, effective dates, rollback and authorization denial.

## 6. Regulatory and evidence boundary

The 2026-11-14 INV-00 scan records EDA GSDP v05/2025 and EDA pharmaceutical warehouse licensing guideline v05/2026, plus EPTTS Phase 1 FAQ v03/2026. These sources are not a substitute for site licences, product-specific determinations or qualified interpretation. Warehouse-specific requirements must not be generalized to hospital branches until Q37 is resolved. EPTTS applicability must not be inferred for every product or intra-group transfer. The in-app EDA monitor's latest live status was not checked in this documentation-only preparation; the last owner-provided scan remains 2026-11-11.

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

**INV-01 production implementation is blocked.** No signed pharmacist, regulatory, procurement or owner decision for Q37/Q38/Q46 is recorded in the repository. This pack is the completed safe preparation step; it is not a claim that product catalogue persistence has been implemented. Authentication verification and Data Protection volume verification remain on hold per owner instruction.
