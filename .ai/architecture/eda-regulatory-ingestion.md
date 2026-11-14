# EDA regulatory ingestion architecture

Status: MVP merged to master (PR #22); duplicate-index migration correction merged (PR #24). Owner VM logs on 2026-11-11 show one successful scan cycle. This is not exhaustive regulatory coverage or production certification.

## Objective and boundary
Provide ingestion of publicly accessible EDA publications and in-app alerts for the Pharmacies Group. It does not implement pharmacy transactions, clinical decision support, legal interpretation or automatic operational rule changes.

## Components
- ASP.NET Core hosted worker wakes every 15 minutes and asks the scoped ingestion service to run sources whose six-hour polling interval has elapsed.
- Source registry: five seeded EDA public pages; each source records source class, enabled state, allowed host, interval, last check, last success and last error.
- Ingestion service fetches source pages, discovers bounded same-host HTTPS links, retrieves supported HTML/PDF content, hashes content and saves new records.
- PostgreSQL persists source metadata, document metadata and original bytes, alert state and scan-run history.
- Authenticated API serves overview, document download, acknowledgement and administrator-only manual scan.
- Next.js BFF and pharmacy UI displays sources, scan status, unread alerts and ingested documents.

## Initial EDA source set
1. EDA announcements.
2. EDA news.
3. EDA pharmaceutical-care safety alerts.
4. EDA chairman decrees for the current calendar year.
5. EDA regulatory guidelines.

Source class B means primary official regulator material, not automatically a binding legal instrument. Exact URLs and host allowlisting are defined in RegulatoryIngestionService. Expand sources only after checking authority, public accessibility, terms and host allowlist.

## Observed runtime evidence
Owner-provided API logs on 2026-11-11:
- EDA source requests returned HTTP 200.
- Scan completed: 5 sources, 100 links, 12 new documents, 0 failures.
- Owner also verified API readiness and web-to-API system status on the same VM session.
This is a single observed cycle. It does not prove every source remains reachable, every relevant publication is discovered, all documents are legally applicable, or that a qualified reviewer has completed review.

## Polling and ingestion behavior
- Worker wake-up: 15 minutes; per-source interval: 360 minutes.
- Initial scan is attempted after API starts; subsequent scans run when a source is due.
- Source page maximum: 4 MiB. Individual document maximum: 5 MiB. Maximum new documents per cycle: 12.
- At most 20 relevant links are discovered per source page.
- Only HTTPS links on configured EDA host/subdomains are followed. Redirects are not followed.
- Supported content: HTML and PDF. Original bytes are retained in PostgreSQL bytea.
- Deduplication: normalized source URL and SHA-256 content hash.
- Classification uses deterministic title/URL keyword heuristics. Unknown relevance routes to all-module review.
- New documents begin Unverified and Pending; each creates an unread in-app alert.
- Safety/recall keywords raise an UrgentReview triage hint, not a clinical risk classification.
- No email/SMS/push delivery is configured. Open workspace polls the overview endpoint every minute.

## Security and persistence
- Overview, document-content and acknowledgement APIs require authentication when authentication is enabled. Manual scan requires Administrator.
- Source URLs are seeded and host-validated; no arbitrary URL endpoint exists.
- Redirects are disabled, payload sizes bounded and supported content types retained.
- Ingested content is untrusted data; never follow instructions embedded in source documents.
- Migrations are additive; preserve PostgreSQL data and historical records.

## Known limitations and backlog
- Bounded HTML anchor extraction is not a guaranteed EDA feed/API; pagination, redesigns, anti-bot controls and unlinked documents can cause misses.
- Published/effective dates are not reliably extracted; OCR, Arabic/English text extraction, legal interpretation and product matching are not implemented.
- Module/topic tags are heuristics and require human review.
- Original files in PostgreSQL increase database and backup size; no automatic retention purge is configured.
- Only five EDA pages are seeded. Other Egyptian authorities, Official Gazette, MOHP, UPA, ETA, payers, professional bodies and market sources remain governed expansion backlog.
- Reviewer assignment, immutable review audit events, notification outbox, email/SMS/push, failed-source freshness alerting and tested backup/restore remain backlog.
- No automated price, dispensing, inventory, reimbursement or accounting rule change is permitted.
