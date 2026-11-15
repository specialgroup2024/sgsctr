# INV-B supplier assurance workflow implementation deliberation — 2026-11-15

Status: simulated five-role technical deliberation; no independent agents or qualified human professionals participated. Owner implementation authorization: INV-OWN-004 (Approved with conditions). This record covers only the first non-operative assurance work-queue slice.

## Task and evidence

Implement the missing supplier assurance workflow entry points in the existing supplier UI, ASP.NET Core API and PostgreSQL model without inventing legal, pharmacy/quality, qualification, reviewer credential or procurement policy.

Verified baseline:
- Supplier master remains Draft-only.
- Supplier evidence remains Unverified-only.
- Supplier declarations remain OwnerProvided / Unverified.
- Due-diligence intake remains Pending-only.
- Existing supplier intake is in SupplierRegister.tsx, SupplierOnboardingIntake.tsx and PharmacySupplierExtensions.cs.
- INV-OWN-004 authorizes implementation but does not approve substantive criteria, named reviewer grants or downstream side effects.
- INV-SEC-001 and the relevant professional/policy gates remain pending.

## Dynamically selected profiles

1. **Architect — ASP.NET Core / PostgreSQL application architect:** owns the API, EF model, migration and BFF/UI integration proposal.
2. **Devil's Advocate — application security and database integrity reviewer:** challenges authorization, evidence ownership, state manipulation, audit integrity and unsafe eligibility activation.
3. **Clueless Client — pharmacy procurement/operator user:** checks whether the screens make it obvious what can be requested and what is not yet approved.
4. **SME — supplier assurance / regulated procurement workflow analyst:** checks separation of legal identity, evidence verification, due diligence, reviewer authority, qualification and purchasing/receiving eligibility.
5. **Maestro — senior enterprise application/technology architect:** technical determination after debate. This is a simulated profile, not an actual executive or professional approval.

## Stage 1 — Architect proposal

Add an assurance work-request queue attached to each supplier. Provide distinct request types for legal/licence verification, due-diligence execution, reviewer-authority application, qualification review, purchasing eligibility and receiving eligibility. Persist each request in PostgreSQL with actor, timestamp, reason, optional scope reference, optional supplier-owned evidence reference and correlation ID. Expose authenticated administrator-only API/BFF routes and a bilingual-ready UI using the existing translation function.

No request may itself be interpreted as a decision. Eligibility requests are created Blocked with a stable blocker code. Other assurance requests remain Pending. No endpoint changes evidence verification, supplier status, reviewer grants, qualification outcomes or downstream transaction state.

## Stage 2 — Devil's Advocate challenge

**Challenge:** A generic workflow endpoint can become a dangerous universal status setter; if a client can submit a case type/status or reference another supplier's evidence, it could create false verification or cross-supplier data leakage. An Administrator role is not a professional credential.

**Architect response and revision:**
- The client supplies only a known case type, reason, optional scope reference and optional evidence ID. It cannot submit status, decision outcome, reviewer identity, grant or eligibility boolean.
- Server determines initial state. Database check constraints permit only Pending for non-eligibility requests and Blocked for purchasing/receiving eligibility requests.
- Eligibility requests receive POLICY_AND_QUALIFICATION_NOT_APPROVED.
- API and BFF are authenticated; write/read assurance routes require Administrator (with the repository's existing Development-only authentication-disabled exception).
- Evidence references are checked against the supplier and enforced by a composite database foreign key (EvidenceId, SupplierId).
- Creation is audited. The case record is not an operational decision or authority grant.

Residual: no independent security/privacy reviewer has reviewed or accepted this implementation; no end-to-end negative tests have run.

## Stage 3 — Clueless Client challenge

**Challenge:** A user could mistake a green/complete-looking workflow queue for supplier approval, or believe a blocked eligibility request means the supplier has been fully assessed. A single request form with technical codes would not help a pharmacy operator understand the next action.

**Architect response and revision:**
- UI labels the section “Verification, qualification and eligibility workflows” and explicitly says these are controlled work requests, not approvals.
- Six human-readable workflow choices are provided.
- Eligibility requests display the blocker; the text states that no PO, receipt, stock or financial transaction is triggered.
- No Approve, Verify, Qualify or Eligible action is exposed.

Residual: full Arabic translation coverage and usability/accessibility tests are not yet verified.

## Stage 4 — SME analysis

- Legal identity and licence applicability are not interchangeable. A supplier declaration or document reference is not evidence of legal validity.
- Evidence existence, authenticity, current status and applicability require separate source/reviewer records and a qualified decision.
- Due diligence needs an approved versioned checklist and outcome model; none is invented here.
- Reviewer authentication is distinct from verified professional credentials, remit, delegation, conflicts and effective dates.
- Qualification decisions require approved criteria and an authorized reviewer; this request queue does not create one.
- Purchasing and receiving eligibility must remain separate and deny-by-default; neither is connected to PO/receipt/stock/finance.
- A scope reference is deliberately opaque until the owner/professionals decide the applicability dimensions.

The database stores the request queue only. It is not the final assurance domain model and must not be expanded into a one-field supplier status.

## Stage 5 — Maestro technical determination

**Determination:** Accept this as a limited, non-operative first implementation slice under INV-OWN-004, not as completion of INV-B operational assurance.

Accepted changes:
- additive PostgreSQL table and EF migration for assurance work requests;
- API endpoints and BFF route;
- per-supplier UI queue and request form;
- server-derived initial states and database-enforced fail-closed eligibility;
- supplier-scoped evidence referential integrity;
- audit event on creation;
- unit tests for case-type validation and fail-closed initial states.

Rejected alternatives:
- changing the supplier master from Draft;
- changing evidence from Unverified;
- allowing user-submitted decision/status values;
- equating Administrator with pharmacist/legal/quality/procurement authority;
- automatically granting reviewer authority;
- enabling purchasing/receiving;
- creating PO, receipt, stock, inventory or financial side effects.

## Acceptance and remaining work

Source implementation exists on branch feat/invb-supplier-assurance-workflows. Build, unit tests, migration generation/parity, PostgreSQL migration/integration, BFF/browser tests, authorization negative tests, concurrency, Arabic/accessibility, security/privacy review and VM runtime validation have not yet been evidenced.

Still required before operational decisions:
- owner-approved supplier scope dimensions and qualification policy;
- qualified legal/regulatory evidence sources and applicability process;
- approved due-diligence checklist and decision criteria;
- named reviewer identities, verified credentials, delegation, scope, conflicts and maker-checker rules;
- security/privacy review and residual-risk acceptance;
- independent purchasing and receiving eligibility policies and integration acceptance;
- release authorization.

No real supplier is verified, qualified or eligible by this change. No production release is authorized.