# Dynamic specialist selection and adaptation

## Architectural invariant

Keep the five deliberation responsibilities stable; dynamically select the ICT and business specialization that each responsibility uses for the actual task. The catalogue is open-ended, not a fixed team chart. Profiles are competency lenses, not permanent assignments.

An agent's specialization, responsibility, depth, sequence and collaboration pattern must adapt when the task's affected boundary, evidence, risk, dependencies, lifecycle stage or acceptance criteria change. Do not force every task through the same expert roster or simulate a specialist merely to fill a role.

Profiles describe methods and knowledge areas. They do not establish that an agent is a human professional, holds a certification, has performed independent review or can provide legally regulated sign-off. Qualified human and owner approvals remain separate gates.

## Five stable responsibilities, task-selected profiles

| Responsibility | Stable purpose | Select its profile according to |
|---|---|---|
| Architect | Propose system boundaries, architecture and delivery approach. | Dominant affected ICT field, business process and system boundary. |
| Devil's Advocate | Challenge assumptions, failure modes, vulnerabilities and unintended effects. | Risk, failure mode and assurance discipline requiring independent challenge. |
| Clueless Client | Test practical value, usability and operational fit. | Actual affected operator, customer, branch, finance, administrator or business owner. |
| Subject Matter Expert | Test first principles, domain practice, standards and long-term consequences. | Narrowest relevant ICT or business-domain specialty; add qualified sources where needed. |
| Maestro | Synthesize findings and make the final technical determination. | Senior technical perspective matching the dominant field; never a human approval authority. |

One agent/model may perform multiple perspectives when resources are limited, but must disclose that the review is simulated and not independent. For material/high-risk work, seek a fresh-context reviewer or qualified human where available. Do not invent identities, credentials, certifications, employment or participation.

## Open-ended competency catalogue

Select and combine only the competencies material to the task. Extend this catalogue when evidence reveals a reusable gap; do not constrain work to these examples.

| Competency family | Example specializations | Engage when |
|---|---|---|
| Product, business and systems analysis | Product analysis, business analysis, requirements engineering, process modelling, domain analysis | Goals, actors, workflows, policies or acceptance criteria are unclear. |
| Enterprise and solution architecture | Enterprise, solution, application, integration and data architecture | Boundaries, cross-cutting design, technology choices or material trade-offs are involved. |
| Software engineering | ASP.NET Core/C#, API/backend, Next.js/React/TypeScript, React Native/mobile, distributed systems | Application or service implementation is affected. |
| Data and persistence | PostgreSQL, EF Core, data modelling, data quality, analytics, migration | Schema, transactions, performance, reporting or data movement is affected. |
| Security and trust | Cybersecurity, AppSec, threat modelling, IAM/RBAC, privacy engineering, secure design | Identity, permissions, sensitive data, attack surface or security controls are affected. |
| Quality and verification | QA, test architecture, automation, performance, reliability, acceptance testing | A test strategy, defect, regression, quality gate or release claim is involved. |
| User experience | UI/UX, accessibility, usability, Arabic/English localization, RTL | User-facing workflows, forms, dashboards or accessibility are affected. |
| Platform and operations | DevOps, DevSecOps, Docker, cloud/platform, SRE, systems administration, networking, observability, backup/DR | Build, deployment, infrastructure, availability or operations are affected. |
| Integration and edge systems | API/event integration, legacy systems, messaging, barcode, printing and devices | External systems, asynchronous processing or peripherals are involved. |
| Pharmacy and regulated operations | Pharmacy operations, licensed pharmacist review, pharmacovigilance, quality, EDA/regulatory affairs, pharmaceutical supply chain | Pharmacy workflows, medicines, medical supplies, claims or regulatory sources are involved. |
| Contracting and project delivery | Contract administration, procurement, project controls, quantity surveying, cost engineering, commercial management | Contracts, projects, variations, valuations, progress or supplier processes are involved. |
| Finance, legal and assurance | Accounting/ERP, financial controls, Egyptian tax, legal/privacy, audit and compliance | Posting, costing, tax, legal interpretation, statutory controls or assurance is involved. |
| AI and information governance | AI/ML, agent orchestration, context engineering, data governance, IT governance | Agent behavior, model integration, knowledge, policy or governance tooling is affected. |

## Selection and adaptation procedure

1. **Frame the task:** objective, deliverable, affected components, users, business domain, data, integrations, lifecycle stage, risk and acceptance criteria.
2. **Identify outcomes:** discovery, design, implementation, challenge, verification, operational readiness or approval evidence.
3. **Map boundaries:** use `role-skill-routing.json` to discover specializations, task profiles and candidate references. Inspect source files; routing is a discovery aid, not authority or proof of capability.
4. **Choose the smallest sufficient set:** select a lead perspective and only the ICT/business specialists needed to cover material risks and acceptance criteria. Task profiles are additive when boundaries cross.
5. **Make each selection actionable:** state its task-specific question, scope, files/evidence to inspect, expected output, limits and handoff. Do not assign generic work to fill a role.
6. **Load progressively:** load the mandatory baseline, selected profiles and only the linked skills/references justified by the inspected source. Do not load every role or skill by default.
7. **Adapt during work:** add, combine, narrow, sequence or replace perspectives when findings, defects, scope, technology, dependencies or risk change. Reassess at plan review, material discovery, implementation-to-release transition and before release.
8. **Close the loop:** record findings, evidence, disposition, unresolved objections, missing competencies and approvals still required. An unavailable essential competency is a disclosed blocker, not assumed sign-off.

Parallel work is optional. Delegate only with a self-contained brief, non-overlapping file ownership, explicit checks and evidence format; the coordinating agent must re-verify delegated work.

## Illustrative task compositions

| Task | Candidate perspectives to adapt |
|---|---|
| Requirements discovery | Business/systems analyst, affected branch or user advocate, relevant pharmacy/contracting SME, QA. |
| ASP.NET API feature | .NET/API architect, backend engineer, API consumer, security challenger, QA. |
| PostgreSQL migration | Database engineer, EF Core/backend engineer, data-integrity reviewer, security, QA, affected data owner. |
| Authentication defect | IAM/security, ASP.NET backend, web/mobile client as affected, user advocate, QA/privacy as relevant. |
| LAN/Docker outage | Systems administrator, networking, Docker/platform, API/web operations, security, QA. |
| Pharmacy inventory or transfer | Pharmacy operations, supply chain, database/backend, accounting-controls reviewer, branch/warehouse operator, QA; pharmacist/accounting/owner approval where applicable. |
| EDA regulatory ingestion | Integration/platform, source-rights/security, Egyptian regulatory-affairs and pharmacy perspectives, data quality, qualified human reviewer. |
| Contract cost control | Contract/project-controls, commercial user, accounting/ERP, backend/data, QA; contracting and finance owners for policy decisions. |
| Production release/recovery | Release/DevOps, SRE/systems administration, security, QA, database/backup and service owner as applicable. |

Examples are not mandatory combinations. Actual scope, source evidence and risk determine the final composition.

## Review coverage and completion evidence

| Change type | Minimum relevant coverage |
|---|---|
| New workflow/specification | Systems analysis, affected domain/user, QA; security and UX where relevant. |
| Schema, migration or ledger | Database, backend, data integrity, security and QA; finance/domain owner for business semantics. |
| API or external integration | API/integration, backend, security, QA and consumer perspective. |
| UI/mobile change | UX, frontend/mobile, accessibility/localization and QA. |
| Infrastructure/CI/network | Platform/DevOps, networking or systems administration as relevant, security, operations and QA. |
| Identity/permissions | IAM/security, backend, affected client, QA and privacy where relevant. |
| Release/restore | QA, security, operations/SRE, platform and database/backup as applicable. |

Each substantive specialist lens must report:
- **Scope:** reviewed and explicitly excluded areas.
- **Evidence:** repository paths/lines, reproducible commands, test results or authoritative references.
- **Findings:** severity, impact, likelihood where meaningful and concrete remediation.
- **Handoff:** decisions, dependencies, controls, tests and residual risks.
- **Disposition:** accepted, fixed, deferred with owner approval, or unresolved blocker.

A task is not complete merely because roles were named or files edited. Do not claim a review/sign-off that was not performed. Do not convert a technical recommendation, passing test or Maestro synthesis into business, legal, regulatory, accounting, professional, security-risk or release approval. Record owner/qualified-professional approvals only in the approval register with their actual evidence and scope.

For material decisions, use [deliberation protocol](deliberation-protocol.md); for substantive work, record the actual selection in [role-selection template](../roles/role-selection.md).
