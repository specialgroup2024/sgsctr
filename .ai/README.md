# AI project guide

This folder is the project's source of context for AI coding agents.

# Load order

1. Read AGENT.md and AGENTS.md.
2. Read memory/current-state.md and memory/open-questions.md.
3. Read product/vision.md and product/scope.md.
4. Read domain documents relevant to the task.
5. Read relevant architecture and governance documents.
6. Load relevant skills from skills/ before implementation.

# Memory rules

- Memory is curated project knowledge, not a conversation transcript.
- Mark each fact confirmed, assumption, or unverified.
- Record owner and review date for decisions that can change.
- Do not store credentials, patient records, or personal information.
- Update memory only when new information is confirmed.
- Put enduring technical decisions in decisions/ as ADRs.
- Put unresolved decisions in memory/open-questions.md.

# Documentation size

Every .md file must remain below 200 lines.
Aim for 180 lines or fewer. Split content into linked focused files.

# Agent behavior

The agent may analyze, propose, implement, and test.
It may not approve legal, pharmacy, accounting, or tax decisions on behalf
of qualified people. It must show assumptions and unresolved risks.
