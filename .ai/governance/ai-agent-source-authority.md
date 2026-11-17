# AI Agent Source Authority and Documentation Restriction

## Status
Authoritative governance rule. Effective immediately.

## Authorized Sources Only

AI agents working on the SGSCTR repository may **only** read and follow these three sources:

| Source | Path | Purpose |
|---|---|---|
| Universal mission and boundaries | `AGENT.md` | Universal mission, safety, evidence, human approval boundaries, reserved human decisions |
| Repository execution mechanics | `AGENTS.md` | Repository discovery, implementation conventions, verification mechanics |
| AI project context and governance | `.ai/` | Minimum context loading, task profiles, governance, security, memory, architecture, product scope, roles, skills, delivery, evals |

**No other documentation, markdown file, or directory is an authorized source for AI agent behavior.**

## Prohibited Sources

The following are **prohibited** as AI agent instruction sources. They must not be read, followed, or cited as authority by any AI agent:

| Prohibited | Reason |
|---|---|
| `docs/` directory and all subdirectories | Archived historical material; not current project governance |
| Any `*.md` file at repository root other than `AGENT.md` and `AGENTS.md` | Not part of the authorized governance trio |
| Any `*.md` file outside `.ai/` other than `AGENT.md` and `AGENTS.md` | Not part of the authorized governance trio |
| Any `*.md` file inside `.ai/` not referenced by `.ai/agent-context.json` or `.ai/README.md` | Not part of the mandatory baseline or selected task profile |
| Host-specific instruction files that bootstrap to canonical sources | May bootstrap but must not fork or duplicate policy |

The `docs/` directory is retained only as archived navigation so existing external references remain valid. Its content is historical source material, not active project instruction. All docs/archive files state: "follow the current root `AGENT.md`, `AGENTS.md` and canonical `.ai/` governance instead."

## Consolidated AI Agent Working Rules (from archived docs)

The following rules from the archived `docs/archive/before-writing-code.md` series are consolidated here as binding AI agent behavior. They supplement, not replace, AGENT.md and AGENTS.md.

### R1 — Understand Before Coding
Analyze requirements, repository state, architecture, and approval gates before generating implementation code. Inspect existing files, callers, tests, migrations, and configuration before editing.

### R2 — Build Incrementally
Develop module by module. Do not generate large amounts of disconnected code without validation. One work item produces one independently verifiable outcome.

### R3 — Maintain Context
Keep track of generated files, classes, interfaces, database entities, dependencies, and implementation decisions. Record changes in current-state.md and change-log.md with date and provenance.

### R4 — Verify Every Implementation
After implementing a feature, run build, tests, EF parity, and governance checks before moving to dependent features. Never claim a check passed unless it was executed.

### R5 — Avoid Fake Implementations
Never claim a feature is complete when it is only a visual placeholder, draft, or sample implementation. Distinguish between implemented, tested, partially implemented, and unverified features.

### R6 — Use Current Best Practices
Follow current Microsoft .NET documentation and established engineering practices. Identify outdated patterns and replace them with modern alternatives. Use `decimal` for money, never floating point.

### R7 — Explain Important Decisions
Explain why a particular technology, design pattern, or implementation approach is being used. Record architectural decisions as ADRs when material.

### R8 — Handle Errors Correctly
Identify root cause, explain the issue, propose a correction, apply it when permitted, rebuild and retest. Never silently repair after an incident.

### R9 — Protect Existing Work
Inspect existing files before modifying them. Preserve working functionality. Avoid unnecessary destructive changes. Never edit an applied migration; add a forward correction.

### R10 — Report Honestly
Report scope, changed files, evidence inspected, exact check results, assumptions, risks, decisions, approvals still required, and next safe step. Editing files alone does not complete a task.

## Consolidated Architecture Principles (from archived docs)

The following principles from the archived `docs/archive/before-writing-code-2.md` series are already reflected in the current repository and .ai/ governance. They are restated here for clarity:

- **Technology stack**: ASP.NET Core 10 Web API, PostgreSQL 18, EF Core/Npgsql 10.0.3, Next.js 15 web foundation, React Native mobile direction. Confirmed in `global.json`, `Directory.Packages.props`, `compose.yaml`, and `architecture/system-context.md`.
- **Modular monolith with clean architecture**: Explicit module and sector boundaries. Modules own their data and expose use-case interfaces. No direct cross-module table writes. Confirmed in `architecture/system-context.md`.
- **Organization and branch isolation**: Every branch-related record must be associated with the correct organization and branch. Server-side authorization enforces isolation. Never trust branch IDs supplied by clients. Relevant to Pharmacies Sector locations and Specialized Contracting Sector.
- **User roles and permissions**: Permission-based authorization, not hardcoded role checks. Roles include Administrator, organization owner, branch manager, accountant, inventory manager, employee. Server-side authorization required on every API request.
- **Audit logging**: Track who created/modified records, which branch/location was affected, when, and what changed. Already implemented via `CatalogueAuditEvents` and `GovernanceTestExecutions`.
- **Security**: Server-side authorization, OWASP-aligned protections, input validation, HTTPS, secure configuration, structured logging. Confirmed in `security-rules.json` and `agent-safety-and-tool-boundaries.md`.

## Enforcement

Before reading or following any file, an AI agent must verify:

1. Is the file `AGENT.md`, `AGENTS.md`, or inside `.ai/`? → **Allowed**
2. Is the file `AGENT.md` or `AGENTS.md` at repository root? → **Allowed**
3. Is the file inside `.ai/` and referenced by `.ai/agent-context.json` mandatory baseline or selected task profile? → **Allowed**
4. Otherwise → **Prohibited**. Stop and do not read or follow the file.

If a host-specific instruction file (e.g. CLAUDE.md) references an external doc or markdown file, the agent must decline and redirect to AGENT.md, AGENTS.md, or .ai/.

## Violation Handling

Reading, following, or citing a prohibited docs/md file as authority is a governance violation. The agent must:
1. Stop the affected action immediately.
2. Record the violation in `current-state.md` and `change-log.md`.
3. Notify the user and request direction.
4. Not treat any information from the prohibited source as binding.