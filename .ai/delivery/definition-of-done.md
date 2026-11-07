# Definition of done

A discovery or implementation task is complete only when its scope and evidence are clear.

## For Phase 0 discovery
- Confirmed facts, assumptions and open questions are separated.
- Relevant business owners and professional reviewers are identified.
- Workflows and test scenarios are documented without inventing policy.
- Proposed decisions are labelled proposed until explicitly approved.
- Risks, dependencies, approvals and next steps are recorded.
- Every Markdown file remains below 200 lines.

## For implementation after Phase 0
- Acceptance criteria trace to an approved requirement and owner.
- Authorization is enforced server-side and negative access tests exist.
- Financial and inventory invariants are protected by database transactions and constraints.
- Money uses fixed precision and explicit currency; calculations match approved worked examples.
- Migrations are reviewed and tested against representative data.
- Audit events capture actor, time, action, source and reason without leaking sensitive data.
- Tests, build, static analysis and security checks are run; results are recorded accurately.
- Backup/restore, operational monitoring, support and rollback are documented as applicable.
- Business owner and relevant accountant, pharmacist, legal or tax professional approvals are recorded where required.

No production readiness claim is allowed while a critical approval, reconciliation, security or recovery gate is unresolved.
