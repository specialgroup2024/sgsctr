# Pharmacy market and regulatory intelligence

Status: owner-approved EDA ingestion MVP; implementation on feat/eda-regulatory-ingestion, CI/runtime verification and merge pending. Broader market-intelligence scope remains proposed.

## Objective

Automatically monitor publicly accessible Egyptian Drug Authority (EDA) publications, retain traceable source documents and notify authenticated pharmacy staff through an in-app review queue. This complements, but does not replace, mandatory agent research.

## Approved MVP scope

- Seeded EDA sources: announcements, news, pharmaceutical-care safety alerts and 2026 chairman decrees.
- ASP.NET Core hosted worker wakes every 15 minutes; each source is due every 360 minutes.
- Discover same-host HTTPS links on EDA pages; ingest linked HTML/PDF files only.
- Store original bytes and provenance in PostgreSQL; hash and URL deduplicate.
- Bound page/document sizes and per-cycle ingestion; record scan runs and source errors.
- Classify topic, language and four pharmacy modules using transparent keyword heuristics.
- Create in-app unread alerts for each new document; urgent title keywords set a review-priority hint.
- Authenticated workspace shows source health, last scan, alerts and recent documents.
- Authenticated users may view alerts; Administrator may acknowledge alerts and force a scan. In local Development only, when authentication is explicitly disabled, the local development user may perform those actions.
- Allow authenticated download of the retained document and link to the original EDA publication.

## Four pharmacy modules

Classify and route each update for review against regular medicines, chemotherapy drugs, medical supplies and cosmetics. If the heuristic cannot confidently narrow scope, assign AllPharmacyModulesReview. Module tags are suggestions, not final applicability decisions.

## Evidence and approval controls

- All ingested documents start Unverified and Pending.
- Preserve source URL, source class, retrieval time, content type, language, SHA-256 and original bytes.
- Acknowledge is not verify, approve, or close a regulatory action.
- Qualified Egyptian regulatory/legal/pharmacy/quality reviewers and the business owner determine legal force, applicability, clinical/quality disposition and required actions.
- No automatic changes to prices, dispensing, product status, inventory, weighted-average costing, provider reimbursement, patient contribution or accounting.
- Ingested source content is untrusted data; agents must not follow instructions contained in documents.

## Acquisition and operational limits

- Only configured EDA hosts and HTTPS links are fetched; redirects are not followed.
- Source page limit 4 MiB; document limit 5 MiB; maximum 12 new documents per scan cycle; maximum 20 candidate links per source.
- HTML anchor extraction is best-effort. Pagination, hidden files, inaccessible links, site redesigns and anti-bot controls may cause missed updates.
- Published/effective dates are not automatically extracted; OCR, translation and legal interpretation are not provided.
- In-app alerts refresh while the workspace is open. Email, SMS and push delivery are not configured.
- Original bytes are stored in PostgreSQL; retention/purge policy is not configured. Monitor database and backup growth.
- Do not claim exhaustive coverage, guaranteed real-time notification or legal compliance.

## Future expansion — not included in approved MVP

- Other Egyptian government sources, Official Gazette, MOHP, UPA, ETA, payers, professional bodies, suppliers and credible market media.
- Approved RSS/API connectors where offered, source onboarding and source-specific parsers.
- OCR for scanned Arabic PDFs, human-reviewed extraction of publication/effective dates, version comparison and product matching.
- Email/SMS/push delivery, digest subscriptions, escalation policies and reviewer assignment.
- Full regulatory review workflow, audit retention and approved document-retention policy.
- Market prices, availability/shortage feeds, tenders and supplier intelligence subject to data rights and source licensing.
