# AI context index — technical acceptance record

Date: 2026-11-16
Scope: Task 1 and its corrected documentation-integrity tasks from PR #80.
Implementation: PR #80, merged to master as merge commit `dac7ded6eafc4974b1c6ab40dc666f9072ae6d0d`.
Follow-up validation branch: `docs/ai-context-technical-acceptance`.

## Acceptance decision

**Technical acceptance: BLOCKED — verification evidence is incomplete.**

The feature is implemented and merged, but it is not accepted as technically complete until the mandatory repository checks execute successfully on the current source tree. A merged pull request is not test evidence.

## Scope accepted for verification

- Deterministic generation of `.ai/CONTEXT_MANIFEST.json` and `.ai/index.md`.
- Git-tracked Markdown inventory, Git blob hashes, byte sizes and empty-placeholder detection.
- Repository-relative Markdown link validation.
- Generated-index freshness and Markdown line-limit enforcement.
- Correct bootstrap and navigation through `AGENT.md`, `AGENTS.md` and `.ai/README.md`.
- Canonical document ownership and protection against treating navigation metadata as policy or approval.

## Evidence already verified

- The merged implementation contains the generator, index, manifest, link checker and CI workflow integration.
- The pre-acceptance manifest was reconciled with the Git tree: 131 source Markdown files (excluding generated `.ai/index.md`), six empty placeholders, zero path/hash/size mismatches, deterministic path order.
- The generated index at the merged commit was 171 lines, below the 200-line limit.
- The generator and link checker were previously exercised against an isolated temporary Git fixture. This earlier fixture exercise was not a full repository run and did not provide a CI result.
- PR #80 is merged. GitHub Actions runs on its merge commit reported failures, but the job records contained empty `steps` arrays, `runner_id: 0`, no runner name, no log URL, and log downloads returned 404. The jobs therefore provide no evidence that the commands ran or failed.
- A rerun of the documentation job was requested; it again completed as failed without exposed steps or logs.

## Additional regression coverage added

The follow-up validation branch adds `scripts/test_ai_context_integrity.py` and invokes it in `.github/workflows/markdown-line-limit.yml`. The isolated fixture tests cover:

1. Deterministic generation and `--check` freshness behavior.
2. Manifest counts, empty files, index exclusion, Git blob SHA and byte-size agreement.
3. Local Markdown links, heading anchors, duplicate-heading anchors and links to tracked non-Markdown assets.
4. Ignoring fenced-code examples.
5. Failing for missing local paths and missing anchors.

These tests are added to CI but are **not yet reported as passed**. The validation branch requires its own successful workflow run.

## Mandatory acceptance criteria

| ID | Criterion | Current disposition |
|---|---|---|
| TAI-01 | Generator output is deterministic | Prior isolated fixture evidence; repeatable CI test added, CI pending |
| TAI-02 | Manifest paths, blob hashes and sizes match the current Git tree | Verified at merged commit; must be rerun after follow-up documentation changes |
| TAI-03 | Generated index is fresh and below 200 lines | Merged-commit index measured at 171 lines; current branch CI pending |
| TAI-04 | Link checker passes across every tracked Markdown file | Pending full-repository execution |
| TAI-05 | Regression tests pass | Added; execution pending |
| TAI-06 | Documentation CI completes successfully with inspectable logs | Blocked; current GitHub Actions jobs have no runner/steps/logs |
| TAI-07 | Application build, database migration and runtime checks remain unaffected | No application code/schema/migration changed; no new runtime claim |
| TAI-08 | Approval register and business/professional decisions are unchanged | Verified unchanged; see approval boundary below |

## Business and professional approval boundary

This work is documentation/tooling only. It does not approve or change pharmacy, regulatory, legal, quality, accounting, tax, supplier qualification, security/privacy or production-release decisions.

The authoritative `.ai/governance/approval-register.md` remains unchanged by this work. In particular, the pending statuses remain pending, including:

- `INV-PRO-001` pharmacist / pharmacy-operations approval.
- `INV-REG-001` Egyptian regulatory / legal approval.
- `INV-QLT-001` quality approval.
- `INV-ACC-001` accountant approval.
- `INV-OWN-002` owner operating-policy approval.
- `INV-SEC-001` security review and residual-risk acceptance.
- `INV-REL-001` controlled production release.

Existing owner authorizations retain only their recorded scope and conditions. CI success, PR merge, implementation completion or an agent statement cannot promote any of these statuses. A change requires the relevant named authority, evidence, date, scope and conditions to be recorded under the approval-register procedure.

## Remaining blockers and closure rule

1. Obtain a usable GitHub Actions runner and inspectable job logs.
2. Run `python scripts/test_ai_context_integrity.py`.
3. Run `python scripts/check_markdown_line_limit.py`.
4. Run `python scripts/ai_context_index.py --check`.
5. Run `python scripts/check_markdown_links.py` over the complete tracked tree.
6. Reconcile the generated manifest against the exact commit being accepted.
7. Record all commands, commit SHA, workflow run IDs and outcomes here.
8. Only then change this record to **Technically accepted**. Business/professional approvals remain separate and cannot be changed by this technical acceptance.

No release or business/professional approval is implied by this record.
## Follow-up PR #81 workflow observation

- PR #81 adds the regression tests and invokes them before the three existing documentation checks.
- GitHub created documentation workflow run `43859532336` and .NET foundation workflow run `43859532271` for head `33d27fe7d9dca59723f77795ebe65ef62a3a7676`.
- Both completed as failures within approximately two seconds. Raw job records show `runner_id: 0`, empty `runner_name`, and empty `steps: []`; no test command is shown as executed. The PR head's combined commit status remains pending with zero status contexts.
- This is consistent with the merge-commit behavior on PR #80 and points to a GitHub Actions runner/execution problem, not a demonstrated assertion failure in the new tests.
- The current agent environment cannot clone the private repository because outbound GitHub DNS/network access is unavailable. The test suite therefore remains unexecuted here.
- PR #81 is open and unmerged. Technical acceptance remains blocked; do not merge as accepted solely because the source is present.
