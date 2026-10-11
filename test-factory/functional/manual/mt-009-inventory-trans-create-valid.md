# mt-009-inventory-trans-create-valid: InventoryTrans: Create a valid record

| | |
|---|---|
| Module | Inventory (wave 2) |
| Table | InventoryTrans |
| Legacy reference | `legacy/inventory/inventory_trans_maint.p` |
| Priority | High |
| Type | Manual, UAT |

## Preconditions
- Signed in as a Inventory user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open Inventory > InventoryTrans maintenance.
2. Select New.
3. Enter Inventory Trans Num: `81` (use a new key value for InvTransNum).
4. Enter Warehouse Num: `1` (use a new key value for InvTransNum).
5. Enter Bin Num: `760` (use a new key value for InvTransNum).
6. Enter Qty: `5` (use a new key value for InvTransNum).
7. Enter Item Num: `45` (use a new key value for InvTransNum).
8. Enter Trans Date: `1998-07-29` (use a new key value for InvTransNum).
9. Select Save.

## Expected result
The record saves, the banner shows "InventoryTrans saved." and it appears in the list.

## Traceability
- Field rules: InvTransNum `zzzzzzzzz9`, WarehouseNum `zzzzzzzzz9`, BinNum `zzzzzzzzz9`, Qty `->>>>9`
