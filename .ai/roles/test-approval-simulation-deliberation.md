# Approval workflow simulator — dynamic five-role deliberation

- Date: 2026-11-15.
- Task: design a safe test-only simulator for approval workflow paths in SGSCTR.
- Repository baseline: master; source files and approval/test-readiness endpoints inspected.
- Risk: high if simulation can be mistaken for real approval; low operational impact only if the proposed isolation invariants hold.
- Limitation: all five perspectives below are simulated analytical roles in one assistant, not independent agents or qualified human reviews.

## Dynamic specialist selection

| Stable role | Selected profile | Why relevant |
|---|---|---|
| Architect | Full-stack .NET/Next.js test-harness architect | Defines route boundary, state model and integration separation |
| Devil's Advocate | Application-security / abuse-case reviewer | Challenges feature-flag bypass, impersonation and accidental production writes |
| Clueless Client | Pharmacy procurement/warehouse operator | Tests whether staff can mistake a simulation for real authority |
| Subject Matter Expert | QA automation and workflow-state modelling specialist | Defines deterministic scenarios and negative acceptance tests |
| Maestro | Senior enterprise platform architect | Resolves technical trade-offs after challenge and retesting |

## Architect — initial proposal

Create a Development-only Approval Workflow Simulator, separate from Approvals and Test Readiness. It uses synthetic scenarios and actors, supports simulated approval/rejection/conditional/delegation/emergency/pending/expiry paths, and keeps state in browser memory. It must not write to the approval database or call operational APIs.

## Devil's Advocate — critical challenge

A UI-only toggle is not a security boundary. A hidden route or disabled button could still be reached directly, and a production build may contain the component. A user could also screenshot or copy a simulated decision and present it as genuine evidence. Persisting simulation rows beside real approvals risks future reporting or query code accidentally treating them as authoritative.

**Required revision:** server-side route gate requiring both an explicit opt-in flag and Development environment; fail closed. No API endpoint, database table, persistent browser storage, export or real audit event. Use distinct `Simulated*` state values and a persistent warning. Automated negative tests must assert the route is unavailable outside Development and no operational endpoint is called.

## Clueless Client — independent practical challenge

A procurement clerk or receiver may see the word “Approved” and assume they can proceed, especially if the simulator is placed beside the real Approvals tab. A generic test actor may also look like a real staff account.

**Required revision:** give the simulator its own clearly named test-only entry; put **SIMULATION ONLY — NOT A REAL APPROVAL** on every screen and result; use synthetic IDs rather than names/job titles/licence numbers; show a clear explanation that no order, receipt, stock or payment can proceed from a simulated result.

## SME — first-principles analysis

A simulator is useful only if it tests observable states and transitions without asserting unapproved business policy. The repository has no approved general approval matrix, role catalogue, approval limits, expiry rules or delegation/emergency SOP. Therefore the first increment must test generic software paths only. It must not invent threshold logic, reviewer qualifications, mandatory evidence, escalation timing or authority hierarchy. In-memory state is adequate for usability and transition tests; actual execution evidence belongs in the existing append-only test-readiness records, not in the simulated decision itself.

## Architect — revision and retest

The revised design uses deterministic source-defined scenarios, synthetic actor IDs and component-local memory. It adds no database schema, EF migration, API endpoint, user/role, evidence upload or downstream integration. The route is server-gated by Development environment and an explicit opt-in flag defaulting false. Every result uses a `Simulated*` value and a persistent warning. Test cases assert no call to approval, supplier, purchasing, receiving, inventory or finance APIs and verify the real approval response remains unchanged.

**Devil's Advocate retest:** accepted subject to implementation tests proving the server gate cannot be bypassed and the simulator cannot reach operational command handlers. Residual risk remains that screenshots may be misrepresented outside the app; the watermark and explicit non-evidence wording reduce but cannot eliminate that human risk.

**Clueless Client retest:** the separate navigation item, repeated warning, synthetic actor IDs and explicit “no business action” statement make the distinction understandable. Keep the real Approvals tab unchanged.

**SME retest:** the design avoids business-rule invention and avoids a second persisted approval-like data model. No further technical objection within the stated scope.

## Maestro — final technical determination

**Recommend the Development-only, in-memory simulator design. Do not implement fake approval rows or any production decision endpoint.** The architecture is proportionate and avoids repeating the historical `DemoApproved` defect.

Accepted criticisms: client-only gating is insufficient; placing simulator outcomes beside the real approval register is unsafe; generic workflow examples must not become policy. The revised design addresses these with a server-side gate, separate route, synthetic state namespace and no persistence/integrations.

Rejected alternatives: database-backed simulated approvals, fake users/credentials, client-only visibility checks, and any simulation that can authorize a business command.

Residual risks: users can misrepresent screenshots; a future implementation could accidentally add network calls or expose the route in another environment. Mitigate with repeated labels, code review, negative route tests and API-call spies.

**Approval boundary:** the owner authorized discovery/design only in this work package. Owner confirmation of this technical design and a security review are required before application code is changed. No pharmacist, regulatory, accountant or quality sign-off is needed for generic non-operative scenarios; obtain those reviews if the simulator begins encoding domain-specific rules. Production release is not authorized.
