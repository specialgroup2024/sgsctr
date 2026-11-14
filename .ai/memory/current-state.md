# Current state

Last repository review: 2026-11-14. Runtime evidence below was supplied by the owner from the Linux VM on 2026-11-11. Repository state and runtime state are deliberately distinguished.

## Current summary
The master branch contains the technical foundation, application shell, organization reference workspace, native ASP.NET Core Identity implementation and EDA regulatory-ingestion MVP. The owner-provided VM checks confirm API liveness/readiness, PostgreSQL connectivity through both application and Identity contexts, Docker web-to-API connectivity and the web system-status endpoint. This does not prove every UI workflow, real-user login, authorization policy or production readiness.

## Owner-provided organization structure
The owner identifies “Special Group” with Pharmacies Sector and Specialized Contracting Sector. Record provisionally as LE-01 with two sectors. Exact registered name/form/identifiers and whether both sectors are operated by the same legal person remain to be verified.

Pharmacy locations confirmed by owner:
- Mokattam main warehouse.
- Student Hospital branch.
- Qasr El-Aini Hospital branch.
- Manial Hospital branch.

The owner confirms that the three branches may transfer medicines and supplies directly between one another, without routing through Mokattam. This confirms the required route capability only; the proposed workflow, controls and valuation remain subject to approval.

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
- Native ASP.NET Core Identity is registered and persisted in the PostgreSQL identity schema. Keycloak is not an active Compose service; the legacy volume is retained and unused.
- API readiness checks both AppDbContext and AuthDbContext. Owner VM output on 2026-11-11 returned HTTP 200 with database, applicationContext and identityContext all connected.
- Owner VM output also returned HTTP 200 from web container fetch to http://api:8080/health/ready and from /api/system-status, reporting api=online and database=connected.
- Compose maps a named volume sgsctr_dataprotection_keys to /var/lib/sgsctr/data-protection-keys. Code persists the key ring there and requires a certificate/password outside Development. Actual volume persistence across container recreation and production certificate setup are not yet evidenced.
- Compose sets ASPNETCORE_ENVIRONMENT=Development and defaults AUTHENTICATION_ENABLED to false unless overridden. The successful health checks do not test real sign-in or authorization. Do not describe authentication as enforced in the local deployment without checking its effective environment and completing login/negative authorization tests.
- No approved enterprise role/permission matrix or persistent business audit-event model exists.

## Implemented application boundaries
- Web routes include overview, organization, pharmacies, contracting and pharmacy Regulatory Intelligence.
- Organization API returns owner-provided sector and location reference data; legal identity remains VerificationPending.
- Location create/edit/deactivate requires the configured Organization:ManagerSubjects allowlist, empty by default.
- No pharmacy inventory API, database schema, supplier/purchasing, receiving, stock balance, transfer ledger, dispensing, claims, patient balances or financial posting is implemented.

## Pharmacy inventory INV-00
- PR #27 delivered Phase 0 discovery; PR #28 delivered INV-00 requirements, costing examples, deliberation and regulatory scan.
- The inventory UI implementation is in .ai/delivery/pharmacy-inventory-ui-inv00.md and the /pharmacies/inventory route. It is a connected, non-posting prototype, not a production inventory module.
- The UI reads active pharmacy location reference records from the existing Organization API and reports API liveness separately from PostgreSQL readiness through /api/system-status.
- UI sections: Overview, Product Catalogue, Receiving, Stock Transfers, Batches & Expiry and Reports. Empty states are honest; no synthetic stock or product data is displayed; all stock-changing controls are disabled.
- The owner-confirmed direct branch-to-branch route is represented in the UI, but transfer workflows are not enabled.
- No inventory API, schema, migration, seed data, product master, supplier, receipt, stock balance, movement, batch, transfer, valuation or GL posting exists.
- Site licensing, product taxonomy, receipt/storage controls, EPTTS applicability, cost inputs and weighted-average policy remain open under Q37–Q46 and earlier questions. No business or professional rule is approved by the UI.
- No authentication verification, Data Protection volume verification or live VM/Docker deployment verification was performed in this UI phase.

## EDA regulatory intelligence
- Owner-approved EDA ingestion MVP is merged to master (PR #22); duplicate-index migration correction is merged (PR #24).
- Owner-provided VM log on 2026-11-11: 5 sources, 100 discovered links, 12 new documents, 0 failures.
- The MVP polls five configured EDA pages, stores supported HTML/PDF records and scan/alert metadata in PostgreSQL, and provides authenticated workspace/API operations when authentication is enabled.
- This single observed scan does not prove exhaustive EDA coverage, continuous availability, regulatory correctness or completed human review. No OCR, legal interpretation, outbound email/SMS/push or automatic pharmacy-rule updates are implemented.

## Governance and next milestone
- AGENT.md, AGENTS.md and .ai define dynamic five-role operation and human/professional approval boundaries.
- Next inventory gate: named owner/pharmacist/regulatory/accountant decisions for INV-01 reference-data scope, site classification and product/unit rules; only then implement approved persistence. Stock movements and costing remain later gated work.
