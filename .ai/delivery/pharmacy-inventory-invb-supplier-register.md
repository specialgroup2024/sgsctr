# INV-B — draft supplier register and evidence references

- Date: 2026-11-15.
- Original work branch: `feat/pharmacy-inventory-invb-supplier-register`.
- Merge evidence: PR #61 closed as merged on 2026-11-15. Its PR body contains stale text saying it was not merged; GitHub PR metadata and master commit ancestry confirm the merge.
- Status: source implementation merged to master via PR #61 (merge commit `cad05b42d44942e1ddcf0aa5ffa6062cee258670`); technical acceptance is blocked/unverified; not production-enabled.
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

## Implemented source scope on master

- Entities and migration: `PharmacySupplier`, `PharmacySupplierEvidence`, `PharmacySupplierReviewRequest`, migration `20261115150000_PharmacySupplierDrafts`, and `AppDbContext` mappings/snapshot.
- API: authenticated list/detail, create draft, add unverified evidence reference, request review, read pending queue and permission check.
- UI integration: Next.js BFF routes and Supplier Register workspace component.
- Audit: supplier, evidence and review-request creation events are persisted in the same EF Core save as their corresponding records.
- Constraints: supplier status is Draft only; evidence is Unverified only; review requests are Pending only; supplier code is unique; one pending review per supplier is enforced by a filtered unique index.
- The API does not expose supplier qualification/approval or connect draft suppliers to purchase orders or receipt eligibility.

## Technical acceptance status

- PR #61 merge commit: `cad05b42d44942e1ddcf0aa5ffa6062cee258670`.
- The `build-and-smoke-test` and `markdown-line-limit` GitHub checks both failed immediately on the merged commit. The available job records showed runner_id 0, no executed steps and no downloadable logs; reruns also failed before useful execution evidence was produced.
- Consequently, these checks are **not evidenced as passed**: application build, automated tests, EF Core model/snapshot parity, PostgreSQL migration/integration, API authorization, BFF/UI, English/Arabic localization, browser behavior and live deployment.
- The unit tests exist in `tests/Sgsctr.Api.Tests/SupplierRulesTests.cs`, but the PR record says they were not run locally. Source presence is not a test pass.
- No migration has been applied to the owner's VM or production database as part of INV-B.

## Acceptance evidence

- EF Core model, additive migration and snapshot must match.
- Supplier code normalization/validation has unit tests.
- API authorization is Administrator-only for writes when authentication is enabled; existing Development/authentication-disabled exception is retained.
- Supplier/evidence/review creation writes audit events in the same database save.
- PostgreSQL CI must validate migration snapshot and build; API/UI checks remain required. Current CI history does not provide successful evidence.
- No production migration or stock/purchasing operation is authorized.

## Current external-source check — 2026-11-15

- EDA's current regulatory index lists GSDP v05/2025 and updated 2026 guidance for medical-product store licensing and warehouse licensing organization. The EDA warehouse-licensing service describes the licensing process and inspection steps.
- These sources establish that licensing and good-storage/distribution controls are regulated topics; they do not provide a universal supplier qualification checklist for this application. No supplier legal criteria, accepted evidence list or qualification logic has been inferred or encoded.
- Sources: [EDA GSDP v05/2025](https://edaegypt.gov.eg/media/ziepfko3/regulatory-guide-for-good-storage-and-distribution-practices-gsdp-_en-vr5.pdf), [EDA medical-products institution licensing index](https://www.edaegypt.gov.eg/en/the-regulatory-reference-of-the-egyptian-drug-authority-eda/regulatory-guidelines/ca-of-pharmaceutical-institutions-licensing/), [EDA warehouse licensing service](https://edaegypt.gov.eg/en/services/services/licensing-services/procedural-service-licensing/warehouse-licensing/). Checked 2026-11-15.

## Technical acceptance follow-up

The merged INV-B slice is being hardened under [INV-B technical acceptance](pharmacy-inventory-invb-technical-acceptance.md). This follow-up adds API/BFF/PostgreSQL/English-Arabic UI acceptance coverage and fail-closed audit attribution. It does not expand supplier business authority. Until the recorded CI matrix passes, technical acceptance remains **in progress**; production release remains blocked by INV-OWN-002, INV-SEC-001 and INV-REL-001, and supplier qualification remains blocked by Q51.

## Open approvals

Q51 remains open for supplier scope, legal identity evidence, licensing, due diligence, contacts, duplicate resolution, qualification criteria and reviewer authority. INV-OWN-002 remains pending. INV-SEC-001 and INV-REL-001 remain pending. See the central approval register and `.ai/memory/open-questions.md`.

## INV-B expansion request — 2026-11-15

The owner requested expansion to legal identity/licence verification, qualification and approval decisions, due diligence, supplier contacts, purchasing/receiving eligibility and qualified reviewer procedures. This request is recorded in [the supplier onboarding decision package](pharmacy-inventory-invb-expansion-decision-package.md) and [dynamic deliberation](../roles/invb-supplier-onboarding-expansion-deliberation.md).

The request does not itself approve legal/licence criteria, due-diligence scope, privacy/retention rules, reviewer qualifications, separation of duties or purchasing/receiving policy. The safe next technical slice is non-operative intake of owner-declared identity/licence claims as Unverified and due-diligence cases as Pending, only after the owner confirms the data-field and contact-data boundary. Named contact-person data remains blocked pending privacy review. Verification, qualification decisions, reviewer authority and downstream eligibility remain disabled until Q51 / INV-OWN-002 and the relevant professional/security approvals are recorded.

PR #63 and PR #64 are now merged to master by the owner. PR #63's required CI jobs did not execute because no GitHub runner was assigned; PR #64 removes the duplicate translation keys but has no verified Docker/typecheck result. INV-B technical acceptance therefore remains blocked/unverified.


## Approved draft onboarding intake extension — 2026-11-15

The owner approved the non-operative intake slice as INV-OWN-003. The feature branch adds typed supplier-declared legal identity/licence claims (OwnerProvided / Unverified), department-labelled business contact channels (DepartmentEmail, BusinessPhone, BusinessWebsite) and due-diligence intake cases constrained to Pending. ASP.NET Core endpoints, EF Core entities/migration/snapshot, same-origin Next.js BFF routes, supplier workspace forms and Arabic translations are included. Writes add audit events in the same EF Core save. No verification, qualification, reviewer grant, named-person contact data, PO/receipt eligibility, stock/GL posting or production migration is included.

PR #66 is open and unmerged. Its build-and-smoke-test and markdown-line-limit jobs failed immediately with no executed steps or downloadable logs; no build, test, migration parity, PostgreSQL integration, authorization or browser command is evidenced as having started. This is a runner/CI execution blocker, not a code pass or a demonstrated code assertion failure. The business channel value remains free text; the UI warns against personal details, but automatic detection is not claimed. Security/privacy review remains pending. See [implementation deliberation](../roles/invb-supplier-draft-onboarding-implementation-deliberation.md) and the central approval register.
