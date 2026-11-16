# API conventions

Status: engineering baseline; inspect source before claiming an endpoint exists.

## Contract
- ASP.NET Core is the authoritative application API. Clients never connect directly to PostgreSQL.
- Use versioned /api/v1 routes for new external contracts; preserve existing routes until a reviewed migration.
- Use request/response DTOs, not EF entities. Keep persisted values, identifiers and enums language-neutral.
- Validate input, ownership, state transitions, ranges and lengths on the server.
- Use structured Problem Details and stable error codes. Use 400 invalid input, 401 unauthenticated, 403 denied, 404 absent/non-visible and 409 concurrency/state conflict.
- Use 201 plus resource location for creation, 204 for no-content and 200 for successful representations.
- Use bounded pagination, stable sorting, explicit filters and UTC ISO-8601 timestamps.

## Commands and reliability
- Use transactions for invariants spanning writes and optimistic concurrency for shared mutable records.
- Retryable commands require idempotency keys/stable command IDs. Side effects never occur on GET.
- Use durable outbox/job patterns for cross-module delivery. Retries must not duplicate stock movements, postings, decisions or document records.
- Do not expose success for a merely queued or Pending action.
- No financial/inventory posting endpoint until the exact policy and approvals are recorded.

## Security and audit
- Authorize every protected operation server-side; UI visibility is not security.
- Scope access by legal entity, sector, branch/location, project and assignment as applicable.
- Enforce approved separation of duties for review, approval, dispatch, receipt and release.
- Audit privileged changes and workflow transitions. Never log credentials, tokens, patient data or full sensitive payloads.
- Apply same-origin/CSRF/session protections to browser BFF writes.
- Do not reveal protected resource existence to unauthorized callers.

## Tests and documentation
- Document method, route, schema, authorization, validation, side effects, idempotency, audit and errors.
- Test positive/negative, boundary, authorization, concurrency, persistence and BFF/API behavior.
- Test English/Arabic UI states where applicable. OpenAPI must match actual behavior.
- API documentation does not prove that a workflow is implemented, approved or operational.

## Related
[System context](system-context.md) · [Data model](data-model.md) · [Users and permissions](../product/users-and-permissions.md) · [Approval boundary](../governance/approval-and-execution.md)
