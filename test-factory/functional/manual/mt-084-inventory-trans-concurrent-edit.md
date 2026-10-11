# mt-084-inventory-trans-concurrent-edit: InventoryTrans: Two users edit the same record

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
1. Sign in as user A and user B in two browsers.
2. Both open InventoryTrans InvTransNum=81 and select Edit.
3. User A changes a field and saves.
4. User B changes a field and saves.

## Expected result
User A saves. User B sees "changed by someone else. Reload and try again." No update is lost.

## Traceability
- Field rules: InvTransNum `zzzzzzzzz9`, WarehouseNum `zzzzzzzzz9`, BinNum `zzzzzzzzz9`, Qty `->>>>9`
