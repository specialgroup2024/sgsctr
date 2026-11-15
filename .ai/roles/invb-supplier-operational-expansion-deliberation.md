# INV-B supplier operational expansion — five-role deliberation

- Date: 2026-11-15.
- Repository baseline: master after PR #66 and the supplier-state reconciliation.
- Method: simulated analytical perspectives in one model; not five independent agents or qualified human reviewers.
- Decision status: proposed technical design only.

## Dynamic specialization selection

| Stable role | Selected profile | Why relevant | Limitation |
|---|---|---|---|
| Architect | Pharmacy supplier-domain / .NET enterprise architect | Separates supplier identity, verification, due diligence, decisions and eligibility | No authority to set pharmacy/procurement policy |
| Devil's Advocate | Application security, database integrity and privacy red-team reviewer | Challenges privilege escalation, stale evidence, scope bypass, PII and audit integrity | No penetration test or independent human review performed |
| Clueless Client | Pharmacy procurement administrator and branch receiving operator | Tests whether the workflow is understandable and usable under daily pressure | Simulated user perspective; actual staff validation required |
| SME | Supplier assurance, pharmaceutical quality/supply-chain and Egyptian regulatory evidence analyst | Tests provenance, licence applicability, qualification and ongoing assurance | No Egyptian legal/pharmacy qualification or source applicability determination claimed |
| Maestro | CTO-level application/data/security technical authority | Resolves technical architecture and staged delivery | Technical determination only; cannot approve business or professional decisions |

## Architect — initial proposal

Extend the current supplier record with a single verification/qualification workflow, retaining the existing supplier master as the anchor. Add reviewer assignment, evidence verification, due-diligence results, a qualification state and eligibility flags. Keep the UI in the current Supplier Register and expose the workflow through the existing API/BFF.

## Devil's Advocate — rejection and serious flaws

I reject the single-workflow/single-status version of that proposal.

1. **Critical integrity flaw:** one Verified or Approved supplier status would conflate legal identity, individual licences, quality due diligence, commercial qualification and purchasing/receiving eligibility. A supplier may be valid for one site/activity/product scope and invalid for another. A global flag could permit an unauthorized purchase or receipt after a licence expires or a scope changes.
2. **Privilege flaw:** assigning a generic reviewer role does not prove professional qualification or delegated authority for the supplier, site, activity or decision type. A user could approve their own request or act outside their remit.
3. **Evidence flaw:** a document number, URL or uploaded copy is not proof of current authenticity, holder, site, scope or validity. Automated source checks can be stale, unavailable or misinterpreted.
4. **Privacy flaw:** contacts may introduce personal data. Current department-channel-only capture does not establish purpose, lawful basis, retention or access for named contacts.

Required change: separate records and decisions, scope authority, keep fail-closed eligibility, and defer named contacts pending privacy approval.

## Clueless Client — independent practical rejection

I reject a technically elaborate workflow that asks branch staff to interpret licences, legal entities, risk scores or regulatory source documents. The operator needs a clear answer to “Can I use this supplier for this specific purchase or receipt, and why?” They also need to know who owns the blocker and what evidence is missing.

A single red/green badge would be misleading, but exposing ten specialist screens and raw evidence to every operator would be unusable and risky. The interface should provide a plain-language outcome, scope, expiry/blocker and escalation owner, while restricting evidence and decision detail to authorized reviewers. Purchasing and receiving must not be treated as interchangeable.

## SME — first-principles analysis

Supplier assurance is a chain of distinct propositions, each with its own evidence, authority and time validity:

- Who is the legal counterparty?
- Which activities/sites/product classes require a licence, and which authority governs that requirement?
- Does the evidence establish the correct holder, scope and current validity?
- Which due-diligence checks are required for this supplier and risk class?
- Who is competent and authorized to perform each check and make each decision?
- What exact scope and period does the decision cover?
- What downstream action is permitted, by whom, and under which policy?

These propositions cannot safely collapse into one status. Evidence must be versioned and provenance-preserving. Applicability must precede licence verification. Due-diligence templates must be versioned so historical decisions remain interpretable. Expiry, adverse findings, scope changes and revocation need explicit re-review triggers. A numerical risk score is not a neutral technical detail; it embeds policy and should not be invented.

## Architect — revision and responses

The initial single-status proposal is withdrawn. The revised design separates:

1. Supplier/legal identity and versioned declarations.
2. Evidence provenance and verification cases/attempts.
3. Qualified licence applicability determinations.
4. Versioned due-diligence templates and execution records.
5. Reviewer identity, verified qualification evidence and scoped, time-bounded authority grants.
6. Append-only qualification decisions and a derived current-state projection.
7. Independent purchasing and receiving eligibility evaluations.
8. Department channels versus any separately approved named-contact data.

The UI will give operational users a simple outcome and blocker explanation; reviewer evidence and decision tools remain permission-scoped. Eligibility is deny-by-default and remains disconnected from PO/receiving until a separate gate. No risk score, legal rule, state transition or scope dimension is fixed by this proposal.

## Retesting

- **Devil's Advocate:** the revised separation addresses the single-status and self-approval flaws, but residual risk remains if an eligibility read uses stale projections, if an expired authority grant is cached, or if evidence is changed without invalidating a decision. Require transactionally maintained projections, re-evaluation at action time, grant validity checks and explicit invalidation/re-review triggers.
- **Clueless Client:** the revised approach can present a single actionable answer without exposing all reviewer complexity. Require plain-language reason codes, clear next owner/action, visible expiry and a path to request review. Validate with actual procurement and receiving staff before acceptance.
- **SME:** the revised model respects evidence provenance and scope, but implementation cannot start until the owner/professionals decide the legal-entity/licence applicability matrix, due-diligence criteria, authority model, decision lifecycle and eligibility dimensions. No Egyptian law or EDA document has been newly interpreted in this design pass.

## Maestro — final technical determination

**Recommend the revised, staged, fail-closed architecture in** [the INV-B supplier operational expansion technical design](../delivery/invb-supplier-operational-expansion-design.md).

Accepted criticisms: do not use one global supplier status; do not equate evidence presence with verification; do not infer reviewer authority from authentication; do not collect named contacts without privacy approval; do not make purchasing and receiving eligibility the same flag.

Rejected alternative: a single approval workflow with a Verified/Approved flag and a generic reviewer role. It is simpler but cannot represent legal, site, activity, product and time scope or enforce separation of duties safely.

Residual risks and dependencies: Q51 and INV-OWN-002 remain open; INV-SEC-001 remains pending; applicable Egyptian legal/regulatory, pharmacist, quality and procurement decisions are unavailable; live database/runtime and CI acceptance remain unverified; the exact owner-approved eligibility scope is unknown.

**Technical disposition:** design may be submitted for human review. No application implementation, schema migration, named-contact collection, verification call, qualification decision, PO/receipt integration, production migration or release is authorized by this deliberation. Maestro's determination is not owner, legal, regulatory, pharmacy, quality or security approval.
