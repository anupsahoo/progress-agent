# mt-086-bin-concurrent-edit: Bin: Two users edit the same record

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
1. Sign in as user A and user B in two browsers.
2. Both open Bin BinNum=716 and select Edit.
3. User A changes a field and saves.
4. User B changes a field and saves.

## Expected result
User A saves. User B sees "changed by someone else. Reload and try again." No update is lost.

## Traceability
- Field rules: WarehouseNum `zzzzzzzzz9`, Itemnum `zzzzzzzzz9`, Qty `->>>>9`, BinNum `zzzzzzzzz9`
