# mt-036-bin-reject-invalid: Bin: Reject values that break the field rules

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
1. Open Warehousing > Bin maintenance and open any record.
2. Enter Warehouse Num: `-1`.
3. Select Save.

## Expected result
Save is blocked and the field shows: "Warehouse must exist.". Nothing is written.

## Traceability
- Field rules: WarehouseNum `zzzzzzzzz9`, Itemnum `zzzzzzzzz9`, Qty `->>>>9`, BinNum `zzzzzzzzz9`
