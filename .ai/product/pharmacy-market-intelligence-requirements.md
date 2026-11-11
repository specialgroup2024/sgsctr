# Pharmacy market and regulatory intelligence

Status: EDA ingestion MVP code is merged to master. Latest CI build succeeds, but AppDbContext migration-snapshot validation still fails; API/PostgreSQL/Next.js smoke tests are therefore not yet executed. Production operation is not verified. Broader market-intelligence scope remains proposed.

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


## Execution backlog and acceptance gates

The following are not complete and must not be described as delivered until the acceptance evidence exists:

1. **Migration parity:** regenerate the AppDbContext snapshot using the exact pinned .NET/EF/Npgsql toolchain; inspect any generated schema operations; add only a genuine additive migration; verify both contexts report no pending changes.
2. **End-to-end runtime:** run PostgreSQL + API + Next.js in CI; verify startup readiness, authenticated workspace, scan, document retrieval and authorization paths.
3. **Document extraction:** add safe text extraction for HTML and text-based PDFs; detect scanned PDFs and route them to OCR review instead of silently treating them as searchable text. OCR engine/language support and deployment footprint require a technical decision.
4. **Metadata verification:** extract candidate publication date, effective date, document/reference number and issuing authority with source offsets/page evidence; retain confidence and require human confirmation before marking verified.
5. **Pharmacy product matching:** only implement after the authoritative pharmacy catalogue and identifiers exist; matching must be suggestions with reviewer confirmation, never automatic product-status or dispensing changes.
6. **Review workflow and audit:** add explicit review decisions, reviewer identity, timestamps, rationale, immutable event history and role-based permissions. Acknowledge remains distinct from verify/approve.
7. **Notification delivery:** add an outbox/retry design and configurable email first; SMS/push require provider selection, credentials, consent and delivery policy. In-app remains the fallback.
8. **Operations:** add source freshness/lag metrics, alerting, failed-run retry controls, backup/restore tests, document storage monitoring and an owner-approved retention/legal-hold policy before purge automation.
9. **Coverage assurance:** source inventory must record authority, scope, update mechanism, terms, host allowlist, last validation and known coverage gaps; no exhaustive-coverage claim without evidence.

### Human approval gates

- Qualified Egyptian regulatory/legal/pharmacy/quality reviewers must approve legal effect, applicability, clinical/quality action and effective dates.
- The business owner must approve retention duration, archival/deletion, external notification providers and escalation/SLA policy.
- Product matching must wait for the authoritative product catalogue and owner-approved matching thresholds.
