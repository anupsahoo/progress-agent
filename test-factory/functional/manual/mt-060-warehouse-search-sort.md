# mt-060-warehouse-search-sort: Warehouse: Search and sort the list

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
1. Open Warehousing > Warehouse.
2. Type `Nor` in Search.
3. Select the Warehouse Num column header twice.

## Expected result
Only matching rows show. The column sorts ascending, then descending.

## Traceability
- Field rules: WarehouseNum `zzzzzzzzz9`, WarehouseName `x(30)`, Country `x(20)`, Address `x(35)`
