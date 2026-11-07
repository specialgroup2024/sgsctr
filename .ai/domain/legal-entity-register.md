# Legal-entity and operating-location register

- Status: **Working register — no legal entity has been verified from repository evidence**
- Owner: business owner
- Reviewers: accountant and qualified Egyptian legal/tax adviser
- Last reviewed: 2026-11-07

## Purpose and rules

This register distinguishes operating domains, legal entities and physical branches. Do not treat a business name, brand, department, branch or group label as a registered legal entity without documentary evidence.

Every row must be supported by current official/company records and reviewed by the owner and relevant professionals. Do not place full sensitive identifiers in public project documentation; store controlled evidence securely and record a masked reference here.

## Initial discovery map

| Operating domain | Known from project brief | Legal entity | Current status |
|---|---|---|---|
| Specialist contracting | Contracting business exists | Not identified | Owner evidence required |
| Pharmacy group | Pharmacy group exists | One or more entities unknown | Owner evidence required |
| Holding/parent | Not established | Unknown / do not assume | Confirm whether one exists |

## Entity register

For each actual legal entity, complete:

| Field | Required value |
|---|---|
| Entity code | Stable internal code, e.g. LE-01 |
| Exact registered legal name | As shown on current official record |
| Legal form | As registered |
| Commercial-registration reference | Masked reference + secure evidence location |
| Tax/VAT reference | Masked reference + secure evidence location |
| Registered activity | As evidenced |
| Ownership / parent | Entity code(s), percentage and effective date; evidence required |
| Operating domain(s) | Contracting, pharmacy, holding/shared services, or other approved |
| Accounting currency / fiscal year | Accountant-confirmed |
| Status / effective dates | Active, inactive, planned; dates and evidence |
| Approval | Business owner, accountant, legal/tax reviewer and date |

## Branch and site ownership schedule

Complete one row per contracting site, pharmacy branch, warehouse and stock-owning location.

| Location code | Name/address reference | Operating activity | Legal owner/operator code | Stock owner (if applicable) | Books / branch dimension | Evidence |
|---|---|---|---|---|---|---|
| LOC-001 | Pending | Contracting / pharmacy / warehouse | Pending | Pending | Pending | Pending |

A location owned and operated by the same legal entity is normally represented as a branch/cost centre in that entity's books. A location operated by a separate incorporated entity is mapped to that entity's books. Confirm leases, licences, employment and stock ownership where these differ.

## Accounting-boundary output

After verification, approve a separate entity-to-books map containing:
- legal entity code and registered name;
- operating domain and owned locations;
- statutory ledger/database identifier;
- chart of accounts, currency, fiscal year and tax profile;
- bank/cash accounts and numbering series;
- authorized users and approval limits;
- intercompany counterparties and documented transaction types;
- consolidation/reporting requirements, if any.

## Approval gate

Do not finalize legal-entity count, create entity-specific production databases, configure tax profiles, open statutory ledgers, migrate opening balances or enable postings until the register and branch schedule are evidenced and approved. The business owner confirms facts; the accountant approves books and accounting treatment; qualified Egyptian legal/tax professionals verify legal and tax implications; the technical owner implements the approved topology.

Related: [business boundaries](business-boundaries.md), [accounting rules](accounting-rules.md), [ADR-0001](../decisions/ADR-0001-business-boundaries.md), [open questions](../memory/open-questions.md).
