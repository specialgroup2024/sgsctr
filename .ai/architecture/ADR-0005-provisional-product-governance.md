# ADR-0005 — provisional product governance and regulatory evidence

- Status: merged to master by PR #37 as draft/review-only technical support. The later demo-status snapshot mismatch is corrected by PR #47; its CI has passed build, API tests and EF snapshot validation, with Docker startup and smoke tests still running. Runtime deployment is not yet verified.
- Owner instruction: on 2026-11-14, proceed with the previously excluded catalogue governance capabilities while preserving Q38 professional-review restrictions.
- This ADR is not a qualified pharmacist, medical-device quality, cosmetics regulatory, Egyptian legal or EDA approval.

## Context and current primary-source scan

The current EDA source review confirms distinct regulatory frameworks:
- Human pharmaceutical products: EDA pharmaceutical-product registration, variation and re-registration guidance, including Decree 450/2023 pathways and updated 2025/2026 guidance.
- Medical devices: EDA UDI guideline EDREX:GL.CAMD.005 v02/2026, published May 2026.
- Cosmetics: EDA Cosmetics Notification Guide EDREX:GL.CAPP.009 and a Claims Guide v06 dated 22-Jul-2026 in the official index.
- EPTTS: EDA Phase 1 technical requirements, user guide and FAQ define product/package traceability and importer responsibilities. EPTTS serials, UDI-PI, batch and expiry are not interchangeable with a product master GTIN or UDI-DI.

Official source links:
- https://www.edaegypt.gov.eg/en/the-regulatory-reference-of-the-egyptian-drug-authority-eda/regulatory-guidelines/ca-of-pharmaceutical-products/
- https://www.edaegypt.gov.eg/en/the-regulatory-reference-of-the-egyptian-drug-authority-eda/regulatory-guidelines/ca-of-medical-device/
- https://edaegypt.gov.eg/media/v5ci5unc/5-gl-udi-1-_up-6-2026.pdf
- https://edaegypt.gov.eg/en/services/track-and-trace
- https://edaegypt.gov.eg/media/fs1folht/egyptian-track-trace-for-pharmaceutical-eptts-technical-faq-v3_20262.pdf
- https://edaegypt.gov.eg/media/1zjbwa1w/regulatory-guide-for-cosmetics-notification.pdf

## Implemented provisional data structures

1. Product family assignment: one proposed family per generic product. Allowed owner-facing labels are RegularMedicine, Chemotherapy, MedicalDevice, MedicalSupply and Cosmetic. These are provisional business labels, not EDA legal classifications. The separate MedicalDevice and MedicalSupply labels avoid implying that every medical supply is an EDA-regulated device. Chemotherapy is an operational label and does not assert a distinct EDA registration category.
2. Product identifiers: GTIN, UDI-DI, EDA registration number and EDA cosmetics notification number are separate identifier schemes. Values are unique by scheme/value in the local catalogue and always PendingVerification.
3. Regulatory evidence: authority, evidence type, reference number, optional HTTPS document URI, optional link to a Regulatory Intelligence document, and publication/effective/expiry dates. Every record remains PendingReview.
4. Lifecycle requests: activation and retirement can be requested for review, but requests remain PendingProfessionalReview and never change the product's Draft status.
5. Every successful write is recorded in the existing catalogue audit event store.

## Deliberate safeguards

- No endpoint approves a family assignment, verifies an identifier/evidence record, activates or retires a product, or changes regulatory status.
- No GTIN/UDI-DI/EPTTS equivalence is inferred.
- UDI-PI, EPTTS serials, lot/batch and expiry are not stored as product-level identifiers.
- No clinical instruction, dosage, substitution, safe-handling or storage range is inferred.
- No EPTTS applicability is inferred from product family or a GTIN alone.
- No imported or manually entered identifier is treated as authentic until qualified verification.
- The four source documents/official indices are evidence leads, not a legal applicability decision for Special Group or any site.

## Remaining professional and owner decisions

- Q38 remains open: qualified pharmacist, device quality/regulatory reviewer, cosmetics regulatory reviewer and Egyptian regulatory-affairs/legal reviewer must complete the four-family worksheet and decide mandatory family attributes, identifier/package semantics, traceability, storage and applicability.
- Q37 remains open for documentary site/licence verification and separate classification of Mokattam and each hospital branch.
- Q36 remains open for EPTTS role/product/site applicability and actual reporting obligations.
- Internal SKU, duplicate matching, manufacturer/brand/strength/form data validation and product lifecycle authority remain open.
- Supplier master and procurement qualification need owner/procurement/legal decisions.
- Receiving, stock, lots, expiry, storage monitoring, dispensing, transfers and recall/quarantine need pharmacy operations and qualified professional approval.
- Pricing, moving weighted-average valuation, provider reimbursement, patient copay/exemption, employee discount, claims, tax and GL require approved agreements and accountant/tax/legal decisions.

## Acceptance boundary

- Draft family proposals, identifiers, evidence and lifecycle requests persist and can be reviewed.
- All new statuses are constrained in PostgreSQL to pending review states.
- Reads require API authorization; writes use the existing Administrator/local Development policy.
- Audit events commit in the same EF SaveChanges transaction.
- No product becomes active and no stock, patient, supplier, payer or accounting transaction is created by this ADR.
- CI must pass .NET build/tests, EF snapshot checks, Next.js typecheck/build and Docker smoke tests. PostgreSQL upgrade/migration tests must be separately verified before deployment.
