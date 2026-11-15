---
name: dotnet-api
description: Build or review SGSCTR ASP.NET Core API, application services, validation, authorization, health endpoints and integration boundaries.
---

# Workflow
1. Read root instructions, system-context.md, relevant module/API conventions and approval records.
2. Confirm target framework, SDK, EF provider and package versions from repository files; do not upgrade by assumption.
3. Trace endpoint → authorization → validation → application service → persistence; preserve module ownership.
4. Use server-side authorization and explicit resource/sector/location scope. Fail closed for protected operations.
5. Use async cancellation-aware I/O, stable error contracts, safe logging and idempotency for retryable commands.
6. Add unit/integration/contract tests for success, invalid input, forbidden access, concurrency and failure paths.
7. Run targeted tests and build; record exact commands and results.

# Guardrails
- Never trust UI-only authorization.
- Do not expose secrets, patient data or internal exception details.
- Do not add business workflows or financial/stock side effects without approval.
- Record API contract and migration impacts; keep changes reversible where feasible.

# References
See architecture/system-context.md, security/identity-access-baseline.md, security/audit-logging-baseline.md and delivery/definition-of-done.md.
