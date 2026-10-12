# mt-088-po-line-concurrent-edit: POLine: Two users edit the same record

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
1. Sign in as user A and user B in two browsers.
2. Both open POLine PONum=8001, Linenum=1 and select Edit.
3. User A changes a field and saves.
4. User B changes a field and saves.

## Expected result
User A saves. User B sees "changed by someone else. Reload and try again." No update is lost.

## Traceability
- Field rules: Linenum `>>9`, Itemnum `zzzzzzzzz9`, Price `->,>>>,>>9.99`, Qty `->>>>9`
