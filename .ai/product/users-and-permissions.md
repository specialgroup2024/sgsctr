# Users, roles and permission boundaries

Status: requirements baseline. Final role catalogue, named assignments, delegation and business permissions are not approved. Do not infer them from UI navigation or development accounts.

## Identity foundation
- Repository uses ASP.NET Core Identity with PostgreSQL; Keycloak is not the active Compose identity service.
- Web uses a server-side BFF/session boundary. Clients never connect directly to DB.
- Development authentication may be disabled locally; this is unacceptable in staging/production.
- Verify sign-in/out, session expiry, refresh, recovery, lockout, MFA and anonymous denial before claiming authentication complete.
- Never seed real people or shared production credentials in source control.

## Authorization model
Use server-side role permissions plus resource attributes. Roles grant capabilities; resource scope constrains them. Potential dimensions:
- Legal entity (provisional LE-01; documentary verification pending).
- Sector: Pharmacies or Specialized Contracting.
- Pharmacy location/warehouse/branch.
- Contracting project or contract.
- Record ownership, assignment, workflow state and environment.

Every API command authorizes both action and target resource. Hiding a button is not security.

## Candidate role families — proposal only
- Platform administration: identity/configuration support; no implicit business approval or financial authority.
- Organization administration: owner-approved organization/location reference maintenance.
- Pharmacy operations: catalogue, supplier, receiving, stock, transfer and dispensing only when each workflow is implemented and approved.
- Pharmacy professional reviewer: regulated decisions within verified professional remit.
- Contracting operations: project, contract, procurement and commercial operations within approved scope.
- Finance/accounting: review/posting only after accountant-approved policy and segregation of duties.
- Auditor: read-only access to explicitly scoped records/evidence.
- Security/privacy reviewer: security/privacy review; no implicit business-policy authority.

These are design role families, not an approved matrix or named authority assignment.

## Separation of duties
Separate request, create, submit, review, approve, reject, dispatch, receive, reconcile, post, reverse, user administration and audit permissions. Prevent self-approval/incompatible combinations when policy requires it. Administrator status does not confer professional reviewer authority.

Supplier declaration, verification, qualification, reviewer authority and purchasing/receiving eligibility are separate capabilities. Pending intake does not imply verified or eligible.

## Required controls
- Default deny; unknown scope is denied; least privilege.
- Enforce in API handlers and data access, not only BFF/UI.
- Use policy-based authorization and explicit resource checks.
- Audit actor, permission context, resource, action, result, timestamp and correlation.
- Protect permission changes with privileged approval and audit; review access periodically and revoke promptly.
- Test cross-sector, cross-location, cross-project and privilege-escalation attempts.

## Decisions required
Owner/sector leads must approve populations, roles, permission catalogue, scope, delegation, emergency access, privileged-account controls and separation-of-duties matrix (Q22). Security/privacy review must approve implementation/residual risk (INV-SEC-001). Qualified professionals approve roles making regulated/accounting decisions. Production remains gated by INV-REL-001.

[Identity ADR](../architecture/ADR-0002-identity-and-access.md) · [Identity security](../security/identity-access-baseline.md) · [Audit](../security/audit-logging-baseline.md) · [Approval register](../governance/approval-register.md)
