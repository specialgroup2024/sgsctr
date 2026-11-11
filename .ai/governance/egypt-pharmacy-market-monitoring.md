# Egypt pharmacy market and regulatory intelligence

Status: mandatory agent operating control; EDA public-page ingestion and in-app alerts are owner-approved MVP scope, implemented on feat/eda-regulatory-ingestion pending verification and merge.

## Purpose and scope

Keep pharmacy discovery, requirements, architecture, implementation, testing and operations informed by current Egyptian pharmaceutical-market conditions and applicable Egyptian requirements. Monitor the four owner-defined pharmacy modules: regular medicines, chemotherapy drugs, medical supplies and cosmetics. Include relevant pharmacy logistics, suppliers, providers/payers, reimbursement, pricing, inventory, distribution, workforce, tax, privacy and business continuity developments.

"All known updates from any source" means broad, systematic source discovery and transparent coverage. It does not mean an agent can guarantee that every publication or private market event is discoverable. Record coverage limits and unknowns.

## Two separate workstreams

1. **Agent intelligence:** mandatory research before and during pharmacy-related work; maintain dated, cited evidence and identify impacts.
2. **In-app EDA monitor:** use the approved EDA MVP described in ../architecture/eda-regulatory-ingestion.md. It polls four configured public EDA pages, ingests linked HTML/PDF documents, deduplicates by URL/hash, stores originals and creates in-app alerts. The implementation is not proof of complete EDA coverage or real-time delivery. Other Egyptian sources, paid feeds, restricted services and email/SMS/push channels require separate approval and scoped work.

## Monitoring cycle

- At task start: refresh relevant primary sources and check changes since the last recorded review.
- Daily on active regulatory/high-risk work: check critical EDA, government and safety notices when source access permits.
- Weekly: scan all registered source classes for new market, operational and regulatory developments.
- Monthly: produce a consolidated Egypt pharmacy intelligence digest, source-coverage report, impact assessment and unresolved questions.
- Event-driven: immediately escalate recalls, safety alerts, controlled-product changes, urgent dispensing/storage notices, licensing changes and effective-now legal requirements.
- Before release: perform a change scan covering all laws, regulations, circulars and guidance relevant to affected workflows.

The EDA worker is a scheduled best-effort service on the implementation branch. Agents must check its last-success/error status and still refresh relevant primary sources for high-risk work. If the feature is not deployed, its worker is failing, or source coverage is incomplete, perform and timestamp manual checks; never claim complete or real-time monitoring.

## Required topic coverage

- Product registration, marketing authorization, classification, availability and withdrawal.
- Pricing, price revisions, price lists, reimbursement and payer/contract changes.
- Recalls, batch alerts, falsification/counterfeit warnings, quality defects and pharmacovigilance.
- Prescription/OTC classification, dispensing restrictions, controlled and misuse-potential substances.
- Pharmacy, warehouse, medical-store and other establishment licensing/inspection.
- Good storage/distribution, cold chain, hazardous products, transport, traceability and track-and-trace.
- Medical devices and supplies; cosmetics and relevant product-specific requirements.
- Chemotherapy/oncology supply continuity, handling and safety requirements; never infer clinical protocols.
- Supply shortages, import/export, local manufacturing, procurement/tenders and supplier-market changes.
- Provider/payer contracts, coverage, reimbursement, patient contribution and claims practices.
- Tax, e-invoicing, consumer protection, privacy/health data, employment and other cross-cutting Egyptian requirements where applicable.
- Market signals: launches, discontinuations, capacity, distribution, market consolidation, supplier changes and material price/availability trends.

## Source hierarchy and evidence

Classify every item:
- **A — Primary binding source:** Official Gazette text, enacted law, decree, ministerial decision or binding regulator order, verified in its original publication.
- **B — Primary official regulator/government material:** EDA/MOH/other competent authority guideline, circular, safety notice, official list, announcement or portal entry. Determine whether it is binding, guidance, advisory or informational.
- **C — Official market/public-sector source:** UPA, health insurance/payer, public procurement, tax, statistics or other competent public body material relevant to the topic.
- **D — Professional/industry source:** Egyptian Pharmacists Syndicate, professional bodies, trade associations, chambers, manufacturers, distributors, suppliers and healthcare providers.
- **E — Media/market signal:** reputable Egyptian business/health news, interviews, public statements and market commentary.
- **F — Informal signal:** public social posts, forums, unverified reports and crowdsourced shortage reports.

A source's category is not a truth score. Corroborate material claims. D–F can trigger investigation but never establish a legal obligation, official price, recall, shortage, product status or compliance conclusion on their own. For legal status, retrieve the primary instrument and check publication, amendments, effective date, transitional provisions and current validity.

## Required evidence record

For every material update record: stable ID; title; topic/module; source name and class; original URL/document; publication and effective dates (separately); retrieval timestamp (Africa/Cairo); language; issuing authority; instrument/document number and version; binding/guidance/informational classification; affected products, operations and locations; summary; exact evidence/extract or page; confidence; corroborating/conflicting sources; superseded status; impact assessment; required owner/professional; action, due date and status; next review date.

Preserve original Arabic text where available and provide a careful English working translation. Do not rely on machine translation alone for legal interpretation. Keep snapshots or document hashes where legally permissible; retain source provenance and revision history.

## Impact and implementation gates

For each update, assess: no impact / monitor / requirements change / design change / control or data change / test change / operational action / release blocker. Map it to affected product modules, requirements, code paths, data, integrations, tests, training and SOPs.

Agents may research, summarize, compare, draft requirements, prepare test cases and recommend actions. Only the authorized owner/professional may decide legal interpretation, pharmacy practice, licensing, clinical/quality action, pricing policy, accounting/tax treatment or business policy. Do not change a workflow, rate, formula, stock rule or production configuration solely because a news item or draft circular appeared.

Record each decision in the appropriate register with status proposed, approved, rejected, superseded or under review. Approval must identify the responsible person/role, evidence reviewed, date, scope and effective date. An agent recommendation is not approval.

## Conflict, uncertainty and urgent alerts

- If sources conflict, preserve both, prefer the competent primary source for its remit, check amendments and ask qualified counsel/regulatory personnel.
- If a draft, consultation or proposed bill is found, label it draft and do not implement as current law.
- If publication/effective date or applicability is unclear, mark unverified and block affected compliance claims.
- Urgent safety or recall signals must be escalated to the designated pharmacist/quality lead immediately; the app must not autonomously decide clinical disposition.
- Never suppress an alert because a later article contradicts it; reconcile with the issuing authority and preserve the audit trail.

## Output required for pharmacy tasks

Include a dated "Egypt market and regulatory scan" in the task record: scope searched, sources checked, relevant updates, source classes, affected requirements, no-update result where applicable, coverage gaps, impact, proposed actions, approvals needed and next review. Cite primary documents and exact URLs. Do not say "fully compliant", "all updates captured" or "no regulatory changes" without defined scope and recorded evidence.

## Review ownership

Dynamic roles must include, when relevant: Egyptian regulatory affairs specialist; licensed community/hospital pharmacist or pharmacy operations specialist; pharmacovigilance/quality specialist; pharmaceutical supply-chain and market analyst; Egyptian legal counsel; tax/accounting specialist; and ICT/security/data/QA specialists. Select only relevant profiles per task and disclose when qualified human review is unavailable.
