# mt-066-ship-to-search-sort: ShipTo: Search and sort the list

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
1. Open Order Fulfilment > ShipTo.
2. Type `Deb` in Search.
3. Select the Cust Num column header twice.

## Expected result
Only matching rows show. The column sorts ascending, then descending.

## Traceability
- Field rules: CustNum `>>>>9`, ShipToID `zzzzzzzzz9`, Contact `x(30)`, Address `x(35)`
