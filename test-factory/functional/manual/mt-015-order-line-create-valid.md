# mt-015-order-line-create-valid: OrderLine: Create a valid record

| | |
|---|---|
| Module | Order Entry (wave 3) |
| Table | OrderLine |
| Legacy reference | `legacy/order-entry/order_line_maint.p` |
| Priority | High |
| Type | Manual, UAT |

## Preconditions
- Signed in as a Order Entry user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open Order Entry > OrderLine maintenance.
2. Select New.
3. Enter Order Num: `1` (use a new key value for Ordernum, Linenum).
4. Enter Line Num: `1` (use a new key value for Ordernum, Linenum).
5. Enter Item Num: `54` (use a new key value for Ordernum, Linenum).
6. Enter Price: `4.86` (use a new key value for Ordernum, Linenum).
7. Enter Qty: `30` (use a new key value for Ordernum, Linenum).
8. Enter Discount: `10` (use a new key value for Ordernum, Linenum).
9. Select Save.

## Expected result
The record saves, the banner shows "OrderLine saved." and it appears in the list.

## Traceability
- Field rules: Ordernum `zzzzzzzzz9`, Linenum `>>9`, Itemnum `zzzzzzzzz9`, Price `->,>>>,>>9.99`
