# mt-014-order-create-valid: Order: Create a valid record

| | |
|---|---|
| Module | Order Entry (wave 3) |
| Table | Order |
| Legacy reference | `legacy/order-entry/order_maint.p` |
| Priority | High |
| Type | Manual, UAT |

## Preconditions
- Signed in as a Order Entry user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open Order Entry > Order maintenance.
2. Select New.
3. Enter Order Num: `1` (use a new key value for Ordernum).
4. Enter Cust Num: `53` (use a new key value for Ordernum).
5. Enter Ordered: `1998-01-26` (use a new key value for Ordernum).
6. Enter Shipped: `1998-01-31` (use a new key value for Ordernum).
7. Enter Promised: `1998-01-31` (use a new key value for Ordernum).
8. Enter Carrier: `FlyByNight Courier` (use a new key value for Ordernum).
9. Select Save.

## Expected result
The record saves, the banner shows "Order saved." and it appears in the list.

## Traceability
- Field rules: Ordernum `zzzzzzzzz9`, CustNum `>>>>9`, OrderDate `99/99/99`, ShipDate `99/99/9999`
