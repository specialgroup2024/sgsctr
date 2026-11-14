# Egypt pharmacy inventory regulatory scan — 2026-11-14

Status: bounded discovery scan for inventory requirements. This is not legal advice, a licensing determination, exhaustive monitoring or approval to implement stock rules.
Review date: 2026-11-14 (Africa/Cairo).
Scope: EDA public regulatory material relevant to pharmacy inventory, storage, receipt, lot/expiry, stock reconciliation, returns, recall, distribution and track-and-trace. English and Arabic EDA pages/documents were checked.

## Primary EDA findings

| ID | Source and class | Verified evidence | Inventory impact / status |
|---|---|---|---|
| INV-EG-001 | EDA Regulatory Guide for Good Storage and Distribution Practices (GSDP), EDREX:GL.CIP.005, v05/2025; Class B official guidance | Applies to medicines, biologicals, medical devices, cosmetics and other listed product categories. Sections 12–13 require stock records updated after each operation, periodic physical-to-record reconciliation, root-cause review/CAPA, regular expiry/retest checks, receipt checks and product-specific storage controls. | Candidate requirements for stock ledger, receiving, stock count, discrepancy/CAPA and expiry management. Applicability and enforceable status for each Special Group site/activity require qualified review. |
| INV-EG-002 | Same GSDP guide, pages 7–8 and 12–13; Class B | Temperature/humidity mapping, calibrated instruments and retained readings; FEFO rotation; damaged/broken/expired goods removed from usable stock and segregated; returned goods quarantined pending disposition; recalled goods secured and isolated with traceability/reconciliation. | Requires quality/status controls separate from sellable/available stock. Do not auto-release returned, damaged, recalled or temperature-excursion stock. |
| INV-EG-003 | Same GSDP guide, pages 6 and 14–15; Class B | Incoming deliveries are checked against documents including product, batch, production/expiry dates and quantity; transport temperature evidence is reviewed where applicable. Dispatch documentation includes batch and expiry to support traceability; expired products must not be supplied. | Receiving and movement records need lot/expiry and evidence references when applicable. Exact required fields vary by product and process. |
| INV-EG-004 | EDA organizational guideline for warehouse licensing, EDREX:GL.CAO.002, v2/2023; official licensing guidance (Class B) | The document defines a licensed warehouse and license holder. Its annexed requirements include identifying stored products by batch, production and expiry dates, segregating expired stock and using a computer program to preserve incoming/outgoing invoices and documents. | Do not assume the Mokattam location is legally an EDA-licensed pharmaceutical warehouse. Confirm licence holder, activity, site classification and applicability before configuring production operations. |
| INV-EG-005 | EDA inspection-guideline index, checked 2026-11-14; Class B | Lists GSDP v05/2025, 2026 sampling/release guideline, 2026 misuse-potential product import/distribution/monitoring/dispensing guideline, 2026 corrective-action follow-up guidance for warehouses/depots/pharmacies and reserve-antibiotic dispensing guidance. | Retrieve full applicable Arabic instruments and map product-specific rules with regulatory/pharmacy professionals. Index entries alone are not full legal evidence. |
| INV-EG-006 | EDA licensing-guideline index, checked 2026-11-14; Class B | Lists July 2026 warehouse licensing and health-requirements guidance under Chairman Decree 725/2024, v05, and intermediary-depot licensing guidance, v03. | Site/activity classification and licensing must be verified before system workflows or role assumptions. |
| INV-EG-007 | EDA national track-and-trace service and technical-document index; Class B | EDA publishes unified track-and-trace guidance for human and biological medicinal products, technical requirements, Phase 1 FAQ/user guide, product/location identifier guidance and EPCIS event guidance. EDA event material describes digital receipt/shipping event requirements for relevant supply-chain participants. | Potential integration/data requirements for covered products and participants. Do not assume every retail branch or all product categories are in Phase 1. Confirm applicability, onboarding, identifiers, deadlines and interfaces with EDA/qualified regulatory staff. |

## Original sources checked

- GSDP v05/2025 PDF: https://edaegypt.gov.eg/media/ziepfko3/regulatory-guide-for-good-storage-and-distribution-practices-gsdp-_en-vr5.pdf
- EDA inspection guidelines index: https://edaegypt.gov.eg/en/the-regulatory-reference-of-the-egyptian-drug-authority-eda/regulatory-guidelines/ca-of-inspection-of-pharmaceutical-institutions/
- EDA warehouse licensing guidance index: https://www.edaegypt.gov.eg/en/the-regulatory-reference-of-the-egyptian-drug-authority-eda/regulatory-guidelines/ca-of-pharmaceutical-institutions-licensing/
- Warehouse licensing guideline PDF (EDREX:GL.CAO.002): https://edaegypt.gov.eg/media/rqdk1mb0/%D8%A7%D9%84%D8%AF%D9%84%D9%8A%D9%84-%D8%A7%D9%84%D8%AA%D9%86%D8%B8%D9%8A%D9%85%D9%89-%D9%85%D8%B3%D8%AA%D9%88%D8%AF%D8%B9%D8%A7%D8%AA-%D8%A7%D9%84%D9%88%D8%B3%D8%B7%D8%A7%D8%A1-en-2026.pdf
- EDA track-and-trace service: https://www.edaegypt.gov.eg/en/services/track-and-trace/
- EDA track-and-trace implementation lecture: https://www.edaegypt.gov.eg/en/media-center/events/eda-holds-a-series-of-lectures-to-explain-the-mechanism-of-implementing-the-pharmaceutical-track-and-trace-system/

## Impact and limits

- The EDA GSDP document is official guidance. This scan does not decide which requirements are legally binding for each location, whether a site is a pharmacy, warehouse, depot or another licensed establishment, or whether all product categories are handled under the same controls.
- The warehouse licensing PDF found at the EDA URL is an organizational guideline issued 15 January 2023, effective 18 January 2023. The separate EDA index lists a July 2026 v05 warehouse-licensing guide. The 2026 full document and current legal instruments must be obtained and reconciled; do not treat the 2023 PDF as the latest version.
- No Official Gazette original, company/site licence, supplier licence, product registration/price, live recall, product-specific controlled-item schedule or site-level temperature SOP was verified.
- UPA, MOHP, ETA, payer, professional association, supplier, tender and media sources were not comprehensively searched in this inventory-focused scan. No claim of exhaustive Egyptian market coverage is made.
- The in-app EDA monitor's operational status was not queried in this documentation-only task; its last owner-provided scan evidence remains 2026-11-11.
- No stock, costing, dispensing, recall-disposition, pricing or accounting rule is approved by this scan.

## Required human review

1. Licensed pharmacist / pharmacy operations: product categories, storage conditions, lot/expiry, FEFO, quarantine, return, recall, count and adjustment SOPs.
2. Egyptian regulatory-affairs professional / counsel: current Arabic instruments, licensing classification and site/product applicability.
3. Accountant: weighted-average costing, receipt/return/transfer/adjustment valuation, in-transit treatment and reconciliation.
4. Business owner: locations, operating scope, role authority, approval limits and release priorities.

Next review: before inventory requirements sign-off and before any inventory code, migration, import or operational pilot.
