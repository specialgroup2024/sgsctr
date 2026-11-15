# Current state

Last repository review: 2026-11-15. Runtime evidence below was supplied by the owner from the Linux VM on 2026-11-11; the current dashboard report of API unreachable has not been independently reproduced because this agent has no access to the owner's VM. Repository state and runtime state are deliberately distinguished.

## Current summary
Master contains the generic INV-01 Draft-only catalogue foundation (PR #36) and provisional INV-02 product-governance records (PR #37, merged 2026-11-14). PR #46 merged the separately labelled pharmacist demo examples on 2026-11-15. The latest master CI run on 2026-11-15 builds successfully and passes 27 API tests, but fails the AppDbContext EF snapshot check because the snapshot still contains the demo-only `DemoApproved` status. PRs #43 and #45 added historical demo migrations that can write that status; PR #44 removed the demo UI but did not reverse already-applied database state. PR #47 has now merged the forward correction; its current CI run has passed build, 27 API tests and EF snapshot validation, with Docker startup and runtime smoke tests still in progress. The user's current dashboard observation reports API unreachable / database not verified; this has not been independently reproduced on the Linux VM.

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
- Master has generic Draft-only product, unit and conversion persistence/API/BFF/UI plus catalogue audit events. PR #37 adds pending-review family proposals, separate identifier schemes, regulatory evidence references and activation/retirement requests that do not change product status. No suppliers, purchasing, receiving, stock balance, transfer ledger, dispensing, claims, patient balances or financial posting are implemented.

## Pharmacy inventory phases
- PR #27 delivered Phase 0 discovery; PR #28 merged INV-00 requirements, costing examples, deliberation and Egypt regulatory scan.
- PR #29 merged on 2026-11-14 (merge commit 7114e0cd499e371d2e08c71f8f86bcd6148c6deb) and delivered the authenticated /pharmacies/inventory UI prototype.
- INV-00 screens: Overview, Product Catalogue, Receiving, Stock Transfers, Batches & Expiry and Reports. The overview reads active pharmacy locations through the existing organization API and shows API liveness separately from PostgreSQL readiness.
- Master supports generic draft product/unit/conversion reference writes. INV-02 adds only provisional family/identifier/evidence/lifecycle review records; no product activation, synthetic stock, receipts, expiry alerts or transactions are added.
- Master contains CatalogueProduct, UnitOfMeasure, ProductUnitConversion and CatalogueAuditEvent entities, plus CatalogueProductFamilyAssignment, CatalogueProductIdentifier, CatalogueRegulatoryEvidence and CatalogueLifecycleRequest with pending-only database constraints and APIs/UI. No supplier, receipt, stock balance, movement, batch, transfer, valuation or GL posting exists.
- Q37: owner confirmed on 2026-11-14 that Mokattam is an EDA-licensed pharmaceutical warehouse under Chairman Decree 725/2024. Licence copy/number, holder, operator, validity and scope still require documentary/regulatory verification; the three hospital branches require separate classification.
- Q38: product taxonomy and mandatory fields for medicines, chemotherapy, devices/supplies and cosmetics require qualified pharmacist, quality and regulatory review.
- Q46: owner approved the initial INV-01 scope on 2026-11-14: persistent product catalogue/product identity, units of measure and explicit packaging conversions, and pharmacy-location reference metadata. Supplier master is deferred. Purchasing, receiving, stock balances, lots, movements, dispensing, transfers, valuation, claims and accounting postings are excluded. On 2026-11-14 the owner also approved the general product identity/catalogue direction, explicit unit/conversion model, and server-side authorization plus auditable changes, and authorized implementation subject to existing gates. The owner subsequently authorized generic category-neutral Draft-only implementation while Q38 remains pending. The branch uses UUID identity, display name only, unit code/name/symbol, reduced positive integer conversion ratios, API-authorized reads, Administrator writes when authentication is enabled (local Development with authentication explicitly disabled retains local write access), and a narrow success-event audit log. Exact human SKU/duplicate rules, dimensional compatibility, conversion policy beyond exact rational storage, final permission matrix, audit retention/export/tamper evidence, import source and duplicate resolution remain open.
- The INV-01 approval package is recorded in .ai/delivery/pharmacy-inventory-inv01-approval-pack.md. PR #36 merged the generic catalogue foundation; PR #37 merged the provisional product-governance records while preserving Q38 restrictions. These records do not approve or activate products. Supplier master and transactional workflows remain unimplemented pending detailed owner/procurement/pharmacy/accounting approvals. The candidate data dictionary and Q38 pharmacist/quality worksheet remain review artifacts; Q38 qualified review and detailed technical/security decisions remain gates for later regulated extensions and release.
- Mokattam's warehouse type is owner-confirmed, not independently licence-verified; other sites require separate classification.
- No authentication verification, Data Protection volume verification or live VM/browser deployment verification was performed for PR #29. Authentication and Data Protection verification remain on hold per owner instruction.

## EDA regulatory intelligence
- Owner-approved EDA ingestion MVP is merged (PR #22); duplicate-index migration correction is merged (PR #24).
- Owner-provided VM log on 2026-11-11: five sources, 100 discovered links, 12 new documents, zero failures.
- This single scan does not prove exhaustive coverage, continuous availability, regulatory correctness or completed human review. No OCR, legal interpretation, outbound email/SMS/push or automatic pharmacy-rule updates are implemented.

## Governance and next milestone
- AGENT.md, AGENTS.md and .ai define dynamic five-role operation and human/professional approval boundaries.
- PR #37 is merged, but the latest master CI currently fails the AppDbContext EF snapshot check due to the historical demo-only approval status; build and 27 API tests pass. PR #47 merged a forward migration to restore any `DemoApproved` INV-PRO-001 row to Pending, removed that status from the snapshot/database constraint, and made Compose wait for API/PostgreSQL readiness before starting web. CI has passed build, 27 API tests and EF snapshot validation; Docker startup and smoke tests remain in progress. Q38 qualified review remains required before family-specific mandatory fields, verification, product activation or operational use. Supplier/procurement, receipt/stock/transfer, costing, claims and GL workflows require their own recorded owner and qualified approvals. Detailed identity, conversion, permissions, audit retention/export, import provenance and duplicate-resolution decisions remain open. Supplier master remains deferred.
- Stock movements and costing remain later gated work.
- Authentication verification and Data Protection volume verification remain on hold per owner instruction.
