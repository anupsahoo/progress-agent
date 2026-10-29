# mt-038-po-line-reject-invalid: POLine: Reject values that break the field rules

| | |
|---|---|
| Module | Purchasing (wave 2) |
| Table | POLine |
| Legacy reference | `legacy/purchasing/po_line_maint.p` |
| Priority | Medium |
| Type | Manual, UAT |

## Preconditions
- Signed in as a Purchasing user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open Purchasing > POLine maintenance and open any record.
2. Enter Item Num: `-1`.
3. Select Save.

## Expected result
Save is blocked and the field shows: "Item must be on file". Nothing is written.

## Traceability
- Field rules: Linenum `>>9`, Itemnum `zzzzzzzzz9`, Price `->,>>>,>>9.99`, Qty `->>>>9`
