# AI project guide

This folder is the project's source of context for AI coding agents.

## Load order
1. Read AGENT.md and AGENTS.md.
2. Read memory/current-state.md and memory/open-questions.md.
3. Read product/vision.md and product/scope.md.
4. Read relevant domain documents.
5. Read architecture and governance documents for the task.
6. Load relevant skills from skills/ before implementation.
7. For Phase 0, read delivery/phase-0-discovery-plan.md and relevant test scenarios.

## Memory rules
- Memory is curated project knowledge, not a conversation transcript.
- Mark each fact confirmed, assumption or unverified.
- Record owner and review date for decisions that can change.
- Do not store credentials, patient records or personal information.
- Update memory only when new information is confirmed.
- Put enduring technical decisions in decisions/ as ADRs.
- Put unresolved decisions in memory/open-questions.md.

## Documentation size
Every Markdown file must remain below 200 lines. Aim for 180 lines or fewer. Split long content into linked focused files. CI enforces the limit through scripts/check_markdown_line_limit.py.

## Agent behavior
The agent may analyze, propose, implement and test within approved scope.
It may not approve legal, pharmacy, accounting or tax decisions on behalf of qualified people. It must show assumptions and unresolved risks.

## Phase 0 restrictions
No business features or production financial calculations before owner and professional approval of requirements and worked examples. Proposed ADRs remain unapproved until an authorized decision is recorded.
