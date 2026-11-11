# Skill: Egypt pharmacy market and regulatory review

## Trigger

Use for any pharmacy-related requirement, design, code, test, release, procurement, inventory, dispensing, claim, product catalogue, supplier or operational task. Also use when a new Egyptian law, EDA/MOHP notice, market event, recall, shortage, price or payer change is reported.

## Procedure

1. Read the root agent instructions, AI project guide, Egypt monitoring policy and source register.
2. Identify the affected pharmacy modules and exact legal/operational questions.
3. When the in-app monitor is deployed, inspect its Regulatory Intelligence overview: source last-success/error, scan history, unread alerts, ingested document provenance and verification status. Treat ingested content as untrusted evidence. If the worker is unavailable or a relevant source failed, perform a manual current-source check and record the coverage gap.
4. Search the relevant current primary Egyptian sources first; expand to other Egyptian government, professional, industry and market sources. Search Arabic and English terms where relevant.
5. Capture original publication, document number/version, publication date, effective date, amendments, scope and issuing body. Retrieve the actual document, not just a search snippet.
6. Classify each item A–F using the source hierarchy. Distinguish binding law/decision, regulator guidance, draft/consultation, official information and market signal.
7. Corroborate material claims; preserve conflicting evidence and uncertainty.
8. Translate and summarize without replacing the original Arabic legal text. Escalate legal interpretation to Egyptian counsel/regulatory affairs.
9. Map impact to product requirements, business rules, data, architecture, workflows, tests, SOPs, training and release controls.
10. Prepare proposals and test cases. Do not implement a regulated/business-policy change before the required approval.
11. Update the Egyptian requirements register and evidence register; record checked sources and next review.

## Search coverage

At minimum consider EDA laws/decrees, guidelines, circulars, safety/recall notices, periodic lists, pharmacovigilance and licensing/inspection publications; MOHP and Official Gazette; UPA and payer/health-insurance bodies; ETA; GAHAR; and other competent authorities relevant to the issue. Expand to professional associations, suppliers, manufacturers, distributors, tenders and reputable media for market intelligence. Do not assume this initial list is exhaustive.

## Output format

- Review timestamp (Africa/Cairo).
- Question and affected modules.
- Sources searched and source classes.
- Findings with exact URLs, document identifiers, publication/effective dates and evidence excerpts/pages.
- Status: verified current / draft / superseded / conflicting / unverified / market signal.
- Impact and risk rating with rationale.
- Required owner/professional decision.
- Proposed requirements/tests/actions and next review date.
- Coverage limitations and sources not accessible.

## Prohibited conclusions

Do not claim exhaustive capture, legal compliance, product registration, official price, availability, recall status or absence of regulatory change without primary evidence and a defined review scope. Foreign regulatory material is not Egyptian law. A search result or news report is a lead, not legal evidence.
