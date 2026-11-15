# Current state

Last repository review: 2026-11-15. Runtime evidence below was supplied by the owner from the Linux VM on 2026-11-11; the dashboard's later API-unreachable report has not been independently reproduced because this agent has no access to the owner's VM. Repository state and runtime state are deliberately distinguished. PR #58 and PR #60 are now reported by GitHub as merged (merge commits b1cbf5c0ac09e57e533bd5dcadd310605b9377f9 and 11814a371af6eca679a9396251a86c43a870fc3c respectively), despite their descriptions stating that no merge was requested/performed. No workflow runs were returned for the PR #60 merge commit; its validation claims remain unverified.

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
- API: ASP.NET Core net10.0, EF Core/Npgsql; SDK pin 10.0.403; Npgsql provider 10.0.3.
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
- PR #66 is open and unmerged. Its build-and-smoke-test and markdown-line-limit jobs failed before any steps/logs were available; no build, unit test, migration, PostgreSQL integration, authorization or browser command is evidenced as executed. Technical acceptance is pending.
- No legal/licence verification, qualification decision, reviewer-role grant, named-person contact data, purchasing/receiving eligibility, PO/stock/financial posting or production migration is implemented or authorized. Q51 / INV-OWN-002, INV-SEC-001 and INV-REL-001 remain open.
