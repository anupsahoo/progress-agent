# mt-039-order-reject-invalid: Order: Reject values that break the field rules

| | |
|---|---|
| Module | Order Entry (wave 3) |
| Table | Order |
| Legacy reference | `legacy/order-entry/order_maint.p` |
| Priority | Medium |
| Type | Manual, UAT |

## Preconditions
- Signed in as a Order Entry user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open Order Entry > Order maintenance and open any record.
2. Enter Order Num: `0`.
3. Select Save.

## Expected result
Save is blocked and the field shows: "Order number must be greater than zero". Nothing is written.

## Traceability
- Field rules: Ordernum `zzzzzzzzz9`, CustNum `>>>>9`, OrderDate `99/99/99`, ShipDate `99/99/9999`
