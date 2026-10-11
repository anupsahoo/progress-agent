# mt-010-warehouse-create-valid: Warehouse: Create a valid record

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
1. Open Warehousing > Warehouse maintenance.
2. Select New.
3. Enter Warehouse Num: `1` (use a new key value for WarehouseNum).
4. Enter Warehouse Name: `Northeast  USA` (use a new key value for WarehouseNum).
5. Enter Country: `USA` (use a new key value for WarehouseNum).
6. Enter Address: `27 Oak Park` (use a new key value for WarehouseNum).
7. Enter Address2: `` (use a new key value for WarehouseNum).
8. Enter City: `Bedford` (use a new key value for WarehouseNum).
9. Select Save.

## Expected result
The record saves, the banner shows "Warehouse saved." and it appears in the list.

## Traceability
- Field rules: WarehouseNum `zzzzzzzzz9`, WarehouseName `x(30)`, Country `x(20)`, Address `x(35)`
