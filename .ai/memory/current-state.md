# Current state

Last repository review: 2026-11-14. Runtime evidence below was supplied by the owner from the Linux VM on 2026-11-11. Repository state and runtime state are deliberately distinguished.

## Current summary
The master branch contains the technical foundation, application shell, organization reference workspace, native ASP.NET Core Identity implementation, EDA regulatory-ingestion MVP and pharmacy inventory INV-00 UI prototype. Owner-provided VM checks confirm API liveness/readiness, PostgreSQL connectivity through both application and Identity contexts, Docker web-to-API connectivity and web system status. This does not prove real-user login, authorization enforcement or production readiness.

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
- No pharmacy inventory API, product catalogue persistence, supplier/purchasing, receiving, stock balance, transfer ledger, dispensing, claims, patient balances or financial posting exists.

## Pharmacy inventory phases
- PR #27 delivered Phase 0 discovery; PR #28 merged INV-00 requirements, costing examples, deliberation and Egypt regulatory scan.
- PR #29 merged on 2026-11-14 (merge commit 7114e0cd499e371d2e08c71f8f86bcd6148c6deb) and delivered the authenticated /pharmacies/inventory UI prototype.
- INV-00 screens: Overview, Product Catalogue, Receiving, Stock Transfers, Batches & Expiry and Reports. The overview reads active pharmacy locations through the existing organization API and shows API liveness separately from PostgreSQL readiness.
- All inventory write actions remain disabled. No synthetic products, quantities, receipts, expiry alerts or transactions are displayed.
- No inventory API, entity, DbSet, migration, seed data, product master, supplier, receipt, stock balance, movement, batch, transfer, valuation or GL posting exists.
- Q37: owner confirmed on 2026-11-14 that Mokattam is an EDA-licensed pharmaceutical warehouse under Chairman Decree 725/2024. Licence copy/number, holder, operator, validity and scope still require documentary/regulatory verification; the three hospital branches require separate classification. Q38 product taxonomy/controls and Q46 INV-01 data boundary/permissions remain open. Other inventory questions Q39–Q45 remain open.
- INV-01 approval package is recorded in .ai/delivery/pharmacy-inventory-inv01-approval-pack.md. Mokattam's warehouse type is owner-confirmed, not yet independently licence-verified. No production persistence is authorized until Q37 documentary review and the remaining owner/qualified pharmacy/regulatory/procurement approvals are recorded.
- No authentication verification, Data Protection volume verification or live VM/browser deployment verification was performed for PR #29.

## EDA regulatory intelligence
- Owner-approved EDA ingestion MVP is merged (PR #22); duplicate-index migration correction is merged (PR #24).
- Owner-provided VM log on 2026-11-11: five sources, 100 discovered links, 12 new documents, zero failures.
- This single scan does not prove exhaustive coverage, continuous availability, regulatory correctness or completed human review. No OCR, legal interpretation, outbound email/SMS/push or automatic pharmacy-rule updates are implemented.

## Governance and next milestone
- AGENT.md, AGENTS.md and .ai define dynamic five-role operation and human/professional approval boundaries.
- Next gate: resolve and record Q37, Q38 and Q46 with named owner and qualified reviewers; then approve the INV-01 data dictionary and implementation ADR. Stock movements and costing remain later gated work.
- Authentication verification and Data Protection volume verification remain on hold per owner instruction.
