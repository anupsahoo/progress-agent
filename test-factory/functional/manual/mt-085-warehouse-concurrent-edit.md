# mt-085-warehouse-concurrent-edit: Warehouse: Two users edit the same record

| | |
|---|---|
| Module | Warehousing (wave 2) |
| Table | Warehouse |
| Legacy reference | `legacy/warehousing/warehouse_maint.p` |
| Priority | High |
| Type | Manual, UAT |

## Preconditions
- Signed in as a Warehousing user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Sign in as user A and user B in two browsers.
2. Both open Warehouse WarehouseNum=1 and select Edit.
3. User A changes a field and saves.
4. User B changes a field and saves.

## Expected result
User A saves. User B sees "changed by someone else. Reload and try again." No update is lost.

## Traceability
- Field rules: WarehouseNum `zzzzzzzzz9`, WarehouseName `x(30)`, Country `x(20)`, Address `x(35)`
