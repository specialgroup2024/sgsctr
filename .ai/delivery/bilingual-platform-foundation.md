# Bilingual platform foundation

Status: initial implementation on feature branch; review and route-complete verification pending. This is a shared platform capability, not a business-domain decision.

## Requirement

Provide English (LTR) and Arabic (RTL) across the web application with a persistent user-selected locale. English is the initial default unless the user selects Arabic. The locale model must be reusable by future React Native clients.

## Design

- Root locale provider reads the same-site preference cookie on the server and applies document language and direction.
- Client language selector updates locale, root attributes and preference cookie.
- Shared translation catalogue maps presentation strings; missing translations fall back to English.
- Formatting helpers use en-GB or ar-EG. Currency formatting must receive an explicit ISO currency code.
- Business identifiers, API enums, database values, URLs, email addresses and regulatory evidence are not translated.
- RTL styles preserve LTR rendering for technical identifiers and mixed-direction content where appropriate.

## Required coverage

- Login, shared navigation, dashboard, organization workspace and sector landing pages.
- Pharmacy inventory: catalogue, approvals, test readiness, receiving, transfers, batches, expiry and reports.
- Regulatory intelligence: source records, scan history, alerts, document metadata and review states.
- Contracting, all forms, validation and errors.
- Dates, numbers, currency, accessibility labels, print/export and future mobile clients.

## Acceptance criteria

1. Switching EN/AR updates all active content without losing unsaved form state.
2. Preference survives refresh/navigation; server-rendered root has matching language and direction before hydration.
3. Arabic uses RTL layout and Arabic-capable font fallback; English uses LTR.
4. Identifiers, URLs, email, serials and code samples remain readable in mixed-direction content.
5. All user-facing strings have approved translations; untranslated keys are detectable.
6. Date/number formatting is locale-aware; currency uses explicit currency code.
7. Automated tests cover persistence, switching, root direction and dictionary coverage; manual visual checks cover desktop/mobile routes.
8. No API contract, stored business value, approval status or authentication policy changes as a side effect.

## Governance and open gates

- Technical implementation can establish locale infrastructure and translate ordinary application UI.
- Arabic legal, regulatory, clinical, pharmacy, quality, accounting and contractual wording requires qualified review.
- Full route coverage, accessibility, print/export and mobile integration remain test gates until evidenced.
- Authentication and Data Protection verification holds remain unchanged.


## Screen translation and responsive RTL increment

The follow-up implementation extends presentation translations to product catalogue, provisional product governance, pharmacist demo examples, inventory tabs and states, approval register, test readiness, regulatory intelligence and organization management. Persisted status codes, API values, identifiers and source evidence remain unchanged.

RTL styling uses logical borders and alignment, keeps technical identifiers and numeric inputs LTR, and protects narrow layouts from table overflow. CI runs Playwright against the authenticated inventory workspace at 1440px desktop and 390px mobile widths in both locales, checks root language/direction and horizontal overflow, and uploads screenshots as evidence.

Arabic domain wording remains provisional and requires qualified human review. This is responsive web verification, not a React Native localization claim. Authentication/Data Protection holds and all business approval gates remain unchanged.
