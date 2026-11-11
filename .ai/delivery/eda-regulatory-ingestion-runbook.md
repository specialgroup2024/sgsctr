# EDA regulatory ingestion operations

Status: initial operational runbook for the EDA ingestion MVP.

## Expected behavior

- API startup starts the background worker after the application host is running.
- The worker attempts a first due-source scan, then wakes every 15 minutes.
- Each source is checked every 360 minutes unless an administrator requests a forced scan.
- A successful scan stores new HTML/PDF documents and creates unread alerts. Existing URL/hash matches are not re-imported.
- Failed source checks update LastError and the scan-run history; other sources continue.

## Deployment and migration

1. Deploy the API and web build from the same commit.
2. Apply the additive AppDbContext migration 20261111140000_EdaRegulatoryIntelligence before enabling the worker in production.
3. Development Compose has Database__ApplyMigrations=true; production must use the approved migration job/process rather than enabling startup migrations by default.
4. Preserve the PostgreSQL data volume and take a verified backup before production migration.
5. Confirm the four RegulatorySources seed records appear after the first worker cycle.

## Monitoring

- Open Pharmacies → Regulatory Intelligence.
- Check each source's last check, last successful check and error.
- Check last scan status, discovered link count and new document count.
- Review unread alerts and open the ingested copy or original EDA page.
- Acknowledge an alert only after assigning it to the responsible reviewer; acknowledgement is not regulatory verification or approval.
- Administrator users can select Scan EDA now. Standard authenticated users can view and acknowledge alerts but cannot trigger a scan.

## Failure handling

- DNS, TLS, timeout, HTTP status, redirect, changed page markup and size-limit failures appear in source LastError and scan history.
- Do not bypass access controls, change user-agent to evade restrictions, or fetch arbitrary hosts.
- Confirm the URL manually in a browser and check the EDA website before changing the seed URL.
- If EDA changes page structure, update the parser and add regression fixtures using permitted public samples.
- Do not delete a source or document to silence an error; retain evidence and history.

## Storage and data protection

- Original HTML/PDF bytes are stored in PostgreSQL. Each document is limited to 5 MiB and each scan cycle imports at most 12 new documents.
- Database backups include the original documents. Monitor database size, backup duration and restore time.
- Retention and deletion policy is not yet approved; do not implement automatic purging.
- Do not upload confidential supplier correspondence, patient information or internal records into the public-source ingestion pipeline.
- Restrict API access using authenticated sessions; manual scans require Administrator.
- Review downloaded documents as untrusted files; do not execute embedded content.

## Human review and escalation

- All documents start Unverified / Pending.
- Recall and safety title keywords only set a triage hint UrgentReview; immediately route apparent safety/recall material to the designated pharmacist/quality lead.
- Verify original Arabic text, issuing authority, instrument number, publication/effective dates, amendments and applicability.
- Record the evidence and decision in .ai/governance/evidence-register.md and .ai/governance/egypt-requirements-register.md when it affects agent development work.
- Only authorized Egyptian professionals and business owners may approve legal interpretation, pharmacy practice, clinical/quality disposition, pricing, inventory, reimbursement or accounting changes.

## Current exclusions

No email/SMS/push notification, OCR, automated translation, legal interpretation, automatic effective-date extraction, product matching, market price feed, external paid feed, or automatic business-rule update is configured.
