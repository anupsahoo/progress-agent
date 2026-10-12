# mt-063-po-line-search-sort: POLine: Search and sort the list

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
1. Open Purchasing > POLine.
2. Type `Rec` in Search.
3. Select the Line Num column header twice.

## Expected result
Only matching rows show. The column sorts ascending, then descending.

## Traceability
- Field rules: Linenum `>>9`, Itemnum `zzzzzzzzz9`, Price `->,>>>,>>9.99`, Qty `->>>>9`
