# Egypt pharmacy inventory regulatory scan — 2026-11-15

- Retrieval date: 2026-11-15 (Africa/Cairo).
- Scope: targeted refresh for INV-01/INV-02 product identity, identifiers and EPTTS traceability questions.
- Evidence class: official EDA publications and indexes (Class B); no binding applicability conclusion is made.
- Result: additional July 2026 EPTTS implementation materials are visible in official EDA indexes. Q36/Q42 remain open.

## Official EDA sources checked

1. **Notice to applicant — Central Administration for Inspection of Pharmaceutical Establishments**  
   https://www.edaegypt.gov.eg/en/the-regulatory-reference-of-the-egyptian-drug-authority-eda/notice-to-applicant/notice-to-applicant-central-administration-for-inspection-of-pharmaceutical-establishments/  
   Current index lists EPTTS technical requirements (03/2026, v02), User Guide (03/2026, v01), Phase 1 FAQ (04/2026, v03), and July 2026 implementation materials.
2. **EDA Track and Trace service index**  
   https://www.edaegypt.gov.eg/en/services/track-and-trace/  
   Index lists Phase 1 CSV implementation guide (07/2026, v02), XML Commissioning/Packing/Shipping in Masar B2B EPCIS Events (07/2026, v01), technical requirements, User Guide, FAQ and National Guideline for Issuing Product and Location Identifiers.
3. **EPTTS Technical FAQ, Phase 1, v03/2026**  
   https://edaegypt.gov.eg/media/fs1folht/egyptian-track-trace-for-pharmaceutical-eptts-technical-faq-v3_20262.pdf  
   Describes Phase 1 serialization and event-reporting requirements, importing-entity reporting responsibility in its stated scope, and an effective date for shipments from 1 February 2026. Applicability to Special Group is not established.
4. **EDA UDI guideline, EDREX:GL.CAMD.005 v02/2026**  
   https://edaegypt.gov.eg/media/v5ci5unc/5-gl-udi-1-_up-6-2026.pdf  
   Distinct medical-device/accessory/IVD identifier framework; it does not make every medical supply an in-scope device.

5. **EDA Medical Products Store licensing guideline, EDREX:GL.CALI/CIP.002 v05/2026**  
   https://www.edaegypt.gov.eg/media/2pwjzxj3/en20226-%D8%A7%D9%84%D8%AF%D9%84%D9%8A%D9%84-%D8%A7%D9%84%D8%AA%D9%86%D8%B8%D9%8A%D9%85%D9%89-%D9%85%D8%AE%D8%A7%D8%B2%D9%86-%D8%A7%D9%84%D8%A7%D8%AF%D9%88%D9%8A%D8%A9_.pdf  
   Issue/effective date: 07/2026. Issued pursuant to EDA Chairman Decree 725/2024. The text identifies license-holder and responsible-pharmacist documentation and discusses licensed distribution areas. Provisions apply only if the relevant site/activity falls within this licence category; qualified review must determine applicability.
6. **EDA Organizational Guideline Regarding the Licensing of Warehouses, EDREX:GL.CALI.10 v03/2026**  
   https://www.edaegypt.gov.eg/media/5scbsmmp/organizational-guideline-regarding-the-licens_wearhouse-en-2026.pdf  
   This separately defines the warehouse license holder and addresses warehouse licence changes, ownership, name, activity and layout. It must not be conflated with the Medical Products Store licensing guideline; applicability to Mokattam and other locations requires inspection of the actual licence and activity.

## Impact on SGSCTR

- Keep GTIN, UDI-DI, UDI-PI, EPTTS serials, batch/lot, expiry and location identifiers conceptually distinct.
- Do not add serialization, aggregation, CSV/XML event reporting or transfer reporting to the product catalogue based on indexes alone.
- Do not infer that Special Group is an importer, any named site is an EPTTS reporting location, or all catalogue products are covered.
- Keep family assignments, identifiers and evidence in existing unverified/pending states.
- Q36/Q42 require qualified Egyptian regulatory review of role, product, site, effective-date and intra-group movement applicability using current original instruments.
- For the owner-described Mokattam warehouse, verify the exact licence category, named license holder, licensed address/activity, responsible pharmacist registration and credentials, validity, permitted distribution area, GSDP status and any approved accessory-store/site treatment. Do not assume the three hospital branches are covered by the Mokattam licence or that the Medical Products Store guideline applies to them.

## Limitations

Targeted public-source refresh, not exhaustive Egyptian legal research. The two EDA licensing PDFs and current index were retrieved and reviewed for their stated titles, versions and relevant clauses; no Special Group licence, importer agreement, SKU registration, site record or original product label was verified. Applicability and legal interpretation remain with a qualified Egyptian reviewer. No business rule, product status, stock rule or operational permission is changed.
