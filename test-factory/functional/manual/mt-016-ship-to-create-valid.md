# mt-016-ship-to-create-valid: ShipTo: Create a valid record

| | |
|---|---|
| Module | Order Fulfilment (wave 3) |
| Table | ShipTo |
| Legacy reference | `legacy/order-fulfilment/ship_to_maint.p` |
| Priority | High |
| Type | Manual, UAT |

## Preconditions
- Signed in as a Order Fulfilment user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open Order Fulfilment > ShipTo maintenance.
2. Select New.
3. Enter Cust Num: `5` (use a new key value for CustNum, ShipToID).
4. Enter Ship To ID: `1` (use a new key value for CustNum, ShipToID).
5. Enter Contact: `Debbie Johnson` (use a new key value for CustNum, ShipToID).
6. Enter Address: `1234 4th Ave.` (use a new key value for CustNum, ShipToID).
7. Enter Address2: `` (use a new key value for CustNum, ShipToID).
8. Enter City: `Montgomery` (use a new key value for CustNum, ShipToID).
9. Select Save.

## Expected result
The record saves, the banner shows "ShipTo saved." and it appears in the list.

## Traceability
- Field rules: CustNum `>>>>9`, ShipToID `zzzzzzzzz9`, Contact `x(30)`, Address `x(35)`
