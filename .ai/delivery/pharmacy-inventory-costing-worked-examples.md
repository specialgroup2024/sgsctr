# Pharmacy inventory — moving weighted-average worked examples

- Version: 0.1, prepared 2026-11-14.
- Status: **Illustrative arithmetic only; no costing policy approved.**
- Currency: EGP. Synthetic values; no real supplier, medicine or transaction data.
- Scope: demonstrate choices the pharmacist and accountant must decide. Excludes VAT, tax, discounts, freight, rebates, financing, impairment and GL postings unless explicitly stated.

## 1. Common example data

Assume one stock item and one location, with no lot restrictions for this arithmetic example:

- Opening stock: 100 units at EGP 10.00 = EGP 1,000.00.
- Purchase receipt: 50 units at EGP 12.00 = EGP 600.00.
- Quantity after receipt: 150 units.
- Total carrying amount: EGP 1,600.00.
- Moving weighted average after receipt: 1,600 / 150 = **EGP 10.6666667 per unit**.

If 20 units are issued at this average:
- Remaining quantity: 130 units.
- Remaining inventory value: 130 × 10.6666667 = **EGP 1,386.67** (illustrative rounding).

If a later receipt adds 20 units at EGP 11.00:
- New value: 1,386.67 + 220.00 = EGP 1,606.67.
- New quantity: 150.
- New moving average: 1,606.67 / 150 = **EGP 10.7111333**.

Question for accountant: which receipt costs are included in inventory cost, and at what point is the average recalculated?

## 2. Supplier return — two treatments to approve

Starting point: after the first receipt and 20-unit issue, 130 units carry EGP 1,386.67; current average is EGP 10.6666667. Return 5 units from the 50-unit purchase originally invoiced at EGP 12.00.

| Treatment | Return value | Remaining quantity | Remaining value | Indicative new average |
|---|---:|---:|---:|---:|
| A — original receipt/invoice cost | 5 × 12 = 60.00 | 125 | 1,326.67 | 10.613336 |
| B — current moving average | 5 × 10.6666667 = 53.33 | 125 | 1,333.34 | 10.666672 |

The owner's earlier preference was recorded as **purchase returns: original**, but it remains proposed and unapproved. Confirm whether “original” means invoice unit price, lot's capitalized landed cost, or another basis; also define returns after partial issue or mixed-cost receipt.

## 3. Transfer between two locations — costing pool decision

Assume Location A has 130 units at EGP 10.6666667 (EGP 1,386.67). Location B has 40 units at EGP 9.00 (EGP 360.00). Transfer 30 units from A to B.

- Source carrying value at A's current average: 30 × 10.6666667 = EGP 320.00.
- A after dispatch: 100 units, EGP 1,066.67.
- If B receives at source carrying value and uses a **location-level** moving average: (EGP 360 + EGP 320) / 70 = **EGP 9.7142857** per unit.
- If cost is pooled at sector level, a transfer between locations does not change the sector's total quantity or total value; the pool remains 170 units and EGP 1,706.67, average **EGP 10.0392357** per unit.

These are alternative models, not recommendations. Decide whether the average pool is per legal entity, sector, location, item, or another approved dimension; define transit valuation and whether source cost is carried unchanged.

## 4. Partial receipt and in-transit valuation

Assume 10 units are dispatched from A and only 7 are accepted at B:
- 7 units move into B's accepted stock.
- 3 units remain explicitly in transit or in a controlled discrepancy state.
- No silent loss or automatic write-off is permitted by this example.
- If source average is EGP 10.6666667, the illustrative value associated with the 3 outstanding units is EGP 32.00.

Accountant and operations must decide whether the 3 units remain valued as in-transit inventory, are held in a transfer-clearing bucket, and how shortage/damage resolution changes valuation.

## 5. Expiry, damage and adjustment example

At EGP 10.6666667 average, a confirmed 4-unit write-off has an indicative inventory value of EGP 42.67. This arithmetic does not decide the expense account, tax deductibility, approval authority, destruction evidence, supplier recovery or period treatment. Quality disposition must precede any quantity/valuation adjustment.

## 6. Policy questions for signed approval

1. Cost pool: entity, sector, location, item, lot or combination?
2. Average recalculation: receipt posting, invoice match, landed-cost adjustment or another event?
3. Which cost components are capitalized? How are VAT, freight, discounts, rebates and credit notes handled?
4. Supplier return: original invoice/lot cost (owner preference under review), current average or other rule?
5. Transfer: source average, sector average, or another basis? When is cost transferred: dispatch or receipt?
6. Partial receipt, in-transit, shortage, overage, damage, return-to-source and emergency transfer valuation?
7. Expiry, breakage, loss, recall, count variance, adjustment, reversal and negative-stock treatment?
8. Precision, rounding stage, currency, period close, backdated transaction and recalculation policy?
9. Opening stock: quantity and value evidence, legacy method, lot-level valuation and cutover reconciliation?
10. Are inventory valuation reports separate from general-ledger posting? What are the reconciliation controls?

## 7. Approval record (blank)

- Business owner: ____________________ Date: __________
- Licensed pharmacist / pharmacy operations: ____________________ Date: __________
- Accountant: ____________________ Date: __________
- Regulatory/legal reviewer (where applicable): ____________________ Date: __________
- Approved policy/ADR reference and effective date: ____________________

Until completed and reviewed, these examples are not production calculations. No inventory valuation, financial posting, migration or stock movement is authorized.
