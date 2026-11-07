# Phase 0 discovery plan

Status: proposed plan; no business feature implementation authorized.

## Objective
Produce an owner-approved business, accounting, data, security and delivery baseline before designing production financial behavior.

## Work packages
1. **Entity map:** identify legal entities, ownership, branches, locations, registrations and intercompany relationships.
2. **People and controls:** interview business owners, contracting operations, pharmacists, claims staff, finance/accounting, IT and compliance advisers; map roles and approvals.
3. **Contracting walkthrough:** trace one representative project from tender/estimate through contract, variation, procurement, progress billing, payment and close-out.
4. **Pharmacy walkthrough:** trace purchase, receipt, lot/expiry handling, stock movement, dispensing, returns and stock count.
5. **Claims and collections:** trace real agreement documents using anonymized worked examples from eligibility through claim, payer response, remittance, patient balance and collection.
6. **Accounting workshop:** obtain charts of accounts, fiscal periods, currencies, source documents, posting/reversal rules, opening balances and reconciliation expectations for each entity.
7. **Data and integration inventory:** identify legacy systems, files, interfaces, data owners, quality, volumes and migration constraints.
8. **Compliance/security review:** have qualified Egyptian professionals identify applicable obligations; classify data and review access, retention, hosting and incident requirements.
9. **Architecture spike:** validate ASP.NET Core/PostgreSQL/EF Core-Npgsql/React Native compatibility, identity, database isolation, migration approach, observability and deployment options. No production business logic.
10. **Approval workshop:** review workflow maps, example test cases, proposed ADR and open questions; record decisions, owners and evidence.

## Deliverables
- Approved entity and branch map.
- Contracting and pharmacy workflow maps.
- Role/approval matrix and data classification.
- Approved worked examples for inventory costing, claims and balances.
- Proposed ADR decision resolved by named owner.
- Integration/data migration inventory.
- Compliance review register with sources and reviewer.
- Phase 1 scope, acceptance criteria, risks and estimate.

## Exit gates
Phase 0 ends only when business owners approve scope and workflows; accountant approves accounting/costing examples; pharmacy professional approves pharmacy controls; legal/tax advisers review applicable obligations; technical owner approves architecture and security baseline.

## Explicit exclusions
No business feature code, production financial calculations, ledger postings, inventory valuation, claim settlement, patient balance calculation, production data migration or production deployment.
