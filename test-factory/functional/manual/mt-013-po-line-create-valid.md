# mt-013-po-line-create-valid: POLine: Create a valid record

| | |
|---|---|
| Module | Purchasing (wave 2) |
| Table | POLine |
| Legacy reference | `legacy/purchasing/po_line_maint.p` |
| Priority | High |
| Type | Manual, UAT |

## Preconditions
- Signed in as a Purchasing user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open Purchasing > POLine maintenance.
2. Select New.
3. Enter Line Num: `1` (use a new key value for PONum, Linenum).
4. Enter Item Num: `3` (use a new key value for PONum, Linenum).
5. Enter Price: `16.55` (use a new key value for PONum, Linenum).
6. Enter Qty: `3` (use a new key value for PONum, Linenum).
7. Enter Discount: `0` (use a new key value for PONum, Linenum).
8. Enter Extended Price: `49.65` (use a new key value for PONum, Linenum).
9. Select Save.

## Expected result
The record saves, the banner shows "POLine saved." and it appears in the list.

## Traceability
- Field rules: Linenum `>>9`, Itemnum `zzzzzzzzz9`, Price `->,>>>,>>9.99`, Qty `->>>>9`
