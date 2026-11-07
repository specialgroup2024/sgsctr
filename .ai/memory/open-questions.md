# Open questions

Track each item as: ID, question, impact, owner, status, evidence and decision date.

## Legal entity and operating model
- Q01: Owner reports one company, “Special Group”, comprising Pharmacies Sector and Specialized Contracting Sector. Verify exact registered legal name (Arabic and English), legal form, commercial-registration and tax/VAT references, registered activities and status from official records. Impact: statutory books, licensing and tax setup. Owner: business owner/legal adviser. Status: partially answered; official verification pending.
- Q02: Pharmacy locations identified: Mokattam main warehouse; Student Hospital, Qasr El-Aini and Manial Hospital branches. Confirm whether this is the complete location list; provide addresses, legal owner/operator, licence holder, stock owner/custodian and any third-party operating arrangements. Identify contracting offices/sites. Impact: branch dimensions, licences, stock custody and entity mapping. Owner: business owner/operations/legal. Status: partially answered; details and verification pending.
- Q03: Confirm whether Special Group has a parent/holding company or subsidiaries, or is itself the only relevant legal entity. Owner: business owner/accountant. Status: open.
- Q04: Confirm whether both sectors are legally operated by the same registered person and whether any sector activity is contracted/licensed through another entity. Owner: business owner/legal adviser. Status: open; required before final approval.
- Q05: Which operations/sites are in Phase 1? Owner: business owner. Status: open.
- Q06: Which user roles, approval limits, sector-level access and separation-of-duties rules apply? Owner: business owner/finance. Status: open.

## Contracting
- Q07: Define contract/project lifecycle, variations, procurement, subcontractors, progress billing, retention and close-out. Owner: contracting lead. Status: open.
- Q08: Define cost categories, budget controls, cost allocation and profitability reports. Owner: contracting lead/accountant. Status: open.
- Q09: Identify source documents and approval evidence for commitments, invoices and payment certificates. Owner: contracting lead/accountant. Status: open.

## Pharmacy inventory and costing
- Q10: Owner confirmed that branches may transfer medicines/supplies directly to one another without routing through Mokattam. A proposed lifecycle and acceptance criteria are documented in [pharmacy-stock-transfer-workflow.md](../domain/pharmacy-stock-transfer-workflow.md) and [pharmacy-stock-transfer-acceptance.md](../quality/pharmacy-stock-transfer-acceptance.md). Pharmacy operations must approve request/approval/pick/dispatch/custody/receipt/partial receipt/discrepancy/return/cancellation/emergency steps, roles, limits, separation of duties and lot/expiry handling. Owner: pharmacy operations/business owner. Status: route capability confirmed; workflow and tests drafted, approval pending.
- Q11: Define units, pack conversions, batch/lot, expiry, recall, temperature and controlled-item requirements. Owner: pharmacist/quality lead. Status: open.
- Q12: Approve weighted-average costing level/timing, receipt/return/transfer/adjustment treatment, negative-stock policy, precision and rounding. Owner: accountant/pharmacy lead. Status: open.
- Q13: Approve purchasing, receiving, dispensing, returns, expiry and stock-count procedures. Owner: pharmacy lead. Status: open.

## Claims, patient balances and collections
- Q14: Provide signed payer agreements and approved examples for discount, coverage, copay, exemption, exclusions and calculation order. Owner: payer-contract owner/accountant. Status: open.
- Q15: Define claim statuses, submission channels, rejection codes, resubmission, partial approval, remittance and write-off authority. Owner: claims lead. Status: open.
- Q16: Define patient balance creation, statements, collection channels, receipts, refunds, disputes and escalation. Owner: finance/operations. Status: open.

## Finance, compliance and technology
- Q17: Approve company chart of accounts, sector and location dimensions, fiscal periods, currencies, tax treatment, numbering, opening balances, intercompany policy and close procedures. Owner: accountant/tax adviser. Status: open.
- Q18: Identify applicable Egyptian legal, tax, e-invoice, pharmacy, privacy and health-data requirements for each sector/workflow. Owner: Egyptian counsel/tax adviser/pharmacy professional. Status: open.
- Q19: Identify legacy systems, import formats, data owners, reconciliation and migration cutover rules. Owner: data owner/accountant. Status: open.
- Q20: Confirm integrations, hosting region, backup retention, recovery objectives, audit retention and mobile offline requirements. Owner: technical owner/security. Status: open.

## Decision gate

Provisional planning model: one legal entity LE-01 with two sectors, separate operational controls and management accounting, but one statutory company accounting framework if official records confirm one legal person. Pharmacy locations are administratively connected but separately accountable, and direct branch-to-branch stock transfers are supported alongside warehouse-mediated transfers. The proposed transfer workflow and acceptance criteria are not approved policy. No production financial calculation, stock valuation, claim settlement, patient-balance posting or tax configuration until official identity and professional approvals are recorded.
