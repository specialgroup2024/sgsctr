# Standards and certification guidance

This document continues the discovery guidance in [002-gpt_luna.md](002-gpt_luna.md).

## Current technology and standards baseline

As of **November 7, 2026**, specify supported versions in a dated `.ai/architecture/system-context.md`, then recheck official release pages before starting implementation and on a regular update schedule. The current .NET support page lists .NET 10 as LTS, PostgreSQL lists 18.6 as a released version, and React Native lists 0.88 as active. Pin supported versions and patches; do not use release candidates or nightly builds in production. <citation src="22,2,6"></citation>

Use community standards as **testable references**, not as vague claims of compliance:

- **Web/API security:** OWASP ASVS 5.0.0 is the current stable release; record requirement references with the version included. OWASP Top 10 2025 is an awareness resource, not a complete test plan. <citation src="27,29"></citation>
- **Mobile security:** Use OWASP MASVS and its testing resources to build mobile checks for storage, authentication, network communication, platform behavior, and privacy. <citation src="11,13"></citation>
- **Secure development:** NIST SSDF v1.1 is final. NIST’s SSDF v1.2 page is still marked **draft**, so track it as an update to review—not as a finalized requirement. <citation src="32,33"></citation>
- **If the application itself uses AI:** review OWASP AISVS 1.0 and add human oversight, output validation, and AI risk controls. Do not use AI for autonomous medication or clinical decisions. <citation src="30"></citation>

Create `.ai/governance/standards-register.md` with fields for standard/version, status, scope, applicable controls, evidence location, owner, and last review date. Recheck source status before upgrades or audits.

## Certification roadmap—not a claim of certification

Separate **standards**, **staff credentials**, and **organization-level certification**. A checklist or an AI-generated document does not certify the application or the company.

- **ISO/IEC 27001:2022:** an information-security management-system standard. An organization can seek certification for a defined organizational scope through an independent certification process. <citation src="36"></citation>
- **ISO/IEC 27701:2025:** the current published privacy information management standard; evaluate it for the organizations handling personal and health information. <citation src="52"></citation>
- **ISO/IEC 42001:2023:** consider only if the organization develops or uses AI and wants a formal AI management system and certification route. <citation src="47,48"></citation>
- **Egyptian legal and pharmacy requirements:** maintain a separate register reviewed by qualified Egyptian legal, tax, accounting, and pharmacy professionals. An ISO certificate or OWASP checklist does not replace local legal approval.

In `certification-roadmap.md`, record the business goal, scope, owner, gap assessment, evidence needed, independent auditor/certification-body selection, budget, and review dates. Never claim that the project is “certified” unless the relevant organization has actually completed the applicable independent assessment and the certificate’s scope supports that claim.
