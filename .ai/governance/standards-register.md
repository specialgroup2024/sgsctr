# Standards and regulatory references

Use standards as versioned, testable references. A reference is not evidence of implementation, compliance or certification. Recheck the issuing body's official publication before a design, procurement or release decision.

## ICT and security baseline
| Reference | Source-derived baseline | Application and evidence |
|---|---|---|
| OWASP ASVS | 5.0.0 stable release stated in supplied source (2026-11-07). | Select applicable control IDs; record version, test, result and evidence location. |
| OWASP Top 10 | 2025 awareness resource. | Use for threat awareness, not as a complete verification plan. |
| OWASP MASVS | Mobile application security verification framework. | Apply when the React Native/mobile client is developed; cover storage, authentication, network, platform and privacy. |
| NIST SSDF | v1.1 final; v1.2 described in supplied source as draft. | Treat drafts as monitoring items, not adopted baselines. |
| OWASP AISVS | v1.0 identified in supplied source. | Evaluate only if application AI capabilities are in scope; require human oversight and output validation. |

## Management-system standards to evaluate
- ISO/IEC 27001:2022 — information-security management system; define organizational and system scope before considering certification.
- ISO/IEC 27701:2025 — privacy information management; evaluate against actual personal/health-data processing roles and applicable law.
- ISO/IEC 42001:2023 — AI management system; consider only if AI development/use is in scope.
- These are candidates for assessment, not adopted project requirements or certification claims. Verify current editions, corrigenda, transition rules and certification availability with the issuing body/accredited certification bodies.

## Egypt requirements
Egyptian legal and regulatory requirements are tracked separately in egypt-requirements-register.md and egypt-pharmacy-source-register.md. Investigate applicable pharmacy practice, establishment licensing, controlled products, product registration/pricing, storage/distribution, devices, cosmetics, pharmacovigilance, tax/e-invoice, privacy and payer requirements.

Official Gazette instruments and current amendments establish binding legal text. EDA index pages and government announcements may be discovery sources but are not substitutes for the original instrument. Foreign WHO/EMA/FDA or other references are comparative unless adopted by an applicable Egyptian instrument.

## Required standard record
For each adopted or evaluated reference record: title; issuing body; edition/version; status (draft/final/withdrawn/superseded); publication/effective date; official URL; applicable scope; selected controls; evidence location; owner; last verification; next review; decision status. Preserve superseded versions and map changes to requirements and tests.

## Approval and claims
Qualified security/privacy, legal, regulatory, pharmacy, tax and accounting reviewers validate matters within their remit. An agent-generated checklist, successful test suite or internal audit does not certify the organization or application.
