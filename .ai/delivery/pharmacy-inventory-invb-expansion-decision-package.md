# INV-B expansion — supplier onboarding decision package

- Date: 2026-11-15.
- Status: owner approved the limited non-operative intake slice on 2026-11-15 (INV-OWN-003); legal/professional rules and operational decisions remain pending.
- Related approvals: INV-OWN-001 (staged development authorization, approved); INV-OWN-002 (supplier operating policy, pending); Q51 (supplier master policy, open); INV-SEC-001 (security/privacy acceptance, pending).
- Current implementation: Draft supplier, Unverified evidence references and Pending review requests only.

## Owner request received

Continue INV-B to address:
- supplier legal identity and licence verification;
- qualification and approval decisions;
- due diligence and supplier contacts;
- approved-supplier eligibility for purchasing and receiving;
- qualified reviewer roles and procedures.

This request authorizes further design and implementation planning. It does not itself supply legal criteria, reviewer credentials, data-protection rules, qualification policy or professional sign-off. The existing approval register says owner authorization to develop does not approve those decisions.

## Safe technical boundary

The owner approved the following non-operative intake scope on 2026-11-15; see INV-OWN-003 in the approval register:
- capture supplier-declared legal identity claims, explicitly labelled OwnerProvided / Unverified;
- capture licence metadata and evidence references, explicitly Unverified;
- preserve evidence provenance, dates, source references and audit history;
- open due-diligence review cases that remain Pending and contain no invented checklist;
- show that no supplier is verified, qualified or eligible while decisions are outstanding.

No code in this package may turn a document URL, number, expiry date or supplier declaration into proof of validity. No legal identity or licence verification is performed automatically.

## Decisions required before operational verification

| Decision | Required authority | Questions to resolve |
|---|---|---|
| Legal identity data | Owner + Egyptian legal reviewer | Required entity names/languages, legal form, jurisdiction, registration authority/number, tax references, registered address, legal holder/operator relationships and authoritative evidence |
| Licence applicability | Egyptian regulatory/legal reviewer | Which supplier categories and activities require which licences; issuing authorities; holder/site/scope matching; validity and renewal rules |
| Verification method | Legal/regulatory + security | Permitted primary sources, official portal checks, certified copies, direct confirmation, evidence retention and re-verification cadence |
| Due diligence | Owner + procurement + legal/regulatory | Scope, risk tiers, ownership/beneficial ownership where applicable, sanctions/adverse findings, quality and financial checks, escalation and disqualification rules |
| Contacts and privacy | Owner + privacy/security reviewer | Business-only versus named contacts, minimum fields, purpose, access, lawful basis, retention, correction/deletion and export controls |
| Qualification outcomes | Owner + procurement + qualified pharmacy/quality/legal reviewers | Allowed states, criteria, conditional approval, suspension, rejection, expiry, appeal/review and who makes each decision |
| Reviewer authority | Owner + relevant professional bodies | Named people, verified credentials, remit, delegation, conflicts of interest, dual control and separation of duties |
| Purchasing/receiving eligibility | Owner + procurement + pharmacy operations + pharmacist/quality | Whether eligibility is global or site/product-specific; checks at PO and receipt; expiry/suspension behavior; exceptions and emergency supply |
| Duplicate resolution | Owner + legal/procurement | Legal-entity identity matching, branches/trading names, duplicate merge/survivorship and audit history |

## Proposed workflow — not approved

1. Capture supplier declaration and evidence references as unverified.
2. Submit a due-diligence case for review; retain Pending until a qualified reviewer is assigned.
3. Record evidence reviewed, reviewer identity/qualification evidence, decision rationale and date only after the authority matrix and criteria are approved.
4. Record a qualification decision only through server-side permission checks and separation-of-duties controls.
5. Calculate purchasing/receiving eligibility only from an approved, in-force qualification decision and its approved scope.
6. Re-review on evidence expiry, material supplier change, adverse finding or policy-defined interval.

The state names, decision transitions and review intervals above are design proposals, not approved business rules.

## Implementation blocks

- No Verified, Qualified, Approved, Suspended or Eligible state may be enabled until the decision table and reviewer authority are approved.
- No PO or receipt API may consume supplier eligibility before Q51 and the applicable purchasing/receiving approvals are closed.
- No supplier contact-person PII should be stored until privacy purpose, access, retention and deletion controls are approved.
- No legal or regulatory interpretation is inferred from EDA guidance. EDA source evidence is relevant to pharmacy establishments and storage/distribution; supplier-specific applicability must be assessed by qualified Egyptian reviewers.
- No production migration or VM deployment is authorized by this package.

## Acceptance evidence for the later implementation

- Approved field dictionary and data classification.
- Approved evidence types and verification procedure with primary-source provenance.
- Approved due-diligence checklist, risk model and decision matrix.
- Verified reviewer identities/qualifications and server-side role tests.
- Database constraints preventing self-approval, unauthorized transitions and eligibility from pending/expired/suspended records.
- Audit tests for capture, review assignment, decision, expiry, suspension and eligibility evaluation.
- PostgreSQL migration/integration tests, API authorization tests, BFF/UI tests in English and Arabic, and a documented migration/recovery rehearsal.
- Owner and qualified professional sign-offs recorded in the central approval register.

## Approved implementation slice — 2026-11-15

- Supplier-declared identity/licence metadata is captured as OwnerProvided / Unverified claims.
- Due-diligence intake cases are created as Pending only; no checklist, risk score, check execution or decision is provided.
- Business contact channels are limited to department-labelled business email, business phone/switchboard and business website; no person-name field is provided.
- Every write records actor, UTC time, change reason and an audit event in the same database save.
- The implementation must remain disconnected from purchasing, receiving eligibility, stock and finance.

## Current determination

Proceed with this limited implementation under INV-OWN-003. Actual legal/licence verification, qualification decisions, reviewer authorization and purchasing/receiving eligibility remain blocked by Q51 / INV-OWN-002 and applicable professional/security gates. The free-text business phone/email value still depends on user honesty and requires privacy/security review; no automated personal-data detection is claimed.
