# mt-040-order-line-reject-invalid: OrderLine: Reject values that break the field rules

| | |
|---|---|
| Module | Order Entry (wave 3) |
| Table | OrderLine |
| Legacy reference | `legacy/order-entry/order_line_maint.p` |
| Priority | Medium |
| Type | Manual, UAT |

## Preconditions
- Signed in as a Order Entry user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open Order Entry > OrderLine maintenance and open any record.
2. Enter Order Num: `-1`.
3. Select Save.

## Expected result
Save is blocked and the field shows: "Order must exist". Nothing is written.

## Traceability
- Field rules: Ordernum `zzzzzzzzz9`, Linenum `>>9`, Itemnum `zzzzzzzzz9`, Price `->,>>>,>>9.99`
