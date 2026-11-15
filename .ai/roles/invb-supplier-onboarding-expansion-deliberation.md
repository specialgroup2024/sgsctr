# INV-B supplier onboarding expansion — dynamic deliberation

- Date: 2026-11-15.
- Base: master after owner-merged PR #63 and PR #64.
- Task: expand the supplier register toward identity/licence verification, due diligence, contacts, qualification decisions and purchasing/receiving eligibility.
- Risk: high — legal/regulatory evidence, supplier personal data, privileged decisions and downstream procurement/receipt controls.
- Limitation: perspectives are simulated analytical roles, not independent agents or qualified Egyptian professionals.

| Stable role | Dynamically selected profile | Contribution |
|---|---|---|
| Architect | .NET/PostgreSQL supplier-onboarding and workflow architect | Separate supplier-declared identity, evidence, due-diligence case, reviewer assignment, decision record and downstream eligibility; use explicit state constraints and audit transactions. |
| Devil's Advocate | Egyptian regulatory-compliance and application-security challenger | Reject a generic licence checklist, automatic verification from URLs/expiry dates, unqualified reviewers, self-approval, unrestricted contact PII and accidental downstream eligibility. |
| Clueless Client | Pharmacy procurement clerk / warehouse receiver | Ensure Draft, Unverified and Pending are unmistakable; prevent staff selecting an unqualified supplier or mistaking a saved document reference for a checked licence. |
| SME | Pharmaceutical procurement, supplier-quality and privacy engineering analyst | Test legal-entity versus trading-name identity, supplier category/site applicability, due diligence provenance, reviewer competence, renewal, adverse findings, data minimization and retention. |
| Maestro | Senior enterprise architecture and technology-risk authority | Determine the safe implementation boundary; cannot approve Egyptian legal interpretation, pharmacy policy, privacy risk or owner procurement rules. |

## Deliberation

**Architect proposal:** add supplier identity claims, licence evidence, due-diligence cases, contacts, reviewer assignments, decision history and eligibility integration as separate aggregates. Preserve source provenance and transactional audit. Make eligibility a derived, scope-bound result rather than a manually editable supplier flag.

**Devil's Advocate challenge:** this design is unsafe if implemented before its policy inputs exist. A generic licence field could imply a licence is required or sufficient for every supplier type. A user-uploaded URL is not verification. A generic Approved state could authorize purchases across sites/products beyond the reviewer's remit. Named contacts introduce personal data and retention obligations. A reviewer role name does not prove a person is qualified.

**Clueless Client challenge:** staff need one clear answer to “Can I buy from this supplier for this site and product?” If the screen says Approved without scope, expiry and authority, staff may buy from a supplier whose licence is expired or whose approval applies to a different activity. A pending review must not look green or selectable.

**SME analysis:** distinguish legal entity, trading name, branch/site, licence holder and actual operator. Preserve original evidence and verification method. Due-diligence criteria must be approved for the supplier classes and Egyptian legal context. Reviewer qualification and delegated authority must be evidenced. Contact data needs purpose limitation, minimum collection, access and retention. Qualification and eligibility require explicit criteria, scope, effective dates, suspension/expiry and exception controls.

**Architect revision:** separate non-operative capture from decisions. The current safe proposal stores only owner-provided claims and Unverified evidence; due-diligence cases remain Pending. Do not store named contact PII until privacy controls are approved. Do not expose qualification decisions, reviewer grants or purchasing/receiving eligibility until Q51, INV-OWN-002, INV-SEC-001 and relevant professional approvals are recorded.

**Retesting questions:** prove that Draft/Unverified/Pending cannot be used by PO or receipt endpoints; no UI can imply verification; no user can self-approve; licence expiry and evidence updates trigger review only after approved rules exist; contacts are access-controlled and retained only under approved policy.

## Maestro determination

The existing supplier register may be extended with non-operative, unverified data intake after the owner confirms the data fields and contact-data boundary. The full requested capability cannot safely be implemented as operational verification/qualification/eligibility until the missing business and professional decisions are supplied. This is a technical determination, not an approval or a refusal to continue the project.

## Approval boundary

- INV-OWN-001: approved for staged development, subject to gates.
- INV-OWN-002 / Q51: pending; supplier policy, criteria, reviewer authority and eligibility rules not approved.
- INV-REG-001: pending; supplier-specific legal/licensing applicability requires qualified Egyptian review.
- INV-SEC-001: pending; privacy, access, audit and residual-risk acceptance required.
- INV-PRO-001 / INV-QLT-001: pending where pharmacy/quality supplier controls apply.
- No supplier qualification, licence verification, purchasing eligibility, receipt linkage, supplier transmission, stock posting or production deployment is authorized by this deliberation.
