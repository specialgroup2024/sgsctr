# Egypt pharmacy catalogue scan — 2026-11-14

- Review date: 2026-11-14 (Africa/Cairo).
- Scope: current EDA public regulatory indexes and documents relevant to generic product identity, medicines, devices/UDI, cosmetics and track-and-trace.
- Purpose: constrain the generic INV-01 data model; not a legal opinion or Q38 sign-off.
- In-app Regulatory Intelligence monitor: **not inspected in this repository-only session**. Latest owner-provided worker evidence remains 2026-11-11 (five sources, 100 links, 12 new documents, zero failures); this single run is not exhaustive coverage.

## Sources checked and findings

| Source / class | Current evidence | Impact on generic catalogue |
|---|---|---|
| EDA pharmaceutical-products regulatory-guidelines index — Class B | Human pharmaceutical registration, variations and related guidance are listed separately. The index lists the Cosmetics Notification Guide (06-Mar-2022), cosmetics variations documents (04-Aug-2025) and Claims Guide v06 dated 22-Jul-2026. | Keep medicines and cosmetics regulatory evidence distinct. Do not add category fields or notification/registration states before Q38 review. |
| EDA medical-device UDI guideline EDREX:GL.CAMD.005 v02/2026 — Class B | Issued and applicable 05/2026. Scope includes medical devices, accessories and IVDs supplied to the Egyptian market and relevant manufacturers, agents, importers, distributors and healthcare providers. It distinguishes UDI-DI and UDI-PI and discusses packaging levels and production identifiers. | Do not conflate ordinary barcode, UDI-DI, UDI-PI, GTIN or EPTTS. No identifier field is implemented in the generic phase. Qualified device/quality review remains necessary. |
| EDA Inspection / Notice-to-Applicant index — Class B | Lists EPTTS technical requirements v02 (03/2026), user guide (03/2026), Phase 1 FAQ v03 (04/2026), July 2026 CSV implementation guide and EPCIS event material. | Track-and-trace applicability depends on covered product, actor and role. No EPTTS fields, serialisation, aggregation or reporting behavior is implemented. |
| EDA human-product announcements — Class B | 20-Sep-2026 announcement says Rolling Submission pathway closure effective 01-Dec-2026 for locally manufactured human product registration dossiers. 22-Oct-2026 notice updates administrative/relevant documents/time frame for human product variations. 12-Nov-2026 announcement addresses companies facing difficulties submitting registration applications. | These concern registration applicants/holders. No evidence in this scan establishes that Special Group is the marketing-authorisation holder. Do not encode registration workflow into a pharmacy catalogue. |
| EDA UDI PDF — Class B primary regulator document | Official PDF EDREX:GL.CAMD.005 v02/2026, retrieved and inspected; pages 1–4 include issuance/scope and DI/PI/package-level distinctions. | Family-specific identifiers remain gated. |

## Source URLs

- EDA pharmaceutical-products guidelines index: https://edaegypt.gov.eg/en/the-regulatory-reference-of-the-egyptian-drug-authority-eda/regulatory-guidelines/ca-of-pharmaceutical-products/
- EDA medical-device guidelines index: https://www.edaegypt.gov.eg/en/the-regulatory-reference-of-the-egyptian-drug-authority-eda/regulatory-guidelines/ca-of-medical-device/
- EDA UDI guideline PDF: https://www.edaegypt.gov.eg/media/g1cjdm3z/5-udi_up-2026.pdf
- EDA Inspection / EPTTS notice-to-applicant index: https://www.edaegypt.gov.eg/en/the-regulatory-reference-of-the-egyptian-drug-authority-eda/notice-to-applicant/notice-to-applicant-central-administration-for-inspection-of-pharmaceutical-establishments/
- EDA rolling submission announcement (20-Sep-2026): https://edaegypt.gov.eg/en/media-center/announcements/announcement-regarding-the-complete-and-final-closure-of-the-rolling-submission-pathway/
- EDA updated human variations notice (22-Oct-2026): https://www.edaegypt.gov.eg/en/media-center/announcements/publication-of-an-updated-notice-to-applicant-administrative-relevant-documents-time-frame-for-human-pharmaceutical-variations/
- EDA registration application difficulties announcement (12-Nov-2026): https://edaegypt.gov.eg/en/media-center/announcements/announcement-regarding-companies-facing-difficulties-in-submitting-applications-for-the-registration-of-human-pharmaceutical-products/

## Disposition and gaps

- The scan supports a category-neutral generic identity model and confirms why family-specific identifier and regulatory fields must remain separate.
- It does not establish a product taxonomy, Special Group's regulatory role, product-level EDA registration/notification status, EPTTS coverage, UDI applicability to a specific SKU, storage conditions or movement permission.
- The cosmetics index lists Claims Guide v06 dated 22-Jul-2026; the original v06 document was not downloaded and reviewed in this scan. Do not rely on the older v05/2025 PDF as current.
- UPA access, authenticated Pharmacists Syndicate/supplier sources, Official Gazette originals and Special Group site licences were not reviewed.
- The in-app EDA monitor was not checked because this session had repository connector access but no deployed application/browser session. Manually checked EDA public pages instead.
- Qualified pharmacist, quality, regulatory-affairs and legal sign-off remains outstanding under Q38. No legal compliance conclusion is made.
