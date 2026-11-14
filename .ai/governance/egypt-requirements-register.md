# Egyptian requirements register

Status: discovery register; entries require evidence and applicability review. It is not legal advice or a compliance certificate.

## Requirement record format

For each requirement record: ID; title; affected sector/module/process; issuing authority; instrument/document number and version; source class; original Arabic and translation; publication date; effective date; amendments/supersession; applicability rationale; affected legal entity/location/product; mandatory/guidance/draft status; control or requirement; evidence URL and page/article; professional reviewer; owner approval; implementation/test mapping; status; next review date.

## Initial discovery domains

| Domain | Initial authority/source to investigate | Applicability gate |
|---|---|---|
| Pharmacy profession and establishment operation | EDA, MOHP, Official Gazette; Pharmacy Practice Law No. 127/1955 and current amendments/instruments | Verify current consolidated law, licence holder, activity and site. |
| EDA regulatory framework | EDA; Law No. 151/2019 and executive instruments | Verify relevant EDA remit and later amendments. |
| Controlled/narcotic and misuse-potential products | EDA, MOHP, Official Gazette; Law No. 182/1960 and current schedules/amendments | Product classification and current schedules must be verified by qualified professionals. |
| Product registration, pricing and circulation | EDA and original official instruments | Verify product authorization, applicable price basis and effective notices. |
| Pharmacovigilance, safety alerts and recalls | EDA/EPVC and marketing authorization holder | Determine pharmacy reporting, quarantine and escalation obligations. |
| Storage, distribution, traceability and transport | EDA guidance and applicable laws/decrees | Verify product type, establishment role, location and current guidance. |
| Medical devices and supplies | EDA medical-device directorate and applicable instruments | Distinguish devices, consumables and products with different classifications. |
| Cosmetics | EDA and applicable Egyptian instruments | Verify product classification, registration/notification, claims and facility obligations. |
| Waste and hazardous products | EDA, MOHP, Ministry of Environment and applicable authorities | Verify waste stream, facility role and licensed contractor obligations. |
| Tax, VAT and e-invoice/e-receipt | ETA, Ministry of Finance and Official Gazette | Requires legal-entity, activity and transaction-specific tax review. |
| Privacy and health data | Applicable Egyptian data-protection law, competent authority and official instruments | Requires data mapping, role, purpose, lawful basis and counsel review. |
| Public payer/insurance contracts | Relevant payer, UHIA, HIO/other authority and signed contract | Contract and scheme-specific; never assume universal reimbursement. |
| Competition, consumer and advertising | ECA, CPA, EDA and applicable laws | Determine product, conduct, channel and entity applicability. |

This list is a discovery map, not a complete statement of current law. Verify current text, amendments and effective dates before creating implementation requirements.

## Decision status

Use: discovered, source-verified, applicability-pending, professional-review, owner-approved, implemented, tested, superseded, rejected or unverified. Never move directly from discovery to implemented.

## Change-control rule

A new or amended requirement must be linked to the source evidence, impact assessment, qualified review, owner decision, implementation work package and acceptance tests. Retain historical versions and effective dates. No legal rule may be silently overwritten.


## Inventory evidence mapped — discovered, applicability pending

| ID | Evidence / requirement area | Candidate control | Status and gate |
|---|---|---|---|
| INV-REG-01 | EDA GSDP v05/2025, stock control 12.1–12.4 | Update stock records after each operation; periodic physical reconciliation; investigate discrepancies/CAPA; monitor expiry/retest. | Source-verified guidance; site/product applicability and SOP review pending. |
| INV-REG-02 | EDA GSDP v05/2025, receipt/storage 13.2–13.3 | Supplier eligibility, product/batch/expiry/quantity/packaging/transport checks; separate nonconforming stock; store per label. | Source-verified guidance; pharmacist/regulatory review pending. |
| INV-REG-03 | EDA GSDP v05/2025, returns/recalls 10–11 | Quarantine returns; qualified disposition; isolate recalled stock; trace and reconcile quantities. | Source-verified guidance; approved SOP and reviewer assignment pending. |
| INV-REG-04 | EDA warehouse licensing EDREX:GL.CALI/CIP.002 v05/2026 | For covered licensed medicine warehouses: electronic record system, retrieval of stock/supplier/customer and invoice information, at least five-year retention of inbound/outbound invoices and supporting documents; batch/manufacture/expiry identification. | Official Arabic guide found; site class/licence and legal applicability pending. Do not generalize to all pharmacy branches. |
| INV-REG-05 | EDA EPTTS FAQ EDREX:NP.CIP.009 v03/2026 | Phase 1 serialization/reporting data for covered human/biological pharmaceutical products; importer accountability; CSV initial submission model. | Official technical guidance found; Special Group role/product/location applicability pending. |
| INV-REG-06 | EDA 2026 guidance index: misuse-potential products and reserve antibiotics | Product-specific handling/dispensing controls may affect catalogue classification and access. | Index verified; full Arabic instruments and SKU-level mapping pending. |

Source evidence, exact URLs, dates and limitations are recorded in [the 2026-11-14 inventory scan](egypt-pharmacy-inventory-scan-2026-11-14.md). No entry is marked owner-approved or implemented.

## INV-01 generic catalogue safeguard — 2026-11-14

This is an internal design control derived from the bounded EDA source review, not a new legal requirement: keep generic product identity and unit reference data separate from product-family regulatory evidence. EDA's current public indexes and UDI guideline distinguish human pharmaceutical registration, medical-device UDI, cosmetics notification/claims and EPTTS requirements. Therefore the generic implementation contains no product-family classification, registration/notification status, UDI/GTIN/EPTTS identifiers, lot/serial/expiry, storage or activation rules. Q38 qualified reviewers must define applicability and required fields before those are added. See [catalogue-specific Egypt scan](egypt-pharmacy-catalogue-scan-2026-11-14.md) and [ADR-0004](../architecture/ADR-0004-generic-pharmacy-catalogue.md).
