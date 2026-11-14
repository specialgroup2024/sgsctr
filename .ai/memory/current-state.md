# Current state

Last repository review: 2026-11-14. Runtime evidence below was supplied by the owner from the Linux VM on 2026-11-11. Repository state and runtime state are deliberately distinguished.

## Current summary
Master contains the generic INV-01 Draft-only catalogue foundation merged by PR #36 (merge commit 207d6e42351364ba47c555dc635a49e16fbd61f8). GitHub Actions run 43597393903 completed successfully: .NET restore/build/tests, EF snapshot checks, Docker startup and API/database/web smoke tests all passed. Feature branch `feat/inv02-regulated-product-profiles` adds provisional family assignments, product-level identifiers, regulatory evidence and lifecycle review requests; this branch is not merged or yet CI/runtime-verified. Owner-provided VM checks confirm API liveness/readiness, PostgreSQL connectivity through both application and Identity contexts, Docker web-to-API connectivity and web system status. This does not prove real-user login, authorization enforcement or production readiness.

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
- Master now has generic Draft-only product, unit and conversion persistence/API/BFF/UI plus catalogue audit events. The new INV-02 branch adds pending-review family proposals, separate identifier schemes, regulatory evidence references and activation/retirement requests that do not change product status. No suppliers, purchasing, receiving, stock balance, transfer ledger, dispensing, claims, patient balances or financial posting are implemented. No supplier/purchasing, receiving, stock balance, transfer ledger, dispensing, claims, patient balances or financial posting is implemented.

## Pharmacy inventory phases
- PR #27 delivered Phase 0 discovery; PR #28 merged INV-00 requirements, costing examples, deliberation and Egypt regulatory scan.
- PR #29 merged on 2026-11-14 (merge commit 7114e0cd499e371d2e08c71f8f86bcd6148c6deb) and delivered the authenticated /pharmacies/inventory UI prototype.
- INV-00 screens: Overview, Product Catalogue, Receiving, Stock Transfers, Batches & Expiry and Reports. The overview reads active pharmacy locations through the existing organization API and shows API liveness separately from PostgreSQL readiness.
- Master supports generic draft product/unit/conversion reference writes. INV-02 adds only provisional family/identifier/evidence/lifecycle review records; no product activation, synthetic stock, receipts, expiry alerts or transactions are added.
- Master contains CatalogueProduct, UnitOfMeasure, ProductUnitConversion and CatalogueAuditEvent entities, DbSets, additive migration, API/BFF/UI and no seed data. INV-02 branch adds CatalogueProductFamilyAssignment, CatalogueProductIdentifier, CatalogueRegulatoryEvidence and CatalogueLifecycleRequest with pending-only database constraints and APIs/UI. No supplier, receipt, stock balance, movement, batch, transfer, valuation or GL posting exists.
- Q37: owner confirmed on 2026-11-14 that Mokattam is an EDA-licensed pharmaceutical warehouse under Chairman Decree 725/2024. Licence copy/number, holder, operator, validity and scope still require documentary/regulatory verification; the three hospital branches require separate classification.
- Q38: product taxonomy and mandatory fields for medicines, chemotherapy, devices/supplies and cosmetics require qualified pharmacist, quality and regulatory review.
- Q46: owner approved the initial INV-01 scope on 2026-11-14: persistent product catalogue/product identity, units of measure and explicit packaging conversions, and pharmacy-location reference metadata. Supplier master is deferred. Purchasing, receiving, stock balances, lots, movements, dispensing, transfers, valuation, claims and accounting postings are excluded. On 2026-11-14 the owner also approved the general product identity/catalogue direction, explicit unit/conversion model, and server-side authorization plus auditable changes, and authorized implementation subject to existing gates. The owner subsequently authorized generic category-neutral Draft-only implementation while Q38 remains pending. The branch uses UUID identity, display name only, unit code/name/symbol, reduced positive integer conversion ratios, API-authorized reads, Administrator writes when authentication is enabled (local Development with authentication explicitly disabled retains local write access), and a narrow success-event audit log. Exact human SKU/duplicate rules, dimensional compatibility, conversion policy beyond exact rational storage, final permission matrix, audit retention/export/tamper evidence, import source and duplicate resolution remain open.
- The INV-01 approval package is recorded in .ai/delivery/pharmacy-inventory-inv01-approval-pack.md. PR #36 merged the generic catalogue foundation. On 2026-11-14 the owner instructed implementation of the previously excluded catalogue governance capabilities while preserving Q38 restrictions. Branch `feat/inv02-regulated-product-profiles` adds only provisional family assignments, pending identifiers/evidence and lifecycle requests; it does not approve or activate products. Supplier master and transactional workflows remain unimplemented pending detailed owner/procurement/pharmacy/accounting approvals. The candidate data dictionary and Q38 pharmacist/quality worksheet remain review artifacts; Q38 qualified review and detailed technical/security decisions remain gates for later regulated extensions and release.
- Mokattam's warehouse type is owner-confirmed, not independently licence-verified; other sites require separate classification.
- No authentication verification, Data Protection volume verification or live VM/browser deployment verification was performed for PR #29. Authentication and Data Protection verification remain on hold per owner instruction.

## EDA regulatory intelligence
- Owner-approved EDA ingestion MVP is merged (PR #22); duplicate-index migration correction is merged (PR #24).
- Owner-provided VM log on 2026-11-11: five sources, 100 discovered links, 12 new documents, zero failures.
- This single scan does not prove exhaustive coverage, continuous availability, regulatory correctness or completed human review. No OCR, legal interpretation, outbound email/SMS/push or automatic pharmacy-rule updates are implemented.

## Governance and next milestone
- AGENT.md, AGENTS.md and .ai define dynamic five-role operation and human/professional approval boundaries.
- PR #36 generic foundation CI passed on 2026-11-14 (build, tests, EF snapshot checks, Docker startup and smoke tests). INV-02 branch still requires CI/build/typecheck, migration validation and runtime review. Q38 qualified review remains required before family-specific mandatory fields, verification, product activation or operational use. Supplier/procurement, receipt/stock/transfer, costing, claims and GL workflows require their own recorded owner and qualified approvals. Detailed identity, conversion, permissions, audit retention/export, import provenance and duplicate-resolution decisions remain open. Supplier master remains deferred.
- Stock movements and costing remain later gated work.
- Authentication verification and Data Protection volume verification remain on hold per owner instruction.
