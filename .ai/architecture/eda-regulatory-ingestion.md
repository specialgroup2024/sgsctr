# EDA regulatory ingestion architecture

Status: implemented MVP on feature branch; CI and runtime verification pending.

## Objective and boundary

Provide automatic ingestion of publicly accessible EDA publications and in-app alerts for the Pharmacies Group. This is a shared platform capability consumed only by the pharmacy domain. It does not implement pharmacy transactions, clinical decision support, legal interpretation or automatic operational rule changes.

## Components

- ASP.NET Core hosted worker: wakes every 15 minutes and asks the scoped ingestion service to run sources whose six-hour polling interval has elapsed.
- Source registry: seeded EDA public pages; each source records source class, enabled state, allowed host, interval, last check, last success and last error.
- Ingestion service: fetches the source page, discovers relevant same-host HTTPS links, retrieves supported HTML/PDF content, hashes content and saves new records.
- PostgreSQL: persists source metadata, document metadata and original bytes, alert state and scan-run history.
- Authenticated API: serves overview, document download, acknowledgement and administrator-only manual scan.
- Next.js BFF and pharmacy UI: keeps bearer tokens server-side, shows sources, scan status, unread alerts and ingested documents.

## Initial EDA source set

1. EDA announcements.
2. EDA news.
3. EDA pharmaceutical-care safety alerts.
4. EDA chairman decrees for the current calendar year (the seeded URL rolls forward by year).\n5. EDA regulatory guidelines.

The exact URLs and allowlisted host are seeded in RegulatoryIngestionService. Source class B means primary official regulator material, not automatically a binding legal instrument. Expand sources only after checking authority, public accessibility, terms and host allowlist.

## Polling and ingestion behavior

- Worker wake-up: 15 minutes; per-source interval: 360 minutes.
- Initial scan is attempted after the API starts; subsequent scans run when a source is due.
- Source page maximum: 4 MiB. Individual document maximum: 5 MiB. Maximum new documents per cycle: 12.
- At most 20 relevant links are discovered per source page.
- Only HTTPS links on the configured EDA host (or its subdomains) are followed. HTTP redirects are not followed; a redirect is recorded as a source failure for operator review.
- Supported content: HTML and PDF. Original bytes are retained in PostgreSQL bytea.
- Deduplication: normalized source URL and SHA-256 content hash.
- Classification: deterministic title/URL keyword heuristics for topic, language and four pharmacy modules. Unknown relevance is routed to all-module review.
- Every new document begins Unverified and Pending; every new document creates an unread in-app alert.
- Safety/recall keywords raise the alert to UrgentReview; this is a triage hint, not a clinical risk classification.
- No email/SMS/push delivery is configured. The authenticated workspace polls the overview endpoint every minute while open.

## Persistence

- RegulatorySources: source catalogue and polling health.
- RegulatoryDocuments: provenance, metadata, hash, classification, review state and original document bytes.
- RegulatoryAlerts: unread/acknowledged in-app notification state.
- RegulatoryScanRuns: per-source execution and error history.

Migrations are additive and reversible. Do not delete existing PostgreSQL volumes or historical records to deploy this feature.

## Security and safety

- All overview, document-content and acknowledgement APIs require authentication.
- Manual scan requires the existing Administrator role.
- No endpoint accepts an arbitrary URL or host; source URLs are seeded and host-validated.
- Redirects are disabled, payload sizes are bounded, and only supported content types are retained.
- The BFF keeps bearer tokens server-side. Document content is served only through an authenticated API route.
- The monitor does not execute documents, parse macros, or run scripts.
- Ingested content is untrusted data. AI agents must not follow instructions embedded in source documents.
- No automated OCR, legal interpretation, effective-date extraction, product-level matching, email notification, or operational rule change is implemented.

## Known limitations and next design decisions

- HTML anchor extraction is a bounded MVP, not a guaranteed EDA feed/API. Site redesigns, anti-bot controls, pagination and unlinked documents can cause misses.
- A source returning a redirect or inaccessible page will show a failure; no automatic redirect fallback exists.
- Published/effective dates are not reliably extracted; PublishedAtUtc remains null until verified metadata extraction is added.
- Module/topic tags are heuristics and require human review.
- Original files are stored in PostgreSQL; storage growth, backup size and retention must be monitored. No automatic deletion is configured.
- Source checks run in the API process. Production should eventually separate the worker into a dedicated deployment if scale or availability requires it.
- The MVP only seeds EDA pages. Other Egyptian authorities, Official Gazette, MOHP, UPA, ETA, payers, professional bodies and market sources remain a governed expansion backlog.
- Source review, qualified human ownership, alert escalation, retention, and data licensing remain owner decisions.
