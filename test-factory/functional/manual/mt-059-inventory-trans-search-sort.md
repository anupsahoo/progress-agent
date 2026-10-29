# mt-059-inventory-trans-search-sort: InventoryTrans: Search and sort the list

| | |
|---|---|
| Module | Inventory (wave 2) |
| Table | InventoryTrans |
| Legacy reference | `legacy/inventory/inventory_trans_maint.p` |
| Priority | Medium |
| Type | Manual, UAT |

## Preconditions
- Signed in as a Inventory user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open Inventory > InventoryTrans.
2. Type `Rec` in Search.
3. Select the Inventory Trans Num column header twice.

## Expected result
Only matching rows show. The column sorts ascending, then descending.

## Traceability
- Field rules: InvTransNum `zzzzzzzzz9`, WarehouseNum `zzzzzzzzz9`, BinNum `zzzzzzzzz9`, Qty `->>>>9`
