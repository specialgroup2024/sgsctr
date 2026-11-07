# Open questions

Track each item as: ID, question, impact, owner, status, evidence and decision date.
All items below remain open unless explicitly marked otherwise.

## Legal entities and operating model
- Q01: Provide the registered legal-entity list: exact legal name, legal form, commercial-registration identifier, tax/VAT identifiers where applicable, registered activity, ownership/parent relationship and effective dates. Impact: statutory books, tax setup and data isolation. Owner: business owner/legal adviser. Status: open; blocks final entity mapping.
- Q02: Map every contracting operation, pharmacy branch/site, warehouse and stock-owning location to its actual legal owner/operator. Identify which pharmacies are branches of one entity and which, if any, are separately incorporated. Owner: business owner/operations/legal. Status: open; blocks entity-specific provisioning.
- Q03: Is there a holding/parent company, and does it conduct transactions or only own subsidiaries? Provide evidence and define whether consolidated reporting is required. Owner: business owner/accountant. Status: open; do not assume a parent exists.
- Q04: Which entities are in Phase 1, and which operations are explicitly out of scope? Owner: business owner. Status: open.
- Q05: Is a web administration/finance interface required alongside React Native? Owner: operations. Status: open.
- Q06: Which user roles, approval limits, separation-of-duties rules and delegation paths apply per entity? Owner: business owner/finance. Status: open.

## Contracting
- Q07: What contract/project lifecycle, variation, procurement, subcontractor, progress billing, retention and close-out rules are used? Owner: contracting lead. Status: open.
- Q08: Which cost categories, budget controls, cost allocation and profitability reports are required? Owner: contracting lead/accountant. Status: open.
- Q09: What source documents and approval evidence are required for commitments, invoices and payment certificates? Owner: contracting lead/accountant. Status: open.

## Pharmacy inventory and costing
- Q10: Which branches share stock, and which stock movements require transfer documents or approvals? Owner: pharmacy operations. Status: open.
- Q11: What are the product units, pack conversions, batch/lot, expiry, recall, temperature and controlled-item requirements? Owner: pharmacist/quality lead. Status: open.
- Q12: Define weighted-average costing level and timing, receipt/return/transfer/adjustment treatment, negative-stock policy, precision and rounding. Owner: accountant/pharmacy lead. Status: open.
- Q13: What are approved purchasing, receiving, dispensing, returns, expiry and stock-count procedures? Owner: pharmacy lead. Status: open.

## Claims, patient balances and collections
- Q14: Provide signed payer agreements and approved examples for discount, coverage, copay, exemption, exclusions and calculation order. Owner: payer-contract owner/accountant. Status: open.
- Q15: Define claim statuses, submission channels, rejection codes, resubmission, partial approval, remittance and write-off authority. Owner: claims lead. Status: open.
- Q16: Define patient balance creation, statements, collection channels, receipts, refunds, disputes and escalation. Owner: finance/operations. Status: open.

## Finance, compliance and technology
- Q17: Approve entity-specific charts of accounts, fiscal periods, currencies, tax treatment, numbering, opening balances, intercompany policy and close procedures. Owner: accountant/tax adviser. Status: open.
- Q18: Identify applicable Egyptian legal, tax, e-invoice, pharmacy, privacy and health-data requirements for each entity and workflow. Owner: Egyptian counsel/tax adviser/pharmacy professional. Status: open.
- Q19: Identify legacy systems, import formats, data owners, reconciliation and migration cutover rules. Owner: data owner/accountant. Status: open.
- Q20: Confirm integrations, hosting region, backup retention, recovery objectives, audit retention and mobile offline requirements. Owner: technical owner/security. Status: open.

## Decision gate

Contracting and pharmacy remain separate accounting domains now. Final legal-entity count, branch ownership, entity-specific databases, statutory/tax configuration and consolidation remain blocked by Q01-Q03. No production financial calculation, stock valuation, claim settlement or patient-balance posting may be enabled until the relevant policy questions and professional reviews are resolved with approved worked examples.
