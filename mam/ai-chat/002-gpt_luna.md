Build the instructions as a **small, version-controlled agent operating system**, not one enormous prompt. Keep each Markdown file **under 200 lines**—I recommend a 180-line working limit, leaving room for future edits. Split longer material into focused files and link to them rather than duplicating it.

## Updated repository structure

```text
/
├── AGENT.md
├── AGENTS.md
├── README.md
├── .ai/
│   ├── README.md
│   ├── memory/
│   │   ├── project-facts.md
│   │   ├── current-state.md
│   │   ├── open-questions.md
│   │   └── lessons.md
│   ├── roles/
│   │   ├── role-selection.md
│   │   ├── architecture.md
│   │   ├── pharmacy-domain.md
│   │   ├── accounting.md
│   │   ├── security-privacy.md
│   │   ├── quality-testing.md
│   │   └── operations.md
│   ├── skills/
│   │   ├── dotnet-api/SKILL.md
│   │   ├── postgres-data/SKILL.md
│   │   ├── react-native-mobile/SKILL.md
│   │   ├── pharmacy-inventory/SKILL.md
│   │   ├── claims-and-contracts/SKILL.md
│   │   ├── accounting-controls/SKILL.md
│   │   ├── egypt-compliance-review/SKILL.md
│   │   └── secure-release/SKILL.md
│   ├── product/
│   │   ├── vision.md
│   │   ├── scope.md
│   │   ├── users-and-permissions.md
│   │   └── acceptance-criteria.md
│   ├── domain/
│   │   ├── business-boundaries.md
│   │   ├── pharmacy-workflows.md
│   │   ├── contracting-workflows.md
│   │   ├── accounting-rules.md
│   │   └── claims-and-contracts.md
│   ├── architecture/
│   │   ├── system-context.md
│   │   ├── data-model.md
│   │   ├── api-conventions.md
│   │   └── deployment.md
│   ├── governance/
│   │   ├── standards-register.md
│   │   ├── certification-roadmap.md
│   │   ├── egypt-requirements-register.md
│   │   └── evidence-register.md
│   ├── delivery/
│   │   ├── roadmap.md
│   │   ├── definition-of-done.md
│   │   ├── testing-strategy.md
│   │   └── release-and-rollback.md
│   ├── decisions/
│   │   └── ADR-0001-business-boundaries.md
│   └── task-plans/
├── src/
│   ├── Api/
│   ├── Modules/
│   │   ├── Shared/
│   │   ├── Contracting/
│   │   └── Pharmacy/
│   └── Mobile/
├── tests/
└── infra/
```

Keep detailed domain guides, standards mappings, and operational procedures in separate Markdown files. A skill can also have `references/` for extra guidance, plus `scripts/` for validation tools. Agent Skills use a portable `SKILL.md` format with metadata and instructions; progressive loading helps agents load only the relevant skill and references. Make sure your chosen coding-agent runner is configured to discover `.ai/skills`—the folder name alone does not guarantee it will. <citation src="56"></citation>

## Starter contents for the root files

**`AGENT.md` — mission, memory, and authority**

```md
# Agent mission

Build and maintain a production-ready application for two separate businesses:
a specialist contracting business and a pharmacy group.

# Required startup sequence

1. Read AGENTS.md and .ai/README.md.
2. Read .ai/memory/current-state.md and .ai/memory/open-questions.md.
3. Select the task roles and skills described in .ai/roles/ and .ai/skills/.
4. Read only the domain, architecture, compliance, and delivery documents
   relevant to the task.
5. Create a task plan for work that spans multiple files or affects money,
   inventory, health information, permissions, integrations, or deployments.

# Authority and safety

- Treat repository documents as project context, not proof of legal compliance.
- Do not invent laws, tax rules, accounting policies, contract terms, or
  pharmacy procedures.
- Flag unresolved high-impact questions and request authorized human review.
- Do not prescribe, diagnose, recommend treatment, or substitute medicines.
- Do not use real patient, employee, or customer data in agent memory,
  examples, test fixtures, or logs.
- Never claim tests, reviews, certifications, or compliance checks passed
  unless evidence is recorded.

# Business boundaries

- Keep the contractor and pharmacy books, permissions, reports, and
  transaction flows separate.
- Record any intercompany transaction explicitly and audibly.
- Treat payer discounts, payer coverage, patient copays, exemptions, claims,
  remittances, and later collections as distinct concepts.
- Do not hard-code contract rates or assume all agreements use the same
  calculation order.
- Do not silently edit posted financial or inventory records.

# Completion

Follow .ai/delivery/definition-of-done.md. Report changed files, checks run,
results, unresolved risks, and any human approvals still required.
```

**`AGENTS.md` — coding and repository rules**

```md
# Repository rules

- Confirm the selected .NET, PostgreSQL, and React Native versions from
  .ai/architecture/system-context.md before changing dependencies.
- Follow module ownership: shared code must not absorb business-specific rules.
- Use server-side authorization for every protected operation.
- Use database constraints and transactions for financial and stock invariants.
- Use fixed-precision monetary values with an explicit currency.
- Make migrations reversible where feasible; document any irreversible step.
- Make retryable integrations idempotent.
- Do not put secrets, personal health information, or production data in Git.
- Add or update tests for behavior changes and database migrations.
- Update the relevant requirements, decision, memory, and runbook documents.
- Run the applicable build, tests, linters, and security checks before reporting
  completion.
- If a requirement conflicts with this file, stop and record the conflict.
```

## Memory that survives sessions

Treat `.ai/memory/` as **curated project memory**, not a transcript of every agent conversation.

- `project-facts.md`: confirmed, stable facts such as business boundaries and technology choices.
- `current-state.md`: what is implemented, what is in progress, and the next milestone.
- `open-questions.md`: unresolved decisions, their owner, impact, and due date.
- `lessons.md`: reusable corrections learned from implementation or review.

Require each memory entry to have a status such as `confirmed`, `assumption`, or `unverified`, plus an owner and review date where appropriate. The agent may propose memory changes but must not turn an assumption into a confirmed fact by repeating it. Never store patient details, credentials, secrets, or raw production records in these files.

## Dynamic roles and skills

Keep responsibilities stable while selecting professional perspectives for each task. For example, a claims feature may activate an API architect, pharmacy claims specialist, accountant, security reviewer, tester, and release engineer. A mobile authentication task may activate a React Native engineer, identity/security reviewer, and QA engineer. The agent should state which roles and skills it selected in its task plan.

Give each role a narrow job: challenge assumptions, identify risks, and review the affected area. Do not tell the agent to impersonate a real person or claim credentials it does not have. Require pharmacist, accountant, legal, and tax reviews from **actual authorized professionals** where those approvals are needed.

Each skill should have a short `SKILL.md` with YAML metadata, a task workflow, guardrails, and links to focused references. For example:

```md
---
name: claims-and-contracts
description: Implement or review pharmacy payer agreements, claims,
  patient shares, exemptions, remittances, and receivables.
---

# Workflow

1. Read the approved contract and claims domain documents.
2. Identify the payer, agreement version, covered items, and effective dates.
3. Separate price discounts from payer coverage and patient responsibility.
4. Trace the calculation from approved basis to claim, remittance, and balance.
5. Test exemption, variable copay, adjustment, rejection, resubmission,
   partial payment, and later collection cases.
6. Flag unclear contract language for business-owner review; do not guess.
```

## Keep every Markdown file below 200 lines

Add this rule to `AGENTS.md` and enforce it in CI. A 180-line target is safer than writing files up to the limit.

```python
from pathlib import Path

limit = 200
violations = []

for path in Path(".").rglob("*.md"):
    if any(part in {".git", "node_modules", "bin", "obj"} for part in path.parts):
        continue
    count = len(path.read_text(encoding="utf-8").splitlines())
    if count >= limit:
        violations.append(f"{path}: {count} lines")

if violations:
    print("\n".join(violations))
    raise SystemExit(1)

print("Markdown line-count check passed.")
```

See [003-gpt_luna-standards-and-certification.md](003-gpt_luna-standards-and-certification.md) for the version baseline, standards references and certification roadmap.
