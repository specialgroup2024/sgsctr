# INV-01 Q38 — four-family evidence assessment

- Review date: 2026-11-14 (Africa/Cairo).
- Status: **AI-assisted regulatory/master-data desk assessment; NOT qualified professional sign-off**.
- Parent scope: owner-approved INV-01 reference data only.
- Reviewers actually participating: no licensed pharmacist, quality professional or Egyptian regulatory-affairs professional was supplied or authenticated for this review. The five-role perspectives below are analytical lenses, not independent people or professional approvals.

## 1. Decision summary

Q38 is **not closed**. This review narrows the questions and proposes safe catalogue design boundaries from current EDA primary-source material. It does not approve final mandatory fields, product classifications, storage requirements, stock handling or legal applicability.

| Family | Evidence-backed distinction | Proposed catalogue treatment | Qualified status |
|---|---|---|---|
| Regular human medicines | EDA maintains a distinct human pharmaceutical registration framework; EPTTS materials separately cover human/biological products in defined scope | Medicine-specific extension; source-qualified EDA registration/authorization reference; separate packaging identifiers; do not assume all products are EPTTS-covered | Pending |
| Chemotherapy | No separate universal EDA catalogue schema for all chemotherapy products was established by the sources reviewed | Model as a clinical/handling classification linked to a medicine record unless pharmacist/regulatory reviewer demonstrates a distinct product identity taxonomy; no regimen/dose/clinical data in catalogue | Pending |
| Medical supplies/devices | EDA device registration/import guidance and UDI guideline are distinct from medicines; UDI scope includes devices, accessories and IVDs with stated exceptions | Separate device/IVD identity extension; conditional UDI-DI/UDI-PI and packaging-level identifiers; distinguish reusable equipment from consumables | Pending |
| Cosmetics | EDA has separate cosmetics notification guidance and a 2026 claims guide | Separate cosmetics identity/notification evidence; product variant and claim-review provenance; do not reuse medicine registration fields | Pending |

## 2. A — Regular human medicines

### Evidence reviewed
- EDA Central Administration of Pharmaceutical Products publishes a human-product registration framework, including dossier requirements (12/2023, issue 04), Decree 450/2023 registration cases (10/2025, issue 05), re-registration (12/2025, issue 07), variations (12/2025, issue 06), and additional product guidance. Current index: https://edaegypt.gov.eg/en/the-regulatory-reference-of-the-egyptian-drug-authority-eda/regulatory-guidelines/ca-of-pharmaceutical-products/
- EDA inspection/notice index lists EPTTS technical requirements (03/2026, version 02), user guide (03/2026, version 01), and Phase 1 FAQ (04/2026, version 03): https://www.edaegypt.gov.eg/en/the-regulatory-reference-of-the-egyptian-drug-authority-eda/notice-to-applicant/notice-to-applicant-central-administration-for-inspection-of-pharmaceutical-establishments/
- EDA identifies the responsible central administration and human product registration function: https://www.edaegypt.gov.eg/en/about-us/organizational-structure/the-central-administrations-eda/central-administration-of-pharmaceutical-products/

### Candidate catalogue fields — proposal only
- Active ingredient(s), strength/concentration, dosage form, route, pack presentation and manufacturer/marketing-authorization-holder: mandatory status and normalized representation require pharmacist review.
- EDA registration/authorization reference, status, source document, verification state and effective dates: retain as evidence-backed attributes; never infer authorization from a product name or barcode.
- Brand/trade name and Arabic/English display names; preserve label/source provenance.
- GTIN/barcode by packaging level, namespace and verification state; do not conflate with EPTTS serial/aggregation events.
- Candidate lot/expiry relevance indicator may inform later inventory design, but actual lot/expiry capture rules and transaction enforcement are outside INV-01.

### Questions requiring reviewer decision
1. Which medicine classes and presentations are actually handled by these pharmacies (including biologicals, refrigerated products, controlled/narcotic products, OTC and prescription-only)?
2. Which EDA registration identifiers and evidence are required to activate a catalogue record, and who verifies status/variations?
3. For each medicine class, which identifiers are GTIN, serial, lot and expiry, and what is the exact packaging level?
4. Which SKUs and which Special Group legal roles/sites fall within EPTTS Phase 1 and later phases? Confirm from current original EDA requirements; do not infer from the fact that a product is a medicine.
5. Does a product identity split on strength/form/route/manufacturer/pack size follow EDA registration and commercial pack definitions?

## 3. B — Chemotherapy medicines

### Evidence reviewed and limitation
The current EDA human-pharmaceutical registration framework applies to human medicinal products according to their regulatory category; the bounded source review did not establish a separate universal EDA product-catalogue schema solely because a medicine is cytotoxic/chemotherapy. This absence in a bounded search is not proof that no specific circular, handling rule or product-specific condition exists.

### Candidate catalogue treatment — proposal only
- Retain the underlying medicine identity fields approved for human medicines.
- Add a controlled, reviewer-governed classification/flag only if the pharmacy's qualified professional defines its meaning, scope, evidence and lifecycle.
- Keep handling/storage reference links separate from clinical administration, regimen, dose, patient or treatment data.
- Do not invent a generic "chemotherapy storage temperature", hazardous status, access rule or transfer prohibition; these must be product- and site-specific, label/evidence-backed and professionally approved.
- Preserve product-specific manufacturer label and safety-document references where the qualified reviewer requires them.

### Questions requiring reviewer decision
1. Does the business use "chemotherapy" only for antineoplastic medicines, or also supportive medicines and hazardous preparations? Define inclusions/exclusions.
2. Is this a cross-cutting flag on a medicine or a separate catalogue family? Recommended starting proposal: cross-cutting classification, not a duplicate product master.
3. Which products require special storage/handling metadata, and what authoritative source and review date establish each value?
4. Are any preparations compounded/reconstituted locally? If yes, that is a separate governed workflow and must not be represented as an ordinary catalogue SKU.
5. What later-phase access, segregation, traceability, waste and transfer controls are required at each site? Do not implement in INV-01.

## 4. C — Medical supplies and devices

### Evidence reviewed
- EDA device guidance index lists separate registration/import guidance for medical devices, equipment, accessories, laboratory/diagnostic equipment and IVDs, plus UDI guideline EDREX:GL.CAMD.005 v02, issued and applicable 05/2026: https://edaegypt.gov.eg/en/the-regulatory-reference-of-the-egyptian-drug-authority-eda/regulatory-guidelines/ca-of-medical-device/
- Official UDI guideline PDF: https://edaegypt.gov.eg/media/v5ci5unc/5-gl-udi-1-_up-6-2026.pdf
- EDA guideline scope describes medical devices, accessories and IVDs supplied to the Egyptian market, with stated exceptions for research-use, investigational and custom-made products. Applicability to each Special Group item must be classified, not assumed.

### Candidate catalogue fields — proposal only
- Distinguish device, IVD, accessory, consumable and non-device general supply; a pharmacist/medical-device regulatory reviewer must approve the classification rules.
- Manufacturer, brand, model/catalogue reference, intended product description as labelled, device risk/classification and EDA registration/listing evidence where applicable.
- UDI-DI and UDI-PI as separate structured concepts when applicable; retain issuing agency, identifier level, carrier/source, verification and validity. Do not treat every retail barcode as a UDI.
- Serial/lot/expiry applicability must be decided by product type and label/regulation; reusable equipment and single-use consumables must not share assumed rules.
- Avoid capturing clinical performance, compatibility or equivalence claims without controlled evidence and qualified review.

### Questions requiring reviewer decision
1. Which catalogue items are regulated medical devices, IVDs, accessories, consumables, or ordinary non-device supplies?
2. Which EDA registration route/classification applies to each category and what evidence/status must be retained?
3. Which UDI issuing agency and UDI-DI/UDI-PI structure applies; is the identifier present on each relevant package level?
4. Which devices are reusable, serialized, lot-controlled, expiry-controlled or subject to field-safety corrective action/recall traceability?
5. Which items should be treated as durable equipment rather than pharmacy inventory products? This boundary is outside INV-01 until owner approval.

## 5. D — Cosmetics

### Evidence reviewed
- EDA's official product-guidelines index lists the Regulatory Guide for Cosmetics Notification (06-Mar-2022, issue 01), Documents Required for Variations of Cosmetic Products (04-Aug-2025, issue 01), and Claims Guide for Cosmetics Notification (22-Jul-2026, issue 06): https://edaegypt.gov.eg/en/the-regulatory-reference-of-the-egyptian-drug-authority-eda/regulatory-guidelines/ca-of-pharmaceutical-products/
- EDA identifies a separate General Administration of Cosmetic Products Registration and separate cosmetic notification responsibilities: https://www.edaegypt.gov.eg/en/about-us/organizational-structure/the-central-administrations-eda/central-administration-of-pharmaceutical-products/

### Candidate catalogue fields — proposal only
- Cosmetic identity, brand, product name, variant/shade/fragrance, form, size/net content and manufacturer/responsible entity as shown on verified label/evidence.
- EDA notification/reference number, platform/source, notification status, evidence document, verification status and effective/variation history; do not call it a medicine marketing authorization.
- Claims/label review evidence reference and applicable guideline version; do not store an AI-generated claim as an approved claim.
- Barcode/GTIN and packaging level with source and verification; batch/expiry/shelf-life only as supported by label and applicable requirements.
- Keep borderline products (e.g. products making medicinal/therapeutic claims, antiseptics/disinfectants, biocides) in a regulatory classification queue; do not auto-classify as cosmetics.

### Questions requiring reviewer decision
1. Which cosmetic types are sold, and which borderline products require classification by EDA regulatory affairs?
2. What notification evidence and status is needed before a product is active in the catalogue?
3. Which claims/label fields must be recorded, and who verifies claims against the current 2026 guide?
4. How are variants, shades, fragrances, sizes and formulation changes represented as distinct catalogue identities?
5. What lot/expiry/shelf-life attributes are required for each type and which source is authoritative?

## 6. Cross-family design decisions recommended for review

1. Keep one stable internal Product identity framework with category-specific extension records; do not force all families into the same mandatory attribute set.
2. Treat chemotherapy as a proposed cross-cutting classification on medicine products unless qualified reviewers approve another taxonomy.
3. Keep EDA registration/notification evidence distinct by regulatory route and product family.
4. Keep ordinary barcode/GTIN, device UDI-DI/UDI-PI and EPTTS serial/aggregation concepts separate.
5. Preserve Arabic/English names, label/source provenance, verification state, effective dates and revision history.
6. Do not activate a record solely because it was imported. Require an approved review state and authorized approver.
7. Keep stock quantities, batch balances, receiving, dispensing, movements, valuation and accounting outside INV-01.

## 7. Five-role deliberation (analytical perspectives)

- Architect — pharmaceutical master-data architect: common identity plus category-specific extensions; identifiers and regulatory evidence separated.
- Devil's Advocate — regulatory/data-integrity reviewer: the same item can be misclassified; identifier collisions, stale approvals and false activation create compliance and traceability risks.
- Clueless Client — pharmacy catalogue user: staff need clear family labels, Arabic/English search and visible "unverified" status; no hidden guesses.
- SME — Egyptian regulatory/pharmacy/quality evidence analyst: each family has a distinct evidence route; chemotherapy classification and product-specific conditions need professional judgment. This is not licensed sign-off.
- Maestro — platform technical lead: Q38 remains open; accept this as an evidence assessment only and do not authorize production schema or API.

## 8. Explicit decisions and approvals still required

- Licensed pharmacist: sign family taxonomy, medicine/chemotherapy distinction, medicine fields, product-specific lot/expiry/handling metadata.
- Medical-device regulatory/quality reviewer: sign device/IVD boundary, UDI applicability, classification and traceability fields.
- Cosmetics regulatory/quality reviewer: sign cosmetics boundary, notification evidence, claim/variant and expiry fields.
- Egyptian regulatory-affairs/legal reviewer: confirm current Egyptian instruments, amendments, site/operator applicability and EPTTS role obligations.
- Owner: approve the final catalogue identity, activation/retirement authority and any operational consequences.
- Security/technical owner: approve create/edit/review/approve permissions, audit and import controls.

## 9. Coverage limitations and disposition

This is a bounded EDA-primary-source review, not an exhaustive Egyptian legal review. It did not verify Official Gazette originals, individual product registrations, product labels, Special Group licences, supplier records, UPA lists, MOHP instruments or the live in-app Regulatory Intelligence scan. No real product catalogue or patient data was accessed. No individual product is declared compliant, registered, EPTTS-covered, safe to store or suitable for transfer.

**Disposition: Q38 remains OPEN — evidence assessment prepared; qualified review and owner decisions outstanding.** Do not implement category-specific production fields, activation rules, storage rules or inventory controls based on this document alone.
