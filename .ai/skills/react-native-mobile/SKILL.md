---
name: react-native-mobile
description: Plan or implement the future SGSCTR React Native client and its secure API integration.
---

# Current status
React Native is the owner-stated mobile direction, but the inspected repository context does not evidence an implemented mobile application/toolchain. Treat this as a future-client workflow, not proof of a mobile project.

# Workflow
1. Confirm the mobile work package and inspect repository state for an actual app, supported React Native version and native toolchains.
2. Reuse approved API contracts and shared identity/session design; never connect directly to PostgreSQL.
3. Define navigation, accessibility, Arabic/English localization, RTL/LTR, offline behavior and synchronization before implementation.
4. Threat-model local storage, credentials/tokens, device compromise, network transport, deep links and sensitive-data exposure.
5. Apply relevant OWASP MASVS controls and create device/platform-specific tests.
6. Verify API authorization independently of client UI; test session expiry, denial, retry and connectivity loss.
7. Document build signing, secrets, release, crash reporting and support controls.

# Guardrails
- Do not invent offline requirements or cache patient/health data without approval.
- Do not place secrets in the app bundle.
- Do not claim mobile implementation or MASVS verification until evidenced.

# References
See architecture/system-context.md, security/identity-access-baseline.md and governance/standards-register.md.
