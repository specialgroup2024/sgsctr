# Cross-platform agent compatibility

## Objective

Make repository governance usable by local and online agents without assuming that every tool automatically reads the same files or supports the same orchestration features.

## Required behavior for every integration

- Treat root `AGENT.md`, root `AGENTS.md` and this `.ai/` guide as the canonical shared sources.
- Explicitly bootstrap the canonical files in the agent runner's supported instruction entry point.
- Load the task-relevant governance and project references before acting.
- Follow the same specialization selection, deliberation, approval and evidence rules.
- Respect tool permission boundaries; repository instructions do not grant permissions that the runtime or user has not granted.
- Report which governance files were actually loaded when the platform makes that information observable. If not observable, disclose the uncertainty.
- Do not claim that a platform automatically supports `AGENT.md` or `AGENTS.md`; support and precedence vary by tool and version.

## Adapter pattern

A vendor- or tool-specific instruction file may contain a short bootstrap that points to the canonical files and states the required load order. Keep tool-specific configuration minimal. Do not copy the full policy into multiple adapters, because duplicated policies drift.

For tools that support only one instruction file, that file must direct the agent to read the other canonical files and relevant `.ai/governance/` documents. For tools that support hierarchical instructions, verify their scope and precedence and ensure they do not weaken root controls.

## Capability transparency

If the environment cannot run multiple agents, use explicit role-labeled analysis as a simulation and disclose that it is not independent multi-agent review. If it cannot access the repository, current external sources or test environment, state the limitation and do not claim verification.

## Maintenance

When adding a new agent platform, document its actual instruction entry point, loading behavior, scope/precedence, tool permissions and verification method. Validate the adapter against the canonical governance documents after platform updates.