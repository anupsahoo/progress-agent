# mt-061-bin-search-sort: Bin: Search and sort the list

| | |
|---|---|
| Module | Warehousing (wave 2) |
| Table | Bin |
| Legacy reference | `legacy/warehousing/bin_maint.p` |
| Priority | Medium |
| Type | Manual, UAT |

## Preconditions
- Signed in as a Warehousing user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open Warehousing > Bin.
2. Type `452` in Search.
3. Select the Warehouse Num column header twice.

## Expected result
Only matching rows show. The column sorts ascending, then descending.

## Traceability
- Field rules: WarehouseNum `zzzzzzzzz9`, Itemnum `zzzzzzzzz9`, Qty `->>>>9`, BinNum `zzzzzzzzz9`
