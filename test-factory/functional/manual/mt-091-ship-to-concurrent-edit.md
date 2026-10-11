# mt-091-ship-to-concurrent-edit: ShipTo: Two users edit the same record

| | |
|---|---|
| Module | Order Fulfilment (wave 3) |
| Table | ShipTo |
| Legacy reference | `legacy/order-fulfilment/ship_to_maint.p` |
| Priority | High |
| Type | Manual, UAT |

## Preconditions
- Signed in as a Order Fulfilment user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Sign in as user A and user B in two browsers.
2. Both open ShipTo CustNum=5, ShipToID=1 and select Edit.
3. User A changes a field and saves.
4. User B changes a field and saves.

## Expected result
User A saves. User B sees "changed by someone else. Reload and try again." No update is lost.

## Traceability
- Field rules: CustNum `>>>>9`, ShipToID `zzzzzzzzz9`, Contact `x(30)`, Address `x(35)`
