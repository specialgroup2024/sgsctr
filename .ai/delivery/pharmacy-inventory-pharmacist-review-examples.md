# Pharmacist review examples — proposed/demo only

Status: **Illustrative examples only — not professional approval, not real reviewer records, and not part of the authoritative approval register.**
Recorded from owner-supplied examples on 2026-11-15. No identity, licence, qualification, authorization letter, checklist or assessment report has been independently verified.

## Separation from the real approval gate

- The authoritative approval is **INV-PRO-001 — Pharmacist / pharmacy operations: Pending**.
- The examples below are preserved to demonstrate the information a future review record may contain.
- They must never be counted as approvals, used to authorize pharmacy operations, or treated as evidence that the referenced documents exist.
- The identifiers beginning `DEMO` are example references only. No files for the referenced evidence were supplied with these examples.
- The rejection example is an alternative scenario, not a second decision on the same review.

## Example A — illustrative conditional-approval scenario

| Field | Owner-supplied demo value |
|---|---|
| Decision date | 15 November 2026 |
| Review ID | REV-DEMO-2026-015 |
| Workflow version | WF-V1.4 |
| Conditions | Staff must complete medication safety refresher training. |
| Supporting evidence references | EVD-DEMO-001, EVD-DEMO-002, EVD-DEMO-003 |
| Reviewer confirmation | Digitally acknowledged – Demo only |

### Referenced evidence — identifiers only, documents not supplied

1. **EVD-DEMO-001** — Professional qualification certificate.
2. **EVD-DEMO-002** — Pharmacist registration/license record.
3. **EVD-DEMO-003** — Pharmacy workflow review authorization letter.
4. **EVD-DEMO-004** — Workflow review checklist.
5. **EVD-DEMO-005** — Medication safety assessment report.

The example lists EVD-DEMO-001 to EVD-DEMO-003 as the supporting evidence references in its summary, and additionally describes EVD-DEMO-004 and EVD-DEMO-005 below. This is preserved as supplied; the evidence set is not reconciled or verified.

## Example B — alternative illustrative rejection scenario

Every value in this example is explicitly labelled **Demo value** in the supplied material. The named reviewer and identifiers are not verified people or credentials.

| Field | Owner-supplied demo value |
|---|---|
| Reviewer | Dr. Sara Mohamed Ali |
| Job title | Responsible Pharmacist |
| License number | EGY-PH-DEMO-00952 |
| Pharmacy | Nile Care Pharmacy |
| Authorization | AUTH-DEMO-2026-018 |
| Decision | **REJECT** |
| Decision date | 15 November 2026 |
| Reason | Insufficient evidence of prescription verification controls |
| Conditions / required follow-up | Correct identified workflow gaps and submit updated evidence |
| Supporting evidence references | REJ-EVD-DEMO-001, REJ-EVD-DEMO-002 |

This is a rejection example only. It does not establish that the named reviewer, pharmacy, licence, authorization or evidence exists.

## Required handling

- Keep both examples outside the `GovernanceApprovals` table and outside the real approval API response.
- The UI may show them only in a visually and textually separate **Illustrative demo examples — not approvals** section.
- Do not create a real user account, pharmacist role, licence record or reviewer identity from these examples.
- Do not change INV-PRO-001 from Pending based on either example.
- A real decision requires the actual pharmacist's verified identity, current qualification/licence evidence, delegated review authority, explicit decision, date, scope, conditions and actual supporting documents, followed by the required owner/governance process.

## Source and change history

Source: owner-supplied text in the conversation dated 2026-11-15. The wording and demo identifiers are preserved as supplied, with explicit provenance and safety qualification. No regulatory or clinical conclusion is made by this record.
