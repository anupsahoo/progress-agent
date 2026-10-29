# mt-058-item-search-sort: Item: Search and sort the list

| | |
|---|---|
| Module | Inventory (wave 2) |
| Table | Item |
| Legacy reference | `legacy/inventory/item_maint.p` |
| Priority | Medium |
| Type | Manual, UAT |

## Preconditions
- Signed in as a Inventory user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open Inventory > Item.
2. Type `Fin` in Search.
3. Select the Item Num column header twice.

## Expected result
Only matching rows show. The column sorts ascending, then descending.

## Traceability
- Field rules: Itemnum `zzzzzzzzz9`, ItemName `x(25)`, Price `->,>>>,>>9.99`, Onhand `->>>>9`
