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

## Impact on SGSCTR

- Keep GTIN, UDI-DI, UDI-PI, EPTTS serials, batch/lot, expiry and location identifiers conceptually distinct.
- Do not add serialization, aggregation, CSV/XML event reporting or transfer reporting to the product catalogue based on indexes alone.
- Do not infer that Special Group is an importer, any named site is an EPTTS reporting location, or all catalogue products are covered.
- Keep family assignments, identifiers and evidence in existing unverified/pending states.
- Q36/Q42 require qualified Egyptian regulatory review of role, product, site, effective-date and intra-group movement applicability using current original instruments.

## Limitations

Targeted public-source refresh, not exhaustive Egyptian legal research. No Official Gazette instrument, Special Group licence, importer agreement, SKU registration, site record or original product label was verified. No business rule, product status, stock rule or operational permission is changed.
