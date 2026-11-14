# EDA regulatory ingestion operations

Status: MVP merged to master. Owner supplied one successful scan log dated 2026-11-11. Continue to treat this as a bounded MVP, not exhaustive monitoring or a regulatory compliance service.

## Expected behavior
- API startup starts the background worker after the application host is running.
- Worker wakes every 15 minutes; each source is due every 360 minutes unless an administrator requests a forced scan.
- Successful scans store new HTML/PDF documents and create unread alerts. URL/hash matches are not re-imported.
- Failed source checks update LastError and scan history; other sources continue.

## Observed verification
Owner-provided API logs on 2026-11-11 reported five sources, 100 discovered links, 12 new documents and zero failures. This proves one successful observed cycle only. It does not establish continuous operation, exhaustive source coverage, legal applicability or completion of qualified review.

## Deployment and migration
1. Deploy API and web from the same commit.
2. Preserve PostgreSQL data and take a verified backup before production migration.
3. Development Compose enables startup migrations; production must use an approved migration job/process.
4. Confirm five RegulatorySources seed records and inspect last-check/last-success/error after deployment.
5. Do not remove source/document history to silence ingestion errors.

## Monitoring and review
- Open Pharmacies → Regulatory Intelligence.
- Check each source's last check, last successful check and error.
- Check last scan status, discovered link count and new document count.
- Review unread alerts and open the ingested copy or original EDA page.
- Acknowledge only after assigning the item to a responsible reviewer; acknowledgement is not regulatory verification or approval.
- Manual scan and acknowledgement require the configured administrative/authenticated controls. When local Development authentication is explicitly disabled, do not mistake the local development identity for production access control.

## Storage and Data Protection
- Original HTML/PDF bytes are stored in PostgreSQL. Each document is limited to 5 MiB and each cycle imports at most 12 new documents.
- Database backups include original documents. Monitor database size, backup duration and restore time.
- Retention/deletion policy is not approved; do not implement automatic purging.
- Compose defines named volume sgsctr_dataprotection_keys mounted at /var/lib/sgsctr/data-protection-keys. Verify it contains the existing key ring and survives API-container recreation before relying on it operationally.
- Production requires DataProtection certificate path/password supplied through secrets. Development key files are not encrypted at rest by the current configuration.

## Failure handling and human review
- DNS, TLS, timeout, HTTP status, redirect, changed markup and size-limit failures appear in source LastError and scan history.
- Do not bypass access controls, evade restrictions, or fetch arbitrary hosts.
- All documents start Unverified/Pending. Recall/safety keywords create an UrgentReview triage hint, not a clinical risk classification.
- Verify original Arabic text, issuing authority, instrument number, publication/effective dates, amendments and applicability.
- Qualified Egyptian professionals and business owners must approve legal interpretation, pharmacy practice, clinical/quality disposition, pricing, inventory, reimbursement or accounting changes.

## Current exclusions
No email/SMS/push, OCR, automated translation, legal interpretation, reliable effective-date extraction, product matching, market-price feed, external paid feed or automatic business-rule update is configured.
