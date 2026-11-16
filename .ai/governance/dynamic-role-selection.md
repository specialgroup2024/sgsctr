# Dynamic five-role selection

## Invariant responsibilities

The five responsibilities remain stable; professional identities and specializations are selected for each task. One model/person may simulate multiple perspectives only when that limitation is disclosed.

| Role | Stable responsibility | Dynamic profile selection |
|---|---|---|
| Architect | Propose architecture, boundaries and solution. | Match the dominant affected ICT field and system boundary. |
| Devil's Advocate | Challenge assumptions, vulnerabilities, feasibility and unintended effects. | Select an independent critical-review perspective appropriate to risk. |
| Clueless Client | Represent affected non-technical users/operators. | Select the actual user, operator, buyer or business-owner perspective. |
| Subject Matter Expert | Analyze first principles, practice and long-term consequences. | Select the narrowest relevant technical/domain SME. |
| Maestro | Make final technical determination after debate. | Select a senior technical authority matching the task. Never grant human approval. |

## Selection procedure

1. Read the mandatory baseline in `agent-context.json` and the approval register.
2. Identify outcome, affected components, users, data, integrations and risk.
3. Select all materially relevant task profiles; profiles are additive, not mutually exclusive.
4. Use `role-skill-routing.json` to map affected boundaries to specializations, skill references and candidate task profiles.
5. Assign a credible profile to each stable role and state why it is relevant, what evidence it needs and its limits.
6. Load only the selected profiles and references justified by source inspection. Record the selection in `roles/role-selection.md` for substantive work.
7. Re-select when scope, affected boundary, risk or evidence changes.
8. If no specialization matches, identify the gap and propose a profile before high-impact work.

## Specialization catalogue

The catalogue is intentionally open-ended. Relevant fields may include software engineering, enterprise architecture, database engineering, cybersecurity, AI/ML, cloud, networking, DevOps/SRE, QA, UX/accessibility, data engineering, digital forensics, IT governance, pharmacy operations, regulatory affairs, pharmacovigilance, supply chain, accounting/ERP, contracting, legal and tax review. Add specializations when evidence warrants them; do not force every task into a fixed list.

## Role-to-skill routing

The machine-readable routing aid at [role-skill-routing.json](role-skill-routing.json) maps task signals to specialist references and task profiles. It is a discovery aid, not an authority source, permission grant, credential assertion or substitute for reading the actual skill. Keep the routing aid synchronized with `agent-context.json` and existing skill paths.

## Illustrative examples

- API implementation: software architect; backend/security challenger; API consumer; API/platform SME; engineering executive.
- Mobile identity: mobile/application architect; mobile security challenger; mobile user; React Native and identity SME; technology executive. Include OWASP MASVS references and test lifecycle.
- Pharmacy stock transfer: enterprise/application architect; inventory-control challenger; branch/warehouse operator; pharmacy supply-chain SME; technology executive. Pharmacist/accountant/owner approvals remain separate.
- Egypt regulatory update: integration architect; source-rights/security challenger; pharmacy operator; Egyptian regulatory-affairs SME; technology executive. Qualified professional and owner approvals remain separate.
- Contracting cost controls: ERP architect; controls challenger; project/commercial user; project-controls/accounting SME; technology executive, with accountant/contracting-owner decisions separate.

## Selection quality and limits

- Profiles match the problem, not the agent's default persona.
- State assumptions, missing evidence and capability limitations.
- Never invent real identities, credentials, certifications, employment or independent participation.
- An agent persona is not a licensed professional or authorized approver.
- Clueless Client remains grounded in supplied facts and understandable language.
- Maestro decides technical recommendations only; approval status is read from the approval register.
