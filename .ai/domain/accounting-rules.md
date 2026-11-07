# Accounting boundaries and rules to confirm

## Provisional company structure

Owner-provided information identifies “Special Group” with Pharmacies and Specialized Contracting sectors. Treat this as one provisional legal entity until exact registered identity and any separately incorporated operations are verified.

If both sectors are the same legal person:
- Maintain one statutory company accounting framework, chart of accounts, fiscal year, tax profile and statutory financial statements.
- Maintain separate sector subledgers/journals or posting dimensions, budgets, cost/profitability reports and access/approval controls.
- Tag transactions with legal entity and sector; add branch, project, warehouse and other relevant dimensions.
- Reconcile sector subledger totals and allocations to company-level statutory control accounts.
- Do not create intercompany entries or duplicate statutory books between sectors of the same company.

## Pharmacy location and transfer accounting

Owner-confirmed locations: Mokattam main warehouse; Student Hospital, Qasr El-Aini Hospital and Manial Hospital branches. The owner explicitly confirmed that the three branches may transfer medicines and supplies directly between themselves, without routing every transfer through Mokattam.

Treat each warehouse/branch as a distinct inventory location within the Pharmacies Sector. The locations are administratively connected but separately accountable for stock and location-level reports.

Required system controls:
- Maintain location-level on-hand, reserved, available, received, issued, in-transit, adjusted, expired and counted quantities as applicable.
- Support transfers between any authorized source and destination locations, including branch-to-branch transfers and warehouse-to-branch/branch-to-warehouse transfers.
- Create a transfer document with source, destination, item, quantity, unit, batch/lot and expiry where applicable, requester, authorizer, dispatcher, receiver, timestamps and status.
- Model transfer lifecycle with request, approval, picking, dispatch, in-transit, receipt confirmation and closure; support partial receipt, discrepancy, rejection, cancellation and return according to approved policy.
- On dispatch, remove stock from the source's available/on-hand balance and record it as in transit; on confirmed receipt, add accepted quantities to destination stock. Keep discrepancies visible and unresolved until authorized resolution. Final accounting treatment must be approved.
- Prevent negative stock and over-dispatch unless a documented, permissioned exception is approved.
- Preserve immutable movement/audit history; corrections use reversal/adjustment records rather than rewriting completed movements.
- Apply role-based permissions and separation of duties to requesting, approving, dispatching and receiving. Do not assume one user may approve and receive their own transfer.
- Reconcile location-level stock and valuation reports to pharmacy sector and company-level control balances.

Transfers between locations of the same legal entity are internal stock movements, not sales or intercompany transactions. Transfer valuation, weighted-average costing implications, posting timing and any accounting entries require accountant approval. Administrative connectivity does not imply unrestricted financial or stock access.

Do not infer the locations are exhaustive or verify legal owner, operator, licence holder or stock custodian from the owner's operational statement. A separately incorporated entity requires its own statutory books and approved data isolation.

## Posting governance

Accountant must approve chart of accounts, sector and location dimensions, allocations, control accounts, fiscal periods, currencies, tax treatment, numbering, opening balances, approval roles, posting/reversal/adjustment rules, reconciliations and period close. Store monetary values using fixed precision and explicit currency; preserve audit trails.

## Pharmacy inventory costing

The pharmacy business brief specifies weighted-average costing. Before implementation, accountant and pharmacy lead must approve costing level and timing, and treatment of receipts, supplier returns, transfers, adjustments, negative stock, precision and corrections. Do not silently substitute another method.

## Approval restriction

These principles establish boundaries, not a complete chart of accounts or statutory accounting opinion. No production posting, stock valuation, tax calculation, consolidation or financial statement logic is authorized until relevant professionals approve entity-specific policies and worked examples.
