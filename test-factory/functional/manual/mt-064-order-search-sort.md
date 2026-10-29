# mt-064-order-search-sort: Order: Search and sort the list

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
1. Open Order Entry > Order.
2. Type `Fly` in Search.
3. Select the Order Num column header twice.

## Expected result
Only matching rows show. The column sorts ascending, then descending.

## Traceability
- Field rules: Ordernum `zzzzzzzzz9`, CustNum `>>>>9`, OrderDate `99/99/99`, ShipDate `99/99/9999`
