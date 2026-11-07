# Legal-entity and operating-location register

- Status: **Provisional owner-provided structure — official record verification pending**
- Owner: business owner
- Reviewers: accountant and qualified Egyptian legal/tax adviser
- Last reviewed: 2026-11-07

## Purpose

Distinguish legal entities, operating sectors and physical branches. A sector, brand or branch is not a separate legal entity unless official records establish separate incorporation. Do not put full sensitive identifiers in public project documentation; use masked references and controlled evidence storage.

## Provisional entity register

| Field | LE-01 |
|---|---|
| Owner-provided company name | Special Group |
| Exact registered legal name | Pending official record; do not infer suffix or Arabic form |
| Legal form | Pending |
| Commercial-registration reference | Pending secure evidence |
| Tax/VAT reference | Pending secure evidence |
| Registered activities | Pending verification |
| Ownership / parent | Pending; no parent assumed |
| Status | Owner-reported active company; documentary verification pending |
| Accounting treatment | One statutory company framework, subject to accountant approval |

## Operating-sector map

| Sector code | Owner-provided sector name | Provisional legal entity | Separate operational controls/reports |
|---|---|---|---|
| SEC-PHA | Pharmacies Sector | LE-01 | Yes |
| SEC-CON | Specialized Contracting Sector | LE-01 | Yes |

The current statement indicates one company with two sectors. If either sector is in fact operated by a separately registered company, provide that company's official record and the map must be revised.

## Branch and site ownership schedule

Complete one row per pharmacy branch, warehouse, contracting office/site and stock-owning location. Exact sites and ownership are not yet supplied.

| Location code | Name/address reference | Operating sector | Legal owner code | Stock owner (if applicable) | Accounting dimension | Evidence |
|---|---|---|---|---|---|---|
| LOC-PENDING | Pending branch/site list | SEC-PHA / SEC-CON | LE-01 provisional | Pending | Branch / project / warehouse | Pending |

## Accounting-boundary output

Subject to official verification and accountant approval:
- one company-level statutory accounting framework for LE-01;
- sector-level subledgers/journals or posting dimensions for SEC-PHA and SEC-CON;
- separate sector reports, budgets, operational permissions and approvals;
- company-wide statutory reporting with traceable sector drill-down and reconciliation;
- one PostgreSQL database provisionally mapped to LE-01, not one per sector or branch.

## Approval gate

Business owner confirms facts and supplies the exact official company record and branch/site schedule. Accountant approves the statutory-versus-sector management accounting design and reconciliation. Qualified Egyptian legal/tax professionals verify legal identity, registered activities, licences and tax implications. Technical owner implements the approved mapping.

Do not finalize production database provisioning, tax profiles, statutory ledger configuration, opening balances or posting logic until these approvals are recorded.

Related: [business boundaries](business-boundaries.md), [accounting rules](accounting-rules.md), [ADR-0001](../decisions/ADR-0001-business-boundaries.md), [open questions](../memory/open-questions.md).
