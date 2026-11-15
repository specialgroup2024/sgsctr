# INV-B — draft supplier register and evidence references

- Date: 2026-11-15.
- Work branch: `feat/pharmacy-inventory-invb-supplier-register`.
- Status: implementation proposal in review; not merged or production-enabled.
- Authority: INV-OWN-001 authorizes staged inventory implementation. Supplier qualification and operating policy remain pending under INV-OWN-002 / Q51.

## Scope boundary

Implement a category-neutral pharmacy supplier directory with:
- unique, normalized internal supplier code and display name;
- draft-only supplier records;
- generic evidence references with issuer/reference/source and issue/expiry dates;
- evidence permanently marked Unverified in this increment;
- a pending review-request queue with no decision endpoint;
- authenticated ASP.NET Core APIs, Next.js BFF/UI, audit events, additive migration and tests.

Explicitly excluded: legal identity validation, supplier due diligence, licence interpretation, approval/qualification, contact-person directory, document binary storage, purchasing limits, PO creation, supplier transmission, receipt eligibility, payment, tax and financial posting. Supplier-name duplicates are not automatically merged or rejected; only the internal code is unique. No supplier can be selected as approved for purchasing or receiving.

The earlier Q46 decision deferred supplier master from INV-01. The later, broader INV-OWN-001 authorization permits the separately sequenced INV-B draft register only; it does not close Q51 or authorize qualification.

## Evidence and regulatory context

- EDA GSDP v05/2025 (EDREX:GL.CIP.005) is an official current source for relevant storage/distribution activities. It contains requirements for documented procedures, authorized activities and traceability; applicability to each Special Group site, supplier category and role requires qualified review.
- EDA's warehouse licensing service describes licensing documentation and inspection steps. It does not provide a universal supplier qualification checklist for this application.
- Source review: [EDA GSDP v05/2025](https://edaegypt.gov.eg/media/ziepfko3/regulatory-guide-for-good-storage-and-distribution-practices-gsdp-_en-vr5.pdf), [EDA warehouse licensing service](https://edaegypt.gov.eg/en/services/services/licensing-services/procedural-service-licensing/warehouse-licensing/), checked 2026-11-15.
- No legal rule or supplier qualification criteria are encoded by this increment.

## Dynamic five-role deliberation

Profiles are simulated analytical perspectives, not independent agents or qualified professionals.

| Role | Selected profile | Contribution |
|---|---|---|
| Architect | .NET/PostgreSQL inventory application architect | Proposes draft supplier, evidence and review-request entities with transactional audit writes. |
| Devil's Advocate | Application-security and relational-integrity reviewer | Challenges false approval, duplicate legal entities, unsafe receipt linkage and untrusted evidence references. |
| Clueless Client | Pharmacy warehouse/procurement clerk perspective | Challenges whether staff could mistake a draft supplier or an evidence reference for an approved vendor. |
| SME | Pharmaceutical supply-chain controls analyst | Tests provenance, document expiry, role authority and separation of supplier identity from legal qualification. |
| Maestro | Senior enterprise application architect | Determines the technical boundary after the challenges; cannot grant business or professional approval. |

**Architect proposal:** implement a small, extensible directory and review queue, avoiding premature mandatory legal fields.

**Devil's Advocate challenge:** a supplier name plus a document reference can be mistaken for a verified trading partner. Duplicate names and fake/expired documents could be used downstream. The design must not create an Approved/Qualified state or let receipt/PO APIs treat a draft supplier as eligible.

**Clueless Client challenge:** warehouse staff may see a supplier in a list and assume they can buy from it. A URL/reference is not the actual document and the application must not imply that someone inspected it.

**SME analysis:** retain provenance and dates without interpreting evidence. Keep document verification unverified; supplier qualification criteria, accepted evidence types, contacts, licence holder/operator mapping, due diligence, renewal and disqualification need procurement, legal/regulatory and pharmacy review.

**Architect revision:** supplier status is database-constrained to Draft; evidence verification is constrained to Unverified; review requests are constrained to Pending; no decision endpoint, purchasing integration, receipt supplier FK or supplier transmission is added. Only internal supplier code is unique.

**Retesting:** the API response and UI label every supplier Draft and evidence Unverified. The UI explicitly says the register does not approve or qualify suppliers. The receipt draft remains free-text supplier reference until a qualified supplier policy is approved. Residual risk: staff can still copy a draft supplier name manually; training and operating policy remain necessary.

**Maestro determination:** proceed with this limited implementation proposal. Preserve all business/professional gates and do not claim supplier onboarding or qualification is complete.

## Acceptance evidence

- EF Core model, additive migration and snapshot must match.
- Supplier code normalization/validation has unit tests.
- API authorization is Administrator-only for writes when authentication is enabled; existing Development/authentication-disabled exception is retained.
- Supplier/evidence/review creation writes audit events in the same database save.
- PostgreSQL CI must validate migration snapshot and build; API/UI checks remain required.
- No production migration or stock/purchasing operation is authorized.

## Open approvals

Q51 remains open for supplier scope, legal identity evidence, licensing, due diligence, contacts, duplicate resolution, qualification criteria and reviewer authority. INV-OWN-002 remains pending. INV-SEC-001 and INV-REL-001 remain pending. See the central approval register and `.ai/memory/open-questions.md`.
