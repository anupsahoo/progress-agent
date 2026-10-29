# mt-035-warehouse-reject-invalid: Warehouse: Reject values that break the field rules

| | |
|---|---|
| Module | Warehousing (wave 2) |
| Table | Warehouse |
| Legacy reference | `legacy/warehousing/warehouse_maint.p` |
| Priority | Medium |
| Type | Manual, UAT |

## Preconditions
- Signed in as a Warehousing user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open Warehousing > Warehouse maintenance and open any record.
2. Enter Warehouse Num: `0`.
3. Select Save.

## Expected result
Save is blocked and the field shows: "Entrer a number greater than zero". Nothing is written.

## Traceability
- Field rules: WarehouseNum `zzzzzzzzz9`, WarehouseName `x(30)`, Country `x(20)`, Address `x(35)`
