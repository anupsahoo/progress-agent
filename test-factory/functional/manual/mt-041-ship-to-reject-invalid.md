# mt-041-ship-to-reject-invalid: ShipTo: Reject values that break the field rules

| | |
|---|---|
| Module | Order Fulfilment (wave 3) |
| Table | ShipTo |
| Legacy reference | `legacy/order-fulfilment/ship_to_maint.p` |
| Priority | Medium |
| Type | Manual, UAT |

## Preconditions
- Signed in as a Order Fulfilment user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open Order Fulfilment > ShipTo maintenance and open any record.
2. Enter Cust Num: `-1`.
3. Select Save.

## Expected result
Save is blocked and the field shows: "Customer must exist". Nothing is written.

## Traceability
- Field rules: CustNum `>>>>9`, ShipToID `zzzzzzzzz9`, Contact `x(30)`, Address `x(35)`
