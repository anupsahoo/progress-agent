# mt-011-bin-create-valid: Bin: Create a valid record

| | |
|---|---|
| Module | Warehousing (wave 2) |
| Table | Bin |
| Legacy reference | `legacy/warehousing/bin_maint.p` |
| Priority | High |
| Type | Manual, UAT |

## Preconditions
- Signed in as a Warehousing user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open Warehousing > Bin maintenance.
2. Select New.
3. Enter Warehouse Num: `1` (use a new key value for BinNum).
4. Enter Item Num: `1` (use a new key value for BinNum).
5. Enter Qty: `9304` (use a new key value for BinNum).
6. Enter Bin Num: `716` (use a new key value for BinNum).
7. Enter Bin Name: `452917-D` (use a new key value for BinNum).
8. Select Save.

## Expected result
The record saves, the banner shows "Bin saved." and it appears in the list.

## Traceability
- Field rules: WarehouseNum `zzzzzzzzz9`, Itemnum `zzzzzzzzz9`, Qty `->>>>9`, BinNum `zzzzzzzzz9`
