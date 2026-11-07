# Current state

Last reviewed: 2026-11-07.

Status: Phase 0 discovery; pharmacy transfer technical design drafted; no business features implemented.

Status: Phase 1 technical foundation scaffold created on branch `phase-1-local-foundation`; no business features implemented.


## Owner-provided structure

The owner identifies “Special Group” with Pharmacies Sector and Specialized Contracting Sector. Record provisionally as LE-01 with two sectors. Exact registered name/form/identifiers and whether both sectors are operated by the same legal person remain to be verified.

Pharmacy locations confirmed by owner:
- Mokattam main warehouse.
- Student Hospital branch.
- Qasr El-Aini Hospital branch.
- Manial Hospital branch.

The owner explicitly confirms that the three branches may transfer medicines and supplies directly between one another; a transfer does not have to pass through Mokattam. Support direct branch-to-branch and warehouse-mediated transfers. The locations are administratively connected but separately accountable for inventory and accounting reports.

## Accounting and inventory boundary

- One legal entity has one statutory company accounting framework, subject to official verification.
- Pharmacies and Specialized Contracting retain separate workflows, permissions, budgets, sector subledgers/journals or posting dimensions and management reports.
- Warehouse and each branch require distinct location-level stock balances, movement histories and reports.
- Transfers between any authorized pharmacy locations require source/destination traceability, dispatch, in-transit tracking, receipt confirmation, discrepancy handling and approvals.
- Location transfers within the same legal entity are internal stock movements, not sales or intercompany transactions.
- Transfer valuation, financial posting and detailed workflow policies require accountant and pharmacy-operations approval.
- Do not create duplicate statutory books, separate company databases or intercompany entries solely because of sectors or pharmacy locations.
- Provisional database direction: one PostgreSQL database for LE-01 with strict sector/module access controls.

## Evidence status

Owner statements are recorded but not independently verified. Exact Arabic/English registered legal name, legal form, commercial-registration and tax/VAT references, registered activities, parent/subsidiary relationship, site ownership, operator, licences and stock custody remain outstanding. The full site list is not yet confirmed.

## Repository and delivery

- Repository files inspected for this task show governance documentation and a minimal README; no application solution or migrations were identified in the inspected baseline. A full repository inventory remains a required first engineering task.
- ADR-0001 and legal-entity register are proposals/working records, not legal or accounting opinions.
- Pharmacy stock-transfer workflow and acceptance criteria are drafted; operational/accounting approval remains pending.
- Technical design drafted on branch `docs/pharmacy-transfer-domain-api-design`: domain model, REST API contract, PostgreSQL persistence proposal and phased implementation plan.
- These artifacts are proposals only. No application code, migrations, production stock posting, inventory valuation, tax calculation, claim settlement or patient-balance logic was implemented.

## Next milestone

Complete repository inventory and technical review of the proposed domain/API/persistence design. Obtain pharmacy-operations approval of lifecycle, roles, custody, limits, exceptions and lot/expiry controls; obtain accountant approval of weighted-average costing, in-transit valuation, posting and reconciliation. Then implement the approved backend foundation and transfer workflow incrementally, with PostgreSQL integration tests and explicit release gates. Verify company identity and site/operator/licence register before production configuration.

- Pharmacy stock-transfer workflow and 21 acceptance criteria are drafted and await pharmacy-operations/accountant/owner approval.
- A non-posting technical design has been drafted at .ai/architecture/pharmacy-stock-transfer-technical-design.md. It defines proposed API commands, conceptual records, state/quantity model, transaction/idempotency controls, authorization/audit boundaries and test mapping.
- GitHub Actions run for the Phase 1 branch: .NET restore/build, Docker image build, PostgreSQL 18 startup and API/database smoke test all succeeded; documentation line-limit workflow also succeeded. This is CI evidence for the foundation only, not a local test on the owner's workstation.
- No production posting, inventory valuation, tax calculation, claim settlement or patient-balance logic is approved.

## Next milestone

Owner clones `phase-1-local-foundation` and runs the local Docker Compose smoke test. Resolve any workstation-specific Docker, port or network issues from the actual terminal output. Once local startup is confirmed, review and merge the foundation through the repository's normal process. Then continue with approved Phase 1 technical controls; pharmacy business implementation remains gated on operations/accountant approvals. In parallel, verify company identity, legal site/operator/licence and full branch/site schedule before production configuration.

