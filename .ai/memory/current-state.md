# Current state

Last reviewed: 2026-11-07.
Status: Phase 0 discovery; no business features implemented.

## Confirmed from repository
- Product covers specialist contracting and a pharmacy group.
- The two businesses require separate accounting systems and reports.
- Pharmacy inventory costing is specified as weighted average; its detailed method is not approved.
- Payer agreements may define different coverage, discount and patient-payment arrangements.
- Intended stack: ASP.NET Core, PostgreSQL and React Native.

## Repository evidence
- Root: AGENT.md, AGENTS.md and minimal README.md.
- .ai: product vision, business boundaries, accounting rules, claims concepts, current state, open questions and roadmap.
- Architecture, domain workflows, ADR and testing files were empty placeholders before Phase 0 documentation.
- No application source, database migrations or mobile app implementation were found in the inspected default-branch tree.
- mam/ai-chat contains two AI guidance drafts; these are reference material, not approved requirements.

## Current discovery outputs
- Phase 0 plan and scenario test outlines are drafts.
- System context and database-isolation ADR are proposals only.
- Contracting and pharmacy workflow documents are discovery drafts.
- Open questions remain unresolved pending named owners and evidence.

## Next milestone
Run workshops, collect approved source documents and anonymized worked examples, resolve entity topology and data isolation, then approve Phase 1 scope. Do not implement production financial calculations or business features before approvals.
