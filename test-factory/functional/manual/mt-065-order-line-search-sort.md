# mt-065-order-line-search-sort: OrderLine: Search and sort the list

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
1. Open Order Entry > OrderLine.
2. Type `Shi` in Search.
3. Select the Order Num column header twice.

## Expected result
Only matching rows show. The column sorts ascending, then descending.

## Traceability
- Field rules: Ordernum `zzzzzzzzz9`, Linenum `>>9`, Itemnum `zzzzzzzzz9`, Price `->,>>>,>>9.99`
