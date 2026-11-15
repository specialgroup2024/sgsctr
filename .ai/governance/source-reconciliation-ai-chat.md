# Source reconciliation — ai-chat upload

Source package: user-uploaded ai-chat.zip, containing four Markdown files. Reviewed on 2026-11-15. This record maps source guidance to SGSCTR repository evidence; it is not an approval of every proposal in the source.

## Reconciliation rules
- Preserve source terminology where useful, but use the existing SGSCTR document structure rather than creating a parallel tree.
- Import reusable governance guidance; do not copy stale example architecture, legal claims or generic build sequencing as approved project decisions.
- Keep owner facts, repository evidence, assumptions, proposals and unknowns distinct.
- A missing/empty target file is a documentation gap, not evidence that the corresponding capability exists.
- All Markdown stays below 200 lines; CI script/workflow are already present.

## Source-to-repository map
| Source | Topic | SGSCTR status | Action / destination |
|---|---|---|---|
| 001 | Two-business modular monolith and accounting boundaries | Present as a proposal with legal-entity caveats. | Preserve architecture/system-context.md, domain/business-boundaries.md and domain/accounting-rules.md; do not duplicate. |
| 001 | Pharmacy product, supplier, receipt, lot/expiry, transfer, dispensing, returns and recall workflows | Partially documented; many operational workflows remain unimplemented and approval-gated. | Keep open questions and phase scope authoritative; use pharmacy-inventory skill guardrails. |
| 001 | Weighted-average costing and payer claims | Requirements and questions exist; detailed rules remain unapproved. | Preserve accounting-rules.md, claims-and-contracts.md and costing workpapers. Do not adopt 80/20 or 10% as universal defaults. |
| 001 | Contracting project/commercial workflows | Scope identified; workflows and accounting remain discovery items. | Preserve product/scope.md and memory/open-questions.md; no workflow implementation authorized by this source. |
| 001 | Egypt privacy, pharmacy and ETA compliance | Dedicated Egyptian requirements/evidence registers exist; applicability requires qualified review. | Keep Egypt legal evidence separate from international standards; do not copy source legal statements as verified advice. |
| 001 | Eight-stage suggested build sequence | Generic recommendation, not current SGSCTR approved roadmap. | Do not replace current phase/work-package gates. |
| 002 | AGENT/AGENTS startup and safety rules | Already present, strengthened in this branch. | Updated root instructions; preserve cross-platform bootstrap and dynamic specialization. |
| 002 | Curated project memory with status/evidence/owner/review | Partially present; project-facts.md was a placeholder. | Populate memory/project-facts.md; current-state/open-questions remain separate. |
| 002 | Dynamic roles and progressive skills | Dynamic five-role governance exists; seven skill files were empty. | Populate task-specific SKILL.md workflows; select profiles per task, not permanently. |
| 002 | Suggested repository tree | SGSCTR already has a richer, differently named structure. | Reuse existing product/domain/governance/security/quality/delivery/operations folders; no duplicate tree. |
| 003 | OWASP ASVS/Top 10, MASVS, NIST SSDF, AISVS | Partial baseline existed in standards register. | Expand versioned reference table and require current official verification and evidence mapping. |
| 003 | ISO/IEC 27001, 27701 and 42001 roadmap | Existing roadmap was an incomplete note. | Replace with staged evaluation roadmap; no certification or adoption claim. |
| 004 | Markdown below 200 lines and CI enforcement | Already implemented. | Keep scripts/check_markdown_line_limit.py and .github/workflows/markdown-line-limit.yml; never claim pass without execution evidence. |

## Deliberately not imported as approved decisions
- Exact legal entity structure, statutory ledger design, chart of accounts, tax treatment and intercompany policy.
- Payer coverage percentages, patient copay, discount order, claims settlement and collection rules.
- Product family taxonomy, regulatory identifiers, storage/handling, batch/serial/expiry requirements and clinical procedures.
- Supplier qualification, purchasing/receiving, stock transfers, costing, recall disposition and operational roles.
- Generic eight-stage feature build sequence, hosting/deployment topology, user-role matrix or certification procurement.
- External legal/standards statements whose current official text or applicability has not been independently checked in this task.

## Completion status
The four uploaded files have been reconciled against the inspected branch documents. Existing content was retained where stronger SGSCTR-specific evidence exists; missing skill and memory documentation was populated; standards/certification guidance was made structured and explicitly non-authoritative. No application code, schema, business workflow, financial rule, product classification, approval state or production setting is changed by this documentation update.
