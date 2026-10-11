# mt-034-inventory-trans-reject-invalid: InventoryTrans: Reject values that break the field rules

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
1. Open Inventory > InventoryTrans maintenance and open any record.
2. Enter Item Num: `-1`.
3. Select Save.

## Expected result
Save is blocked and the field shows: "Item must be on file.". Nothing is written.

## Traceability
- Field rules: InvTransNum `zzzzzzzzz9`, WarehouseNum `zzzzzzzzz9`, BinNum `zzzzzzzzz9`, Qty `->>>>9`
