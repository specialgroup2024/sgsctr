# INV-B supplier operational expansion — technical design proposal

- Status: **Owner-approved technical design baseline (2026-11-15); delegated technical/security review and domain-policy gates remain pending.**
- Date: 2026-11-15.
- Scope basis: current master after supplier intake PR #66 and state reconciliation PR #67.
- Related controls: Q51, INV-OWN-002, INV-SEC-001, INV-REG-001, INV-PRO-001, INV-QLT-001 and INV-REL-001.
- The project owner approved this document as the technical design baseline on 2026-11-15. This accepts the architecture and staged delivery approach only. It is not an approved ADR unless separately ratified by the delegated technical authority, and it is not business policy, legal interpretation, professional approval, security/privacy acceptance or production authorization.

## 1. Outcome and boundaries

Design a controlled path from Draft supplier intake to evidence review, due-diligence execution, qualification decisions and separately evaluated purchasing/receiving eligibility.

The project owner has authorized this technical design baseline. D1 foundation work may proceed only within the existing Draft-only, non-operative boundary and subject to required technical/security review. D2–D6 operational workflows remain gated by their named business, professional, security and release approvals.

**Included in design:** identity and licence evidence verification; due-diligence case/check execution; reviewer identity and scoped authority; qualification decision history and lifecycle; contact-data options; derived eligibility evaluation; audit, security, privacy, UI/API and test architecture.

**Not authorized by this design:** operational verification, qualification decisions, named-person contact collection, PO creation, supplier transmission, receiving/inspection, inventory/financial posting, payment, production migration or release.

Preserve the existing PR #66 behavior unchanged: declarations remain OwnerProvided / Unverified, evidence remains Unverified, due-diligence intake remains Pending, and shared department channels remain the only contact type currently captured.

## 2. Repository discovery baseline

Verified source-level evidence on master:

- Supplier UI: web/app/pharmacies/inventory/SupplierRegister.tsx and SupplierOnboardingIntake.tsx.
- API: src/Sgsctr.Api/PharmacySuppliers/PharmacySupplierExtensions.cs.
- EF model: AppDbContext, PharmacySupplier, PharmacySupplierEvidence, PharmacySupplierReviewRequest, and the declaration, business-contact and due-diligence entity types.
- Migrations: 20261115150000_PharmacySupplierDrafts and 20261115160000_PharmacySupplierOnboardingIntake.
- Existing constraints include Unverified/OwnerProvided boundaries and a Pending-only due-diligence case; the current supplier status is Draft.
- BFF routes, English/Arabic presentation and audit events exist for the current intake slice.

No source evidence establishes deployed tables in the owner's PostgreSQL VM. PR #66 and its reruns did not produce executable CI evidence; builds, migration application, integration tests and browser behavior remain unverified. Do not infer runtime success from migrations or source files.

## 3. Proposed target architecture

Use the existing Pharmacy Suppliers module and ASP.NET Core API as the bounded application boundary. Keep the Next.js BFF as the browser-facing same-origin boundary. Keep PostgreSQL as the persistence authority. Do not introduce a separate microservice or external verification provider until a concrete need, data-sharing basis and integration approval are established.

Do not overload one supplier Status field with unrelated legal, quality, commercial and operational outcomes. Keep the supplier master identity separate from scoped verification records, due-diligence execution, qualification decisions and eligibility evaluations.

### 3.1 Candidate data capabilities

These are logical capabilities, not an approved physical schema or final field dictionary:

1. **Supplier legal identity:** versioned declarations and normalized identity attributes, each with provenance and verification state. Distinguish legal entity from trading name, branch/site and supplier account code.
2. **Evidence register:** evidence type, issuing authority, original source/reference, document version/hash where lawful, issue/expiry dates, retrieval time, language, provenance, access classification and review history. Do not equate upload/reference presence with validity.
3. **Verification case and attempts:** one traceable verification case with repeatable attempts, source used, query/retrieval timestamp, reviewer/actor, evidence examined, result, limitations and next-review trigger. External lookups must be allow-listed, SSRF-resistant, rate-limited and auditable if later approved.
4. **Licence applicability and verification:** record the qualified determination of which licence/activity/site requirements apply before attempting to verify a licence. Preserve the distinction between applicability assessment and document authenticity/status checks.
5. **Due-diligence execution:** versioned checklist templates and case instances. Store each check, evidence, outcome, rationale, reviewer and timestamp. Do not add a risk score, pass threshold or automatic disqualification until the owner and qualified reviewers approve the model.
6. **Reviewer authority:** explicit, time-bounded grants linked to authenticated subjects and approved scope. Record qualification evidence, remit, delegator, effective/expiry dates, conflicts and revocation. Authentication alone does not confer professional authority.
7. **Qualification decisions:** append-only decision records with decision maker, authority grant, scope, evidence set/version, rationale, conditions, effective/expiry dates and supersession/revocation link. A separate current-state projection may be maintained transactionally; history remains immutable.
8. **Contacts:** retain department-level shared channels. Named business contacts and any personal data remain excluded until privacy purpose, lawful basis, fields, access, retention, correction/deletion and export controls are approved.
9. **Eligibility evaluation:** a deny-by-default, server-side evaluation over an approved in-force qualification decision and approved scope. Purchasing eligibility and receiving eligibility must be separate outputs; do not assume one implies the other.

### 3.2 Scope dimensions requiring owner/professional decision

The data model must not assume whether qualification/eligibility is global or specific to legal entity, site, activity, product family, supplier category, contract or purchasing organization. The approval package must define the dimensions and precedence. If the scope cannot be proven, the evaluation must deny eligibility and return a reason code without exposing sensitive evidence.

## 4. API, UI and security design

- Keep reads and writes behind authenticated ASP.NET Core endpoints and same-origin BFF routes.
- Define separate permissions for evidence capture, verification execution, due-diligence review, qualification decision, suspension/reinstatement and eligibility administration.
- Enforce authorization and scope on the server for every endpoint; hiding controls in the UI is not authorization.
- Enforce maker-checker separation. A requester must not approve their own case; a reviewer must hold a valid grant for the exact scope at decision time. Conflict-of-interest handling requires an approved policy.
- Use optimistic concurrency/version checks for concurrent reviews and decision changes.
- Record append-only audit events for every state-changing action, failed privileged attempt and decision; include actor, authority grant, UTC timestamp, correlation ID, reason and before/after references without copying sensitive document contents into logs.
- Protect evidence references and any future files with malware scanning, content-type/size limits, private storage, access checks, retention and deletion controls.
- UI must show Draft, Unverified, Pending, verified evidence, qualification and eligibility as distinct concepts; show scope, effective dates, expiry and blockers. Arabic/English labels must not imply a legal conclusion beyond the recorded decision.
- Keep the supplier module disconnected from PO, receipt, stock, claims and finance until separate integration gates are approved.

## 5. Database and migration approach

Prefer additive EF Core migrations. Keep immutable evidence/decision history separate from mutable read projections. Use foreign keys, check constraints, unique constraints for approved active-scope rules, UTC timestamps and concurrency tokens. Use transactions to persist a decision, its audit event and projection update atomically.

Do not finalize table names, status enums, indexes or constraints until the owner-approved state machine and scope dimensions exist. Migrations must be tested against a fresh PostgreSQL database and an upgrade copy of the currently supported schema. Never reset or rewrite the owner's database to make a migration pass. Provide forward-fix and recovery instructions; do not claim production reversibility where data transformations are irreversible.

## 6. Staged delivery and gates

| Stage | Work | Entry gate | Exit evidence |
|---|---|---|---|
| D0 | Confirm policy, data dictionary, scope dimensions and state machine | Owner + procurement + pharmacy/quality + legal/regulatory input | Signed decision pack; Q51 resolved |
| D1 | Technical foundation: entities, migrations, audit, authorization and read-only UI | Owner accepts technical design; security/privacy review of foundation | Build/tests, EF parity, PostgreSQL integration, authorization negatives |
| D2 | Evidence verification workflow | Approved legal identity/licence applicability, primary sources and verification SOP | Traceable positive/negative/expired/ambiguous verification tests; qualified review |
| D3 | Due-diligence execution | Approved checklist, risk tiers, criteria, escalation and evidence policy | Versioned checklist tests and reviewer-authority tests |
| D4 | Qualification lifecycle and reviewer decisions | Approved state machine, authority/delegation, conflicts and separation of duties | Maker-checker, scope, expiry, suspension, revocation and audit tests |
| D5 | Purchasing and receiving eligibility | Explicit owner + procurement + pharmacy + quality/regulatory approval | Independent PO/receipt deny/allow tests; no bypass on expiry or scope mismatch |
| D6 | External integrations and release | Separate integration, security, professional and release approvals | Contract/security tests, migration rehearsal, recovery evidence and INV-REL-001 |

A stage does not automatically authorize the next stage. No operational behavior is enabled merely because a preceding stage passes tests.

## 7. Required decisions before D1

- Legal entity identity fields, matching rules and authoritative evidence.
- Supplier categories and the licence/activity/site applicability matrix.
- Permitted primary verification sources, manual versus automated checks, evidence retention and re-verification cadence.
- Due-diligence checklist, risk tiers, scoring (if any), exclusions, escalation and disqualification.
- Reviewer qualification evidence, role grants, delegation, conflicts, dual control and revocation.
- Qualification states/transitions, conditional approval, suspension, expiry, reinstatement and appeal/review.
- Scope dimensions and whether qualification, purchasing and receiving eligibility differ by site/product/activity/contract.
- Contact-data boundary and privacy controls.
- Duplicate legal-entity resolution and branch/trading-name survivorship.
- Security threat model, audit retention/tamper evidence, evidence storage and access controls.

The detailed owner/professional decision questions already recorded under Q51 remain authoritative until superseded by an approved decision.

## 8. Acceptance and release evidence

Before any operational implementation is accepted: approved decision matrix and field dictionary; verified reviewer authority; primary-source evidence procedures; migration/snapshot parity; PostgreSQL integration; API authorization and negative tests; BFF same-origin/CSRF tests; concurrency and maker-checker tests; append-only audit verification; English/Arabic UI and accessibility checks; privacy/security review; and documented migration/recovery rehearsal.

Production deployment requires all applicable approval-register gates, owner authorization and INV-REL-001. CI success alone is not business or professional approval.

## 9. Decision status

**Proposed — not approved.** This document authorizes no code/schema change. The next action is owner and qualified-review feedback on the decisions in Sections 3, 6 and 7. Until then, preserve the current Draft/Unverified/Pending-only behavior.
