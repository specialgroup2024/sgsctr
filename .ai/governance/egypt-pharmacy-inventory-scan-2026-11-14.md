# Egypt pharmacy inventory regulatory and market scan — 2026-11-14

Status: bounded manual review for INV-00; not legal advice, licensing determination, exhaustive market monitoring or professional approval.
Review date: 2026-11-14 (Africa/Cairo). Sources checked in Arabic and English where available.

## Material primary EDA evidence

| ID | Source / class | Verified finding | Inventory impact and limitation |
|---|---|---|---|
| INV-EG-001 | EDA GSDP EDREX:GL.CIP.005 v05/2025, Class B | Applies to relevant pharmaceutical/biological products, medical devices and cosmetics. Stock records updated after each operation; periodic reconciliation and root-cause/CAPA for discrepancies; regular expiry/retest checks. | Propose append-only movement ledger, count/reconciliation, expiry and discrepancy workflow. Applicability to each site and category needs review. |
| INV-EG-002 | Same GSDP, sections 1.2, 1.3, 10–13, Class B | Receipt checks supplier, PO, product, batch, production/expiry, quantity, packaging and transport conditions; rejected products separated. FEFO; temperature/humidity monitoring and calibrated instruments; returned goods quarantined; recalls isolated, traced and reconciled. | Require receipt evidence, quality statuses, storage profiles, FEFO support, quarantine and recall traceability. Do not automate quality release or disposition. |
| INV-EG-003 | EDA warehouse licensing guideline EDREX:GL.CALI/CIP.002, v05/2026, issued/effective July 2026, Class B | Official Arabic original under Chairman Decree 725/2024. For the covered licensed medicine warehouses: record batch, manufacture and expiry; separate expired medicines; electronic/computer program records medicine data, purchase/sales invoices, suppliers/customers and warehouse data; retrieve records; retain inbound/outbound invoices and supporting documents at least five years. | Material update to prior 2023 warehouse guidance. Site classification/licence holder is a blocking question: do not apply warehouse-only rules to a pharmacy or hospital branch without qualified confirmation. Build configurable retention only after legal review. |
| INV-EG-004 | Same EDA warehouse licensing v05/2026, Class B | The covered warehouse guide specifies ambient premises limits up to 30°C and 65% RH, regular readings, and 2–8°C refrigeration for products requiring it; label/product-specific conditions still govern each product. It also specifies separate expired-product storage and vehicle conditions for licensed warehouse distribution. | Capture product storage profile and site/equipment evidence. Do not hard-code a universal 30°C/65% product rule or infer branch requirements. |
| INV-EG-005 | EDA EPTTS Phase 1 FAQ EDREX:NP.CIP.009 v03, 23-Apr-2026, Class B | Defines Phase 1 technical/data/serialization/reporting requirements for human and biological pharmaceutical products. Importing entity is accountable for reporting commissioning, aggregation, shipping and receiving events; secondary-package serialization and GTIN/serial/expiry/lot DataMatrix elements are specified. Phase 1 FAQ says CSV is mandatory, API integration not yet available, and requirements apply to shipments shipped on/after 1-Feb-2026. | Preserve fields/integration boundary for potentially covered items. Applicability to Special Group's role and retail branches must be confirmed; do not claim all branch transfers are EPTTS-reportable. |
| INV-EG-006 | EDA 2026 inspection-guideline index, Class B | Index lists 2026 guidance for inspection/CAPA follow-up for warehouses, depots and pharmacies, and misuse-potential product import/distribution/monitoring/dispensing; reserve-antibiotic dispensing guidance also appears. | Obtain full Arabic documents and determine affected SKUs, roles and pharmacy processes before configuration. |
| INV-EG-007 | EDA Q3 2026 licensing update, Class B official news | EDA reports continued licensing/renewal of pharmaceutical warehouses and other establishments. | Supports the need to verify actual current site licences; news is not proof of Special Group site status. |

## Other Egyptian market and public-sector signals

| ID | Source / class | Finding | Use and limitation |
|---|---|---|---|
| INV-EG-008 | State Information Service, 2-Sep-2026, Class C | Reports Prime Minister direction for continuous monitoring of medicine and medical-supply stocks at hospitals. | Hospital stock visibility and supply continuity are relevant context; not a binding software specification for Special Group. |
| INV-EG-009 | EnterpriseAM, 9-Nov-2026, Class E | Reports competing claims about a new drug-pricing formula and possible price pressure; article says EDA denied receiving the reported exceptional requests. | Treat as conflicting market signal only. Never update product prices or inventory cost from press reports. Require EDA official product-level price evidence. |
| INV-EG-010 | UPA public portal, access limitation | UPA domain was blocked to this review tool; no procurement dataset or current UPA stock source was verified. | Coverage gap; manual official-portal review or authorized data access needed. |
| INV-EG-011 | Egyptian Pharmacists Syndicate / supplier / distributor channels | No authoritative inventory SOP or product-level supplier source was authenticated in this bounded review. | Coverage gap; nominate trusted contacts and source URLs before relying on market signals. |

## Source URLs

- EDA GSDP v05/2025: https://edaegypt.gov.eg/media/ziepfko3/regulatory-guide-for-good-storage-and-distribution-practices-gsdp-_en-vr5.pdf
- EDA warehouse licensing v05/2026 Arabic original: https://edaegypt.gov.eg/media/gzxpsmon/الدليل-التنظيمى-لمخازن-الادوية_ar2026.pdf
- EDA licensing-guideline index: https://www.edaegypt.gov.eg/ar/المرجع-التنظيمي-لهيئة-الدواء-المصرية/الأدلة-التنظيمية/الأدلة-التنظيمية-الخاصة-بالإدارة-المركزية-لتراخيص-المؤسسات-الصيدلية/
- EDA EPTTS Phase 1 FAQ: https://edaegypt.gov.eg/media/fs1folht/egyptian-track-trace-for-pharmaceutical-eptts-technical-faq-v3_20262.pdf
- EDA track-and-trace service: https://www.edaegypt.gov.eg/en/services/track-and-trace/
- EDA inspection guidance index: https://edaegypt.gov.eg/en/the-regulatory-reference-of-the-egyptian-drug-authority-eda/regulatory-guidelines/ca-of-inspection-of-pharmaceutical-institutions/
- EDA Q3 2026 licensing news: https://edaegypt.gov.eg/en/media-center/news/egyptian-drug-authority-highlights-key-achievements-in-pharmaceutical-establishments-licensing-during-q3-2026/
- State Information Service hospital-stock news: https://sis.gov.eg/en/media-center/news/pm-directs-continuous-monitoring-of-medicine-medical-supply-stocks-at-various-hospitals/
- EnterpriseAM market report, 9-Nov-2026: https://enterpriseam.com/egypt/2026/11/09/new-drug-pricing-formula-faces-its-first-test-as-drugmakers-reportedly-push-for-20-hike/

## Monitoring status and review gaps

- The in-app EDA monitor's live latest-run status was not accessible in this repository-only task. Last owner-provided run remains 2026-11-11: five sources, 100 links, 12 new documents, zero failures.
- UPA portal access was blocked; professional syndicate and supplier/distributor primary channels were not verified in this bounded scan.
- No Official Gazette original, Special Group site licence, signed supplier contract, product-level registration/price, controlled-item schedule, site SOP or cold-chain excursion log was reviewed.
- The 2026 warehouse licensing guide is a material update to the older 2023 guide previously referenced; this scan indexes the current v05/2026 Arabic original. Qualified reviewer must confirm legal effect and site applicability.
- EDA documents are official guidance/instructions, but their application depends on establishment role, product class and current instruments. This scan is not a legal compliance conclusion.

## Human review required

Licensed pharmacist/quality lead: operating procedures and product handling. Regulatory-affairs/legal: current Arabic instruments, licence type and applicability. Accountant: costing/valuation. Business owner: sites, custody, authorities and release decisions.
