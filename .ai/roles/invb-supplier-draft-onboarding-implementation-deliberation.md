# INV-B draft onboarding intake — implementation deliberation

- Date: 2026-11-15.
- Status: technical implementation proposal within owner-approved non-operative scope.
- Profiles are simulated analytical perspectives, not independent agents or qualified professionals.

## Dynamic profile selection

| Stable role | Selected profile | Relevance and limit |
|---|---|---|
| Architect | ASP.NET Core / EF Core / PostgreSQL application architect | Designs constrained draft records, API, migration and BFF/UI; cannot approve legal fields or operating policy. |
| Devil's Advocate | Application-security and privacy engineer | Challenges personal-data leakage, false verification, state escalation and downstream supplier use; cannot certify privacy compliance. |
| Clueless Client | Pharmacy procurement / warehouse clerk perspective | Checks that staff can capture declarations without mistaking them for verified or approved suppliers. |
| SME | Pharmaceutical supply-chain data-controls analyst | Tests provenance, due-diligence intake and separation between evidence capture and qualification; not an Egyptian legal or pharmacy professional. |
| Maestro | Senior enterprise software architect | Determines technical containment after challenge; cannot grant professional or production approval. |

## Deliberation

**Architect proposal:** add typed supplier-declared identity/licence claims, department-level business channels and pending due-diligence intake cases. Persist them with actor, time, reason and audit events. Expose through authenticated API, same-origin BFF and the supplier workspace.

**Devil's Advocate challenge:** generic text could be mistaken for verified legal data; arbitrary contact fields could collect personal data; a due-diligence case could be interpreted as a completed check; a new endpoint might accidentally enable qualification or purchasing. Database constraints must fix provenance/status and channel/declaration types. Do not add decision endpoints or downstream supplier relationships.

**Clueless Client challenge:** users need clear labels explaining that information came from the supplier and has not been checked. Business contacts must be labelled by department and must not ask for a person's name. A pending case must not imply a completed check.

**SME analysis:** capture provenance, actor, time and change reason. Keep legal/licence values as supplier declarations only. Do not invent legal criteria, evidence validity checks, risk tiers, checklists, reviewer credentials, decision states or re-review intervals. Use department mailbox, business phone/switchboard and company website channels only.

**Architect revision:** constrain declarations to an explicit list of identity/licence metadata keys, OwnerProvided provenance and Unverified review status. Constrain contacts to department-labelled business channel types. Constrain due-diligence cases to Pending. Keep API writes Administrator-only under the existing policy, audit each write in the same database save, and do not connect suppliers to PO/receipt eligibility.

**Retesting / residual risks:** source inspection confirms the intended endpoint and database constraints are present. Automated build, migration, PostgreSQL, authorization, BFF and browser checks have not yet run. A free-text business phone can still be entered incorrectly as a personal number; the UI explicitly prohibits personal details, but privacy/security review is still required. No professional review or legal verification is simulated.

## Maestro determination

Proceed with this narrow intake implementation as approved by the owner. Keep all submitted values unverified, due-diligence cases pending, and business contacts limited to department channels. Do not implement qualification decisions, reviewer-role grants, verification, personal contact data, purchasing/receiving eligibility or production migration. Technical acceptance remains pending until the full CI and integration matrix executes successfully.
