# Curated project facts

This file records stable context, not a full implementation inventory. Check current-state.md and repository source before relying on implementation status.

## Owner-provided business facts
- The owner identifies Special Group with two sectors: Pharmacies and Specialized Contracting. Exact registered legal identity and whether both sectors share one legal person remain unverified.
- Pharmacy locations identified by the owner: Mokattam main warehouse; Student Hospital, Qasr El-Aini Hospital and Manial Hospital branches.
- The owner says locations are administratively connected but separately accountable, and direct branch-to-branch transfers are required capabilities. Detailed workflow and accounting treatment remain approval-gated.
- Pharmacy product scope includes regular medicines, chemotherapy drugs, medical supplies and cosmetics. Product-family classification and handling requirements require qualified review.

## Technology direction and repository baseline
- Backend direction: ASP.NET Core / C# with PostgreSQL and EF Core/Npgsql.
- Current web foundation is Next.js; React Native is the mobile direction, but no mobile client is evidenced in current-state.md.
- Exact configured versions are recorded in architecture/system-context.md and must be checked there before dependency changes.
- Current architectural direction is a modular monolith with explicit module and sector boundaries. Legal-entity structure and statutory accounting treatment remain provisional pending documentary and accountant review.

## Business-rule guardrails
- Keep pharmacy and contracting operational controls and management reporting distinct.
- Distinguish payer discount, payer coverage, patient copay/exemption, claim approval, remittance and later collection.
- Weighted-average pharmacy costing is a stated business requirement, but moving-average timing, cost pool, return basis, transfer valuation, precision and posting are not approved until accountant/pharmacy review.
- Do not infer universal payer percentages, calculation order, tax treatment or clinical/dispensing rules from examples.

## Governance facts
- AGENT.md and AGENTS.md bootstrap a dynamic five-role method; role responsibilities stay stable while ICT/business specializations are selected per task.
- .ai/memory is curated memory with evidence/status discipline, not a transcript.
- Every Markdown file must remain below 200 lines; CI enforcement is configured. Verify the check rather than assuming it passed.
- Legal, pharmacy, accounting, tax, security-risk and production approvals remain with designated humans/qualified professionals.

## Entry status
The facts above are owner-provided or repository-governance facts, not independent legal verification. Record changing details in current-state.md/open-questions.md with evidence, owner and review date.
