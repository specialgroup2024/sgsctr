# Current state

Last reviewed: 2026-11-07.
Status: Phase 0 discovery; no business features implemented.

## Confirmed from repository
- Product covers specialist contracting and a pharmacy group.
- Contracting and pharmacy require separate accounting systems and reports.
- Pharmacy inventory costing is specified as weighted average; its detailed method is not approved.
- Payer agreements may define different coverage, discount and patient-payment arrangements.
- Intended stack: ASP.NET Core, PostgreSQL and React Native.

## Accounting boundary resolution
- Treat contracting and pharmacy as separate operating/accounting domains, not as proof that there are exactly two registered legal entities.
- Each verified legal entity must maintain its own books and accounting controls.
- Branches within one legal entity are dimensions/cost centres unless evidence shows separate incorporation.
- A pharmacy group may contain one or multiple legal entities; branch ownership is not yet evidenced.
- A parent/holding company is not established by the available repository material.
- Preferred database direction is one PostgreSQL database per confirmed legal entity, not per branch. Final provisioning waits for the legal-entity register.
- Intercompany activity must be real, documented, approved and reconciled. No presumed consolidation.

## Evidence limitation
The four files in mam/ai-chat are architecture and agent-guidance drafts. They recommend separate books for contracting and pharmacy but do not identify registered legal names, legal forms, registration/tax identifiers, ownership, or branch-to-entity mapping. They are not legal or accounting evidence.

## Repository evidence
- Root: AGENT.md, AGENTS.md and minimal README.md.
- .ai contains product, domain, architecture, decision, delivery, governance and memory documents.
- No application source, database migrations or mobile app implementation were found in the inspected default-branch tree.

## Current discovery outputs
- Phase 0 plan and scenario test outlines are drafts.
- System context and ADR-0001 are proposals; ADR-0001 now records the domain-level accounting boundary and the evidence required to finalize legal-entity topology.
- Legal-entity register is a working template, not a verified register.
- Open questions Q01-Q03 capture the exact remaining owner evidence.

## Next milestone
Obtain the registered entity documents and a branch/site ownership schedule; have the business owner, accountant and qualified Egyptian legal/tax adviser verify them. Then approve the entity-to-books map and finalize database provisioning. Do not implement production financial calculations or business features before the relevant approvals.
