# Current state

Last repository review: 2026-11-25 at master commit 94236489089407e598cd68ead41ee7454c47c3e8. This review rechecked current Pharmacy source and governance. Dated platform/runtime and PR acceptance observations below remain historical evidence; the 2026-11-25 Pharmacy source-reconciliation addendum supersedes earlier Pharmacy implementation-status statements where they conflict. Runtime state on the owner's VM was not independently reproduced.

## 2026-11-25 source-reconciliation addendum — Pharmacy Option B

- Owner selected four independent Pharmacy operational modules: Regular Medications, Chemotherapy Drugs, Medical Supplies and Cosmetics (PHARM-OWN-002). Module-level management financial records/reporting and group consolidation are intended; legal entity, statutory books, database count and shared-service design are not decided by this selection.
- Current master contains `StockMovement` and `StockTransferRequest` entities and migrations dated 2026-11-17. This corrects the earlier 2026-11-16 statement that no ledger/transfer artifacts were present on master.
- The inspected stock-movement API creates Draft rows, lists movements and calculates balances from Posted rows; its mapped routes contain no posting command. The transfer API supports draft/request/approval/reject/cancel actions; approval creates paired Draft movement rows only. No dispatch/receipt lifecycle or stock-balance effect is implemented in those routes.
- Receipt drafts are non-posting; the create response explicitly confirms no stock balance or movement is created. Supplier/onboarding records are draft/unverified/pending; they do not establish approved supplier qualification or purchase-order execution.
- Product family assignment is proposal-only and constrained to five labels (RegularMedicine, Chemotherapy, MedicalDevice, MedicalSupply, Cosmetic), all pending professional review. This does not implement the owner's four operational modules; MedicalDevice vs MedicalSupply mapping is an open question.
- Inspected product, supplier, receipt, stock movement and transfer records do not carry an explicit Pharmacy module ownership key. The inventory UI remains one Pharmacy Inventory workspace; four distinct module workspaces were not evidenced in the inspected tree.
- Weighted-average costing, dispensing/sales, payer claims/remittance, patient balances, employee discount calculation and GL/financial posting were not evidenced as operationally implemented in the inspected source. Professional approval gates remain pending.
- Full evidence and gaps: [Pharmacy Group four-module boundary matrix](../domain/pharmacy-four-module-boundary-matrix.md). GitHub source/tree inspection only; no local build, automated test, deployed database, VM runtime or professional review was performed for this reconciliation.

## 2026-11-25 Future 25 legacy reconciliation baseline

- The owner-designated `futher_md/` corpus contains exactly 12 files. Recovered SQL Anywhere transaction-log DDL: 321 tables, 5,068 columns, 475 foreign keys, 297 primary-key clauses, 36 indexes, one view and 833 DDL statements; it is not an authenticated live catalog export.
- Full Phase 0 source/current-code reconciliation is recorded in `.ai/delivery/future25-full-sgsctr-reconciliation.md`: 321 table dispositions, five column-disposition CSVs covering all 5,068 columns, 475 FK dispositions and 22 workflow comparisons. All are first-pass evidence classifications, not approved semantic mappings.
- Source inspection covered current AppDbContext/EF snapshot, catalogue/supplier/receipt/inventory/transfer/regulatory APIs, web workspaces and relevant rule/PostgreSQL integration tests. Four Option B operational modules are selected but not yet independently enforced in current persistence/API workflows. Supplier/receipt/stock/transfer capabilities remain Draft or approval scaffolding; no completed dispensing, claims, PO, GL or costing implementation was evidenced.
- The legacy corpus is read-only evidence; its nested AGENTS.md and technology recommendations are not SGSCTR policy. No application business code, schema, migration, financial rule, operational posting or production setting was changed in this reconciliation.
- PR #105 (source-authority exception) merged; PR #106 (legacy source and first reconciliation baseline) merged; PR #107 (generated context index correction) merged. Current work is on `feat/future25-semantic-reconciliation-phase0-2026-11-26`; it is documentation/evidence only and has not yet been submitted as a PR.
- PR #108 GitHub Actions: documentation integrity passed; .NET Release build passed; 164/164 automated tests passed; AuthDbContext and AppDbContext pending-model-change checks passed. Compose smoke startup initially failed before containers launched because BuildKit denied the `network: host` entitlement. A CI-only default-network override was committed for the rerun; it remains unverified. No local VM runtime command was executed.

## Current summary
Master contains the generic INV-01 Draft-only catalogue foundation (PR #36) and provisional INV-02 product-governance records (PR #37, merged 2026-11-14). PR #46 merged the separately labelled pharmacist demo examples on 2026-11-15. PR #47 merged the forward-only pharmacist-demo cleanup and Platform foundation health correction. Its GitHub Actions run 43702502896 completed successfully (build, API tests, EF snapshot validation, Docker startup and smoke checks). PR #48 merged the corresponding governance/regulatory documentation reconciliation. The owner's later API-unreachable dashboard report remains unverified on the Linux VM; deployment of the merged changes and the new forward migration must be confirmed by owner-provided runtime checks.

## Owner-provided organization structure
The owner identifies “Special Group” with Pharmacies Sector and Specialized Contracting Sector. Record provisionally as LE-01 with two sectors. Exact registered name/form/identifiers and whether both sectors are operated by the same legal person remain to be verified.

Pharmacy locations confirmed by owner:
- Mokattam main warehouse.
- Student Hospital branch.
- Qasr El-Aini Hospital branch.
- Manial Hospital branch.

The owner confirms the three branches may transfer medicines and supplies directly between one another, without routing through Mokattam. This confirms the required route capability only; workflow, controls and valuation remain subject to approval.

## Accounting and inventory boundary
- Separate pharmacy and contracting operational controls and management reporting are required.
- Location-level stock balances and movement history are required.
- Same-entity location transfers are internal movements, not sales or intercompany transactions.
- Transfer valuation, posting, workflow and detailed controls require accountant and pharmacy-operations approval.
- Provisional database direction is one PostgreSQL database for LE-01 with strict module/sector access boundaries; legal structure remains unverified.
- Do not create business transaction tables or financial/stock postings before required approvals.

## Verified repository foundation
- Default branch: master; solution: Sgsctr.slnx.
- API: ASP.NET Core net10.0, EF Core/Npgsql; SDK pin 10.0.115 (owner commit `e685aa3` on 2026-11-16 lowered the earlier 10.0.403 pin; global.json is authoritative); Npgsql provider 10.0.3.
- Database Compose image: PostgreSQL 18-alpine.
- Web: Next.js 15.5.7, React 19.1.1.
- Native ASP.NET Core Identity is registered and persisted in PostgreSQL; Keycloak is not an active Compose service.
- API readiness checks AppDbContext and AuthDbContext. Owner VM output on 2026-11-11 returned HTTP 200 with database, applicationContext and identityContext connected.
- Owner VM output also returned HTTP 200 from web-to-API readiness and /api/system-status, reporting api=online and database=connected.
- Compose maps sgsctr_dataprotection_keys to /var/lib/sgsctr/data-protection-keys. Persistence across recreation and production certificate setup are not yet evidenced.
- Compose defaults Development and AUTHENTICATION_ENABLED=false unless overridden. Real login and authorization denial are not verified.
- No approved enterprise role/permission matrix or persistent business audit-event model exists.

## Implemented application boundaries
- Web routes include overview, organization, pharmacies, contracting, Pharmacy Inventory and Regulatory Intelligence.
- Organization API returns owner-provided sector and location reference data; legal identity remains VerificationPending.
- Location create/edit/deactivate requires configured Organization:ManagerSubjects allowlist, empty by default.
- Master has generic Draft-only product, unit and conversion persistence/API/BFF/UI plus catalogue audit events. PR #37 adds pending-review family proposals, separate identifier schemes, regulatory evidence references and activation/retirement requests that do not change product status. INV-B supplier drafts, unverified evidence references and pending review requests are also present after PR #61; purchasing, stock balances, transfer ledger, dispensing, claims, patient balances and financial posting are not implemented.

## Pharmacy inventory phases
- PR #27 delivered Phase 0 discovery; PR #28 merged INV-00 requirements, costing examples, deliberation and Egypt regulatory scan.
- PR #29 merged on 2026-11-14 (merge commit 7114e0cd499e371d2e08c71f8f86bcd6148c6deb) and delivered the authenticated /pharmacies/inventory UI prototype.
- INV-00 screens: Overview, Product Catalogue, Receiving, Stock Transfers, Batches & Expiry and Reports. The overview reads active pharmacy locations through the existing organization API and shows API liveness separately from PostgreSQL readiness.
- Master supports generic draft product/unit/conversion reference writes. INV-02 adds only provisional family/identifier/evidence/lifecycle review records; no product activation, synthetic stock, receipts, expiry alerts or transactions are added.
- Master contains CatalogueProduct, UnitOfMeasure, ProductUnitConversion and CatalogueAuditEvent entities, plus CatalogueProductFamilyAssignment, CatalogueProductIdentifier, CatalogueRegulatoryEvidence and CatalogueLifecycleRequest with pending-only database constraints and APIs/UI. Master also contains supplier draft/evidence/review-request entities, migration, API, Next.js BFF and Supplier Register UI from PR #61; receipt drafts remain non-posting and the Receiving UI is not connected. No PO, stock balance, movement ledger, batch, transfer, valuation or GL posting is verified on master.
- Q37: owner confirmed on 2026-11-14 that Mokattam is an EDA-licensed pharmaceutical warehouse under Chairman Decree 725/2024. Licence copy/number, holder, operator, validity and scope still require documentary/regulatory verification; the three hospital branches require separate classification.
- Q38: product taxonomy and mandatory fields for medicines, chemotherapy, devices/supplies and cosmetics require qualified pharmacist, quality and regulatory review.
- Q46: owner approved the initial INV-01 scope on 2026-11-14: persistent product catalogue/product identity, units of measure and explicit packaging conversions, and pharmacy-location reference metadata. Supplier master is deferred. Purchasing, receiving, stock balances, lots, movements, dispensing, transfers, valuation, claims and accounting postings are excluded. On 2026-11-14 the owner also approved the general product identity/catalogue direction, explicit unit/conversion model, and server-side authorization plus auditable changes, and authorized implementation subject to existing gates. The owner subsequently authorized generic category-neutral Draft-only implementation while Q38 remains pending. The branch uses UUID identity, display name only, unit code/name/symbol, reduced positive integer conversion ratios, API-authorized reads, Administrator writes when authentication is enabled (local Development with authentication explicitly disabled retains local write access), and a narrow success-event audit log. Exact human SKU/duplicate rules, dimensional compatibility, conversion policy beyond exact rational storage, final permission matrix, audit retention/export/tamper evidence, import source and duplicate resolution remain open.
- The INV-01 approval package is recorded in .ai/delivery/pharmacy-inventory-inv01-approval-pack.md. PR #36 merged the generic catalogue foundation; PR #37 merged the provisional product-governance records while preserving Q38 restrictions. These records do not approve or activate products. Supplier master was deferred from the earlier INV-01 scope. The later INV-OWN-001 authorization sequences a separate INV-B draft supplier register; Q51 qualification, due diligence, legal/licensing evidence, duplicate resolution and reviewer authority remain pending. PR #61 merged to master at `cad05b42d44942e1ddcf0aa5ffa6062cee258670` on 2026-11-15. It added Draft-only supplier records, Unverified evidence references and Pending review requests. The PR description still says it was not merged; GitHub merge metadata is authoritative for repository state. Technical acceptance remains blocked because both required checks failed before runner steps executed. The candidate data dictionary and Q38 pharmacist/quality worksheet remain review artifacts; Q38 qualified review and detailed technical/security decisions remain gates for later regulated extensions and release.
- Mokattam's warehouse type is owner-confirmed, not independently licence-verified; other sites require separate classification.
- No authentication verification, Data Protection volume verification or live VM/browser deployment verification was performed for PR #29 or PR #47. Authentication and Data Protection verification remain on hold per owner instruction.

## EDA regulatory intelligence
- Owner-approved EDA ingestion MVP is merged (PR #22); duplicate-index migration correction is merged (PR #24).
- Owner-provided VM log on 2026-11-11: five sources, 100 discovered links, 12 new documents, zero failures.
- This single scan does not prove exhaustive coverage, continuous availability, regulatory correctness or completed human review. No OCR, legal interpretation, outbound email/SMS/push or automatic pharmacy-rule updates are implemented.

## Uploaded AI operating guidance reconciliation — 2026-11-15
- Owner supplied ai-chat.zip with four source Markdown files (001–004); the complete source-to-repository mapping is recorded in governance/source-reconciliation-ai-chat.md.
- Root AGENT.md and AGENTS.md were strengthened; the previously placeholder project-facts.md was populated; empty dynamic specialist profile and skill documents were filled; standards-register.md and certification-roadmap.md were structured.
- The reusable skill set now covers .NET API, PostgreSQL data, future React Native, pharmacy inventory, claims/contracts, accounting controls and secure release. Skills are task guidance, not proof that the corresponding application feature exists.
- This documentation reconciliation does not approve business rules, certification procurement, legal interpretations, pharmacy workflows or production behavior. No application code or schema was changed.

## Governance and next milestone
- AGENT.md, AGENTS.md and .ai define dynamic five-role operation and human/professional approval boundaries.
- PR #47 merged the additive forward migration that restores any synthetic `DemoApproved` INV-PRO-001 row to Pending, removes that status from the snapshot/database constraint, and makes Compose wait for API/PostgreSQL readiness before starting web. Its CI run 43702502896 completed successfully. The test-readiness workspace branch adds 19 PostgreSQL-backed test definitions and Development-only, Administrator-only append-only test execution records; it does not change approval states. Q38 qualified review remains required before family-specific mandatory fields, verification, product activation or operational use. Supplier/procurement, receipt/stock/transfer, costing, claims and GL workflows require their own recorded owner and qualified approvals. Detailed identity, conversion, permissions, audit retention/export, import provenance and duplicate-resolution decisions remain open. Supplier master remains deferred.
- PR #58 is merged as the INV-A technical discovery record; it remains a discovery baseline, not a complete warehouse.
- PR #60 is merged and adds receipt-draft tables/API/BFF only. Its PR description says build, migration parity, PostgreSQL integration, authorization and browser/UI checks were not run. No workflow run was returned for its merge commit. Treat receipt drafts as unverified and non-posting; no live VM migration has been performed.
- INV-B supplier register is present on master via PR #61 (merge commit `cad05b42d44942e1ddcf0aa5ffa6062cee258670`). PR #62 reconciled project-state documents (merge commit `74970b4ffdb968c95388c4d0fe4e9aab6102c543`). PR #63's technical-acceptance hardening was merged by the owner; it adds authenticated supplier lifecycle/authorization checks, PostgreSQL persistence/audit assertions, BFF same-origin checks, English/Arabic UI coverage, input-boundary tests and fail-closed audit attribution. However, its required jobs failed before runner assignment (`runner_id: 0`, empty steps and no logs), so no build, tests, migration or browser command is evidenced as executed. PR #64 was also merged by the owner (master merge commit `f92b9bb4d18ddf76a3f9d63570e61dec0e2f479c`) and removes duplicate supplier evidence translation keys; a source scan found no duplicate keys, but Docker/typecheck/browser verification remains outstanding. INV-B technical acceptance remains blocked/unverified. The code remains Draft-only; no qualification, legal/licence verification, due diligence decision, contact directory, PO/receipt eligibility, supplier transmission, payment, stock or GL effect exists. The owner requested expanded INV-B scope on 2026-11-15; Q51 / INV-OWN-002, INV-SEC-001 and applicable professional approvals remain open. See .ai/delivery/pharmacy-inventory-invb-expansion-decision-package.md.
- Stock movements and costing remain later gated work.
- Authentication verification and Data Protection volume verification remain on hold per owner instruction.

## Bilingual application foundation
- PR #50 merged the shared English/Arabic locale provider, persistent locale cookie, server-rendered root lang/dir, EN/AR switcher, initial shell/dashboard/organization/sector labels and RTL base styles. English remains the technical default; Arabic uses ar-EG formatting. API/database values, enum codes, identifiers and source evidence remain language-neutral/original.
- PR #52 (branch feat/complete-bilingual-screen-coverage) extends translations through catalogue/product governance, pharmacist demo examples, inventory tabs/states, approvals, test readiness, regulatory intelligence and organization screens. It adds Playwright checks for both locales at desktop (1440px) and mobile (390px), covering the authenticated inventory tabs and five authenticated routes, root lang/dir, desktop sidebar placement and horizontal overflow; screenshot artifacts are configured.
- PR #52 was merged to master; PR #53 subsequently merged the initial five-file JSX restoration. The owner's next VM build still failed at `npm run typecheck`, exposing duplicate declarations/content in four additional frontend files. PR #54 (`fix/web-typescript-duplicate-declarations`) contains a targeted correction for those diagnostics and remains open/unmerged as of 2026-11-15. Its TypeScript/Docker build and Playwright checks are not yet verified; no successful VM build or deployment is claimed.
- This is responsive web localization, not React Native client localization. Print/export coverage and qualified human acceptance of Arabic domain terminology remain open. Arabic legal/regulatory/pharmacy/quality/accounting wording is provisional presentation text pending qualified review.
- Authentication and Data Protection verification holds remain unchanged.


## INV-B supplier onboarding intake extension — 2026-11-15

- PR #65 (supplier onboarding decision gates) is merged by the repository owner; merge commit is recorded in GitHub. Its decision package kept legal/professional policy gates open.
- Owner approved the limited draft intake scope in chat on 2026-11-15; recorded as conditional approval INV-OWN-003. This approval covers supplier-declared identity/licence metadata as OwnerProvided / Unverified, department-level business channels only, and Pending due-diligence intake cases.
- Feature branch feat/invb-supplier-draft-onboarding-intake adds three EF Core entities/tables, an additive migration and snapshot updates; API write endpoints and same-origin Next.js BFF routes; Supplier Register forms and Arabic translations; audit events; and input-rule tests.
- PR #66 merged to master on 2026-11-15 (merge commit `ed7a99eb49329e766c1b500db4febfb79e3df0bf`; head `2671e92854cfe3862bc6126775d98aae55f2adc6`). It implements the owner-approved INV-OWN-003 non-operative intake: supplier-declared identity/licence claims remain OwnerProvided / Unverified; business contact channels are department-level shared channels; due-diligence cases remain Pending. Both PR-triggered CI workflows failed, and reruns of both failed jobs also failed before any steps were reported; job step lists are null and log download returned 404. No build, test, migration parity, PostgreSQL integration, authorization or browser command is evidenced as executed. Technical acceptance remains blocked/unverified, not passed.
- No legal/licence verification, qualification decision, actual due-diligence check, reviewer-role grant, named-person contact data, purchasing/receiving eligibility, PO/stock/financial posting or production migration is implemented or authorized. Q51 / INV-OWN-002, INV-REG-001, INV-PRO-001 / INV-QLT-001 where applicable, INV-SEC-001 and INV-REL-001 remain open. The PR merge does not change these approval states.


## Approval workflow simulation discovery — 2026-11-15
- Master already contains a PostgreSQL-backed test-readiness workspace, a Development-only Administrator test-result endpoint, and a separate pharmacist-review example component/document. The test-readiness delivery note's prior “not yet merged” status is stale relative to the source files present on master; runtime deployment is not verified by this discovery.
- Historical synthetic `DemoApproved` approval state was removed by the PR #47 forward correction; the authoritative approval API remains read-only and the approval register remains the source of truth.
- New request authorizes discovery/design of a generic synthetic Approval Workflow Simulator only. Proposed design is separate from Approvals and Test Readiness, Development-only behind a server-side opt-in, in-memory only, no database/API writes, no real identities/evidence and no downstream side effects. Implementation awaits owner confirmation of the technical design and security review.


## INV-B operational expansion technical design — 2026-11-15
- Repository discovery confirmed the merged PR #66 intake source boundary: supplier drafts, OwnerProvided / Unverified declarations, Unverified evidence, department-level shared business channels and Pending-only due-diligence intake. Source-level existence does not establish live PostgreSQL migration or runtime acceptance.
- A proposed staged technical design and simulated five-role deliberation are recorded in .ai/delivery/invb-supplier-operational-expansion-design.md and .ai/roles/invb-supplier-operational-expansion-deliberation.md.
- The proposal separates identity, evidence verification, licence applicability, due-diligence execution, reviewer authority, qualification decisions and independent purchasing/receiving eligibility. It does not define business/legal criteria or authorize operational behavior.
- INV-TECH-001 and Q55 are Pending review. Q51, INV-OWN-002 and INV-SEC-001 remain open/pending; applicable legal/regulatory, pharmacist, quality, procurement and privacy approvals remain required. No application code, schema, migration, contact-person data, external verification or PO/receiving integration changed.


## INV-B supplier assurance expansion — 2026-11-15
- Owner approved `.ai/delivery/invb-supplier-operational-expansion-design.md` as the technical design baseline on 2026-11-15. Approval is recorded as INV-TECH-001 Approved with conditions; it does not constitute delegated technical ratification, security/privacy acceptance, Q51 business-policy approval, legal/regulatory/pharmacy/quality approval, reviewer qualification/authority, named-contact privacy approval, operational verification/qualification, purchasing/receiving eligibility or production release.
- Working branch: `feat/invb-supplier-assurance-foundation`. The branch currently records the design acceptance and synchronized governance state only; no new supplier UI, API or database capability has yet been implemented in this branch.
- Next implementation boundary is D1 foundation only: technical persistence/API/audit/authorization and a non-decision read-only UI, with security/privacy review and test evidence. D2–D6 remain separately gated. No deployed PostgreSQL migration or runtime acceptance is claimed.


## INV-B operational capability authorization — 2026-11-15
- Owner explicitly approved implementation of operational legal/licence verification, qualification-decision, reviewer-authority administration and separate purchasing/receiving eligibility capabilities. Recorded in the governance approval register as `INV-OWN-004` Approved with conditions on branch `docs/invb-owner-operational-scope-approval`.
- This is an implementation authorization, not a legal/regulatory or professional determination, not approval of any supplier, not proof/assignment of reviewer credentials or authority, and not approval for PO/receipt/stock/financial side effects. Detailed criteria, evidence sources, reviewer credentials/delegation, eligibility dimensions and security/privacy review remain required before live operational decisions. Eligibility stays fail-closed and disconnected from downstream transactions until approved and tested.
- No UI/API/database operational capability is claimed implemented by this documentation update.

## INV-B supplier assurance workflow implementation — 2026-11-15

- Branch: feat/invb-supplier-assurance-workflows.
- Added source-level assurance request workflow foundations: six distinct request types (legal/licence verification, due-diligence execution, reviewer-authority application, qualification review, purchasing eligibility evaluation and receiving eligibility evaluation), ASP.NET Core API, Next.js BFF route, per-supplier UI queue/form, EF entity/migration/model snapshot and audit event.
- Server controls initial states. Non-eligibility requests are Pending. Purchasing and receiving eligibility requests are Blocked with POLICY_AND_QUALIFICATION_NOT_APPROVED. The client cannot submit a decision or status.
- Read/write assurance routes require Administrator; the existing Development-only authentication-disabled path remains. Evidence references are checked for supplier ownership and use a composite database foreign key.
- This is a non-operative work-request queue only. It does not execute verification or due diligence, issue reviewer grants, make qualification decisions or confer purchasing/receiving eligibility. It has no PO, receipt, stock or financial integration.
- The implementation does not complete INV-B operational assurance. Detailed policy, qualified reviewers, credential/delegation evidence, security/privacy acceptance and release gates remain open.
- Unit tests were added for request type validation and fail-closed eligibility initialization. No build, test run, EF migration parity, PostgreSQL migration, BFF/browser test, CI result or VM runtime validation is claimed yet.
- Deliberation: .ai/roles/invb-supplier-assurance-workflows-deliberation.md.
- Review record: draft PR #72 is open at https://github.com/specialgroup2024/sgsctr/pull/72. GitHub reports no workflow runs or commit status checks for its current head. The PR is intentionally not merged.

## INV-04 stock transfer request continuation — 2026-11-17

- The owner directly pushed phased implementation commits to master: `44a4ad8 phase02` (AppDbContext model parity probe), `304529c phase INV03 execute` (StockMovement ledger entity, migration, endpoints, rules and tests) and `78b39f7 INV-04-01` (StockTransferRequest/StockTransferRequestLine entities, model configuration and pure rules). GitHub merged these to master through merge commit `1965a609fb18023e4c958623b8adbfbf54f272af` together with governance bootstrap documentation.
- Branch `feat/inv04-stock-transfer-requests` (commits `5c184f2`, `3497632`, plus follow-ups) completes the next slice, INV-04-02: additive migration `20261117140845_PharmacyStockTransferRequests` (two new tables, nullable `StockMovements.StockTransferRequestId` FK, restrict deletes; snapshot regenerated, 159 additive snapshot lines), forward correction migration `PharmacyStockTransferLocationCheck` adding `CK_StockTransferRequests_DifferentLocations`, Draft-only transfer endpoints under `/api/v1/pharmacy/inventory/stock-transfers` (create, list, detail, submit, send-for-approval, approve, reject, cancel), the `CanSendForApproval` rule completing the Submitted → PendingApproval transition, `AreLocationsDistinct` as a domain rule, separation of duties on approve/reject, and 43 new rule tests.
- Approval creates Draft `TransferOut`/`TransferIn` StockMovement rows only; no posting, dispatch, receipt or balance effect. Q12/Q13 costing and receiving-procedure gates, Q53 transfer-lifecycle policy approval and the security review remain open.
- Runtime evidence (2026-11-17): the local Compose stack was rebuilt by the owner from this branch; the API container applied all migrations at startup to the `sgsctr_dev` PostgreSQL 18 database. `__EFMigrationsHistory` contains 17 rows including both `20261117123041_20261117120000_StockMovementLedger` (INV-03) and `20261117140845_PharmacyStockTransferRequests` (INV-04). Read-only inspection confirmed the three inventory tables and their check constraints exist; `/health/ready` returned HTTP 200 with database, applicationContext and identityContext connected. This is one local Development observation, not production migration or release evidence.
- PostgreSQL integration tests were added (Testcontainers.PostgreSql 4.17.0, disposable postgres:18-alpine container; owner authorized the harness dependency): migrations apply on a clean database, expected check constraints exist including the new distinct-locations constraint, violating inserts (same source/destination, unknown statuses, zero quantity, unknown movement type) are rejected, location delete is restricted and request lines cascade.
- Verified locally at HEAD: `dotnet build Sgsctr.slnx --configuration Release` 0 errors (one pre-existing CS0618 warning), `dotnet test Sgsctr.slnx --configuration Release` 164/164 passed (121 unit + 43 transfer rules across suites and 9 PostgreSQL integration), and `dotnet ef migrations has-pending-model-changes` reported no pending model changes. The newer location-check migration applies on the owner's next stack rebuild; BFF/UI coverage, CI and production migration remain unverified.
- Deliberation record: .ai/roles/inv04-stock-transfer-requests-deliberation.md.

## AI context index and documentation integrity — 2026-11-16

- PR #80 was merged to master at merge commit `dac7ded6eafc4974b1c6ab40dc666f9072ae6d0d`.
- The merged implementation adds the manifest/index generator, repository-relative link checker, CI integration and canonical-document ownership guidance.
- At the merged commit, the manifest reconciled against GitHub's tree: 131 source Markdown files (excluding generated `.ai/index.md`), six empty placeholders, matching Git blob SHA/byte-size metadata and deterministic path order. The index was 171 lines.
- A prior isolated temporary Git fixture exercised generator freshness and basic link-check behavior. It was not a full-repository run.
- PR #80 merge-commit Actions jobs failed before any visible step: raw jobs had `runner_id: 0`, no runner name and empty `steps: []`; log downloads returned 404. Rerunning the documentation job produced the same result.
- PR #81 adds `scripts/test_ai_context_integrity.py`, integrates it into documentation CI, and records the acceptance criteria. Its documentation run `43859532336` and .NET foundation run `43859532271` also failed before visible steps with `runner_id: 0`, empty runner name and empty steps. The commit status remains pending with zero status contexts.
- The new regression tests cover deterministic generation, manifest SHA/size agreement, freshness detection, valid local links/anchors/assets, duplicate heading anchors, fenced-code exclusion and fail-closed missing-link cases. An equivalent isolated temporary Git fixture was executed locally: 3/3 tests passed. The exact checked-in test file and full repository checks remain unexecuted.
- Technical acceptance is **BLOCKED** pending a functioning GitHub Actions runner or an owner-run local checkout that executes all required commands and records results. This environment cannot clone the private repository because outbound GitHub DNS/network access is unavailable.
- No business, pharmacy, regulatory, legal, quality, accounting, security/privacy or production-release approval status was changed. The central approval register remains authoritative; pending gates remain pending.


