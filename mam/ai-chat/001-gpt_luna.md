Use a **modular monolith with strict business boundaries** to start: one application and deployment pipeline, but separate accounting books, permissions, reports, and configuration for the contracting company and the pharmacy group. Keep the pharmacy’s inventory, dispensing, and claims workflows separate from the contracting workflows; do not treat them as one shared accounting system.

## Suggested repository structure

```text
/
├── AGENT.md
├── AGENTS.md
├── README.md
├── .ai/
│   ├── README.md
│   ├── product/
│   │   ├── vision.md
│   │   ├── scope-and-non-goals.md
│   │   ├── users-and-permissions.md
│   │   └── acceptance-criteria.md
│   ├── domain/
│   │   ├── glossary.md
│   │   ├── business-boundaries.md
│   │   ├── pharmacy-workflows.md
│   │   ├── contracting-workflows.md
│   │   ├── accounting-rules.md
│   │   └── claims-and-contracts.md
│   ├── architecture/
│   │   ├── system-context.md
│   │   ├── architecture-decisions.md
│   │   ├── data-model.md
│   │   ├── api-conventions.md
│   │   └── deployment.md
│   ├── compliance/
│   │   ├── egypt-requirements-register.md
│   │   ├── data-protection.md
│   │   ├── pharmacy-controls.md
│   │   └── tax-and-e-invoicing.md
│   ├── security/
│   │   ├── threat-model.md
│   │   ├── access-control.md
│   │   └── backup-and-recovery.md
│   ├── delivery/
│   │   ├── roadmap.md
│   │   ├── definition-of-done.md
│   │   ├── testing-strategy.md
│   │   └── release-and-rollback.md
│   ├── operations/
│   │   ├── monitoring.md
│   │   ├── incident-response.md
│   │   └── runbooks/
│   ├── decisions/
│   │   └── ADR-0001-business-boundaries.md
│   └── task-plans/
├── src/
│   ├── Api/
│   ├── Modules/
│   │   ├── Identity/
│   │   ├── Shared/
│   │   ├── Contracting/
│   │   └── Pharmacy/
│   └── Mobile/
├── tests/
│   ├── Unit/
│   ├── Integration/
│   ├── Contract/
│   └── EndToEnd/
└── infra/
```

`AGENT.md` and `AGENTS.md` are not interpreted uniformly by every coding agent. Put a bootstrap instruction in whichever file your selected agent runner supports, explicitly telling it to read the other file and the relevant `.ai/` documents before acting.

## What the instruction files should govern

**`AGENT.md` — mission and decision policy**

```md
# Project mission

Build and maintain a production-ready application for two legally and
financially distinct businesses: a specialist contractor and a pharmacy group.

# Before changing code

1. Read AGENTS.md and the relevant .ai documents.
2. Identify the affected business module, users, data, and accounting boundary.
3. Check for relevant compliance-register entries and unresolved assumptions.
4. Create or update a task plan for work spanning multiple files or modules.

# Decision rules

- Do not invent Egyptian legal, tax, pharmacy, or accounting requirements.
  Record uncertain items as questions in .ai/compliance/ and block affected
  production behavior until an authorized owner resolves them.
- Keep the two businesses' ledgers, numbering, permissions, reports, and
  operational data separate. Any intercompany transaction must be explicit
  and auditable.
- Treat payer discounts, payer coverage, patient copay, exemptions, and later
  collections as distinct concepts.
- Never silently change posted financial or inventory transactions. Use
  authorized reversals or adjustment entries with an audit trail.
- Do not make diagnosis, treatment, or medication-substitution decisions.
  Clinical and dispensing decisions remain with authorized pharmacy staff.
- For each change, add or update tests, documentation, and migration notes.
- Do not claim production-ready until the Definition of Done and release gates
  in .ai/delivery/ are met.
```

**`AGENTS.md` — implementation conventions**

Document the chosen .NET and React Native versions, code layout, naming conventions, validation and error formats, API versioning, database migration rules, test commands, secrets handling, and CI checks. Require the agent to:

- Use PostgreSQL transactions and constraints for financial and inventory invariants.
- Store money as fixed-precision decimals with an explicit currency; never use floating-point money.
- Store timestamps consistently and make business timezone behavior explicit.
- Use idempotency for retryable integrations and payment/claim submissions.
- Require authorization checks on the server for every protected operation.
- Keep credentials, patient data, and production data out of source control, logs, and test fixtures.
- Run relevant tests and report failures; never claim a test passed unless it was run.

## Domain rules to document before implementation

The pharmacy needs explicit, reviewed workflows for branches, products, suppliers, purchasing, receiving, lot/batch and expiry tracking, stock transfers, dispensing, returns, recalls, and adjustments. Chemotherapy and other high-risk items should have configurable handling and traceability requirements confirmed by pharmacy leadership. The software should support pharmacist review and operational records, not make clinical decisions.

For pharmacy accounting, specify **weighted-average costing** precisely: the level at which the average is calculated, how receipts and returns affect it, how stock transfers are valued, and how corrections are handled. Preserve the transaction history so an auditor can reconstruct inventory value at a past date.

Model contractual pricing and claims as separate rules. For example, a contract’s discount is not automatically the same as the payer’s coverage percentage. Define the calculation sequence with the business’s accountant and payer agreements, then record each transaction’s applied rule/version. A claim should track at least the submitted amount, payer-approved amount, payer share, patient share, exemption or copay rule, adjustments, claim status, remittances, and remaining receivables. For an 80/20 example, store the applicable agreement and calculate from its approved basis; do not hard-code 80% globally. The patient’s amount can remain an outstanding receivable if it is collected later.

For the contracting business, separately define project budgets, estimates, contracts, variations, purchase orders, subcontractors, progress billing, retention, project costs, and project profitability. Do not reuse pharmacy inventory or claims logic just because both modules need invoices or customers.

## Egypt compliance and release gates

Maintain `.ai/compliance/egypt-requirements-register.md` as a **dated, reviewed register**, not a paragraph in the prompt. Each entry should capture the source and effective date, affected workflow/data, required control, responsible reviewer, verification date, and implementation status. Require legal, tax, accounting, and pharmacy professionals to confirm how a rule applies to these specific entities.

At minimum, have reviewers assess Egypt’s Personal Data Protection Law No. 151 of 2020 and its Executive Regulations under Decree No. 816 of 2025. A published October 2026 legal update says the one-year compliance period ended on 31 October 2026 and reports that the Personal Data Protection Center launched its application portal; treat licensing, permits, DPO, sensitive health-data, and cross-border-processing obligations as items for qualified Egyptian counsel to verify, not assumptions for the agent to resolve. <citation src="2,5"></citation>

Also verify pharmacy licensing and operational controls against the applicable Egyptian pharmacy framework, including Pharmacy Practice Law No. 127 of 1955 and current related rules. <citation src="6"></citation> Review Egyptian Tax Authority e-invoice/e-receipt obligations for each legal entity and its transaction types; implementation and applicability should be confirmed against current ETA requirements rather than copied from a generic vendor guide. <citation src="11,14"></citation>

## Recommended build sequence

1. **Discovery and sign-off:** Map users, branches, legal entities, contracts, accounting policies, claims examples, and reporting needs. Resolve the calculation order for discounts, payer coverage, copays, exemptions, and adjustments with the relevant business owners.
2. **Architecture and controls:** Approve business boundaries, identity and permissions, audit requirements, data classifications, retention, backup, and compliance register.
3. **Platform foundation:** Build authentication, authorization, audit events, configuration, API conventions, database migrations, deployment pipeline, and observability.
4. **Contracting module:** Implement one complete workflow—from project setup through costs, billing, and reporting—before broadening scope.
5. **Pharmacy foundation:** Implement catalog, suppliers, purchasing, receiving, batch/expiry inventory, weighted-average costing, and reconciliation.
6. **Pharmacy sales and claims:** Add dispensing records, payer contracts, claim submission and reconciliation, patient balances, collections, and exception handling.
7. **Integration and hardening:** Add only confirmed integrations, then test failure/retry behavior, security, backups and restore, concurrency, auditability, and mobile offline behavior if required.
8. **Pilot and production release:** Reconcile opening balances, test representative cases with staff, run a controlled pilot, document rollback, and require explicit business and compliance sign-off.

A release is not ready merely because the app builds. Require passing automated tests, verified financial calculations against approved examples, inventory and ledger reconciliation, access-control checks, restore testing, monitoring and alerting, user acceptance, and documented support procedures.