# Audit and application logging baseline

Status: proposed technical baseline; event catalogue and retention approval pending.

## Purpose and separation

Application logs support diagnostics and operations. Security logs record authentication, authorization and security events. Business audit records provide evidence of who performed a consequential action, on which resource, when and with what outcome. These are related but distinct records; ordinary application logs are not a substitute for a business audit trail.

## Minimum audit envelope

A future persisted audit event should include, where applicable:
- Event identifier and UTC occurrence timestamp.
- Actor subject identifier and actor type (human, service or system).
- Action/operation and outcome (succeeded, rejected or failed).
- Resource type and stable resource identifier.
- Legal-entity, sector and location scope identifiers when applicable.
- Correlation/trace identifier and source application.
- Reason/reference supplied for controlled corrections or privileged actions.
- Schema/event version.

Record only the minimum information needed for accountability. Do not copy full request bodies or sensitive records into audit payloads.

## Events to catalogue before implementation

- Authentication success/failure, account disablement and recovery.
- Authorization denial and privileged access changes.
- User, role, permission and scope assignment changes.
- Configuration and integration-secret rotation events (never the secret value).
- Approved business events such as stock dispatch/receipt, adjustments, financial approval and posting, only after the relevant workflows and policies are approved.

## Integrity and access

- Persist consequential business audit events separately from ordinary diagnostic logs.
- Restrict write/read access using dedicated application/database permissions.
- Prefer append-only records; corrections are additional events, not silent edits.
- Define retention, export, backup, restore and tamper-detection controls with the owner and qualified legal/security reviewers.
- For state changes that require an audit record, design persistence so business change and audit/outbox record commit atomically.
- Do not claim tamper-proof or immutable storage until the deployed controls and independent recovery tests demonstrate it.

## Data minimization and redaction

Never log passwords, access/refresh tokens, cookies, authorization headers, connection strings, API keys, patient/health data or full payment details. Avoid personal data in exception messages and telemetry. Use synthetic test data.

## Implementation boundary

The current API has framework logging and a readiness warning but no persisted audit model, event catalogue, retention policy or tamper-evidence mechanism. Do not add a speculative audit schema until event ownership, data classification, retention and required evidence are reviewed.
