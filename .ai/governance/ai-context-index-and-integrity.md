# AI context index and documentation integrity

## Purpose

The generated context catalogue makes the repository's existing governance and project knowledge discoverable. It is not a replacement project plan, a second task tracker, a policy source or an approval mechanism.

## Generated artefacts

- `.ai/CONTEXT_MANIFEST.json` records every Git-tracked Markdown document, its repository category, Git blob SHA, byte size, line count and whether it is empty.
- `.ai/index.md` groups those documents by their existing directory structure and flags empty placeholders.
- Both files are generated from the Git working tree by `scripts/ai_context_index.py`. Do not edit either generated file manually.
- Run `python scripts/ai_context_index.py` after adding, removing, renaming or editing Markdown; run `python scripts/ai_context_index.py --check` to verify reproducibility.

The manifest deliberately excludes the generated index itself to avoid a self-referential hash. The manifest is JSON and is therefore not part of its own Markdown inventory.

## Authority and canonical ownership

Navigation does not change document authority. Use these existing ownership boundaries:

| Information | Canonical source |
|---|---|
| Universal agent behavior | Root `AGENT.md` |
| Repository execution rules | Root `AGENTS.md` |
| AI context navigation and load order | `.ai/README.md` and generated `.ai/index.md` |
| Approval status and evidence pointers | `.ai/governance/approval-register.md` |
| Detailed decision rationale | The linked ADR, owner decision or qualified review record |
| Verified repository/implementation state | `.ai/memory/current-state.md`, reconciled against source, tests and runtime evidence |
| Stable owner-provided facts | `.ai/memory/project-facts.md` |
| Unresolved questions | `.ai/memory/open-questions.md` |
| Task-specific specialist selection | `.ai/roles/role-selection.md` and its completed task record |
| Operational procedures | The relevant focused delivery/runbook or skill document |

A navigation page may summarize where to look but must not duplicate the full policy or silently become a competing source of truth. Keep historical source material as history; do not delete or rewrite it merely because newer guidance exists.

## Integrity checks and limits

- `scripts/check_markdown_links.py` checks repository-relative inline Markdown links and reference definitions, including local heading fragments. External links are counted but not fetched.
- `.github/workflows/markdown-line-limit.yml` runs the existing Markdown line-limit check plus the context-index freshness and local-link checks.
- These checks do not validate external URLs, all Markdown dialect extensions, application behavior, legal/regulatory correctness or approval status.
- A passing link check proves only that the supported local link forms resolve in the checked Git tree.
- Empty Markdown files are reported as placeholders. They are not automatically populated or deleted; an owner/domain decision and evidence are needed to determine whether each is still required.

## Initial repository observations

The baseline Git tree at commit `8b01a7ef2b55d994af8168a3376e76407ea2283f` contains 130 tracked Markdown files, including 109 under `.ai/`. Six `.ai/` Markdown files are empty placeholders:

- `.ai/architecture/api-conventions.md`
- `.ai/architecture/data-model.md`
- `.ai/architecture/deployment.md`
- `.ai/delivery/release-and-rollback.md`
- `.ai/product/acceptance-criteria.md`
- `.ai/product/users-and-permissions.md`

These are documentation completeness gaps, not evidence that the related technical capabilities are absent or implemented. The initial bounded scan of root `AGENT.md`, `AGENTS.md`, `.ai/README.md` and `README.md` found 10 relative Markdown links and all 10 resolved. A full-repository automated check is added by this change; its result must come from CI or a local run, not inference.

No canonical document has been deleted, renamed or merged as part of this index work. The existing folder structure and historical records are retained.
