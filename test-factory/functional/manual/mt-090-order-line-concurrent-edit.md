# mt-090-order-line-concurrent-edit: OrderLine: Two users edit the same record

| | |
|---|---|
| Module | Order Entry (wave 3) |
| Table | OrderLine |
| Legacy reference | `legacy/order-entry/order_line_maint.p` |
| Priority | High |
| Type | Manual, UAT |

## Preconditions
- Signed in as a Order Entry user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Sign in as user A and user B in two browsers.
2. Both open OrderLine Ordernum=1, Linenum=1 and select Edit.
3. User A changes a field and saves.
4. User B changes a field and saves.

## Expected result
User A saves. User B sees "changed by someone else. Reload and try again." No update is lost.

## Traceability
- Field rules: Ordernum `zzzzzzzzz9`, Linenum `>>9`, Itemnum `zzzzzzzzz9`, Price `->,>>>,>>9.99`
