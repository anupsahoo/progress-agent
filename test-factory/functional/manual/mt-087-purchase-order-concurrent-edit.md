# mt-087-purchase-order-concurrent-edit: PurchaseOrder: Two users edit the same record

| | |
|---|---|
| Module | Purchasing (wave 2) |
| Table | PurchaseOrder |
| Legacy reference | `legacy/purchasing/purchase_order_maint.p` |
| Priority | High |
| Type | Manual, UAT |

## Preconditions
- Signed in as a Purchasing user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Sign in as user A and user B in two browsers.
2. Both open PurchaseOrder PONum=8001 and select Edit.
3. User A changes a field and saves.
4. User B changes a field and saves.

## Expected result
User A saves. User B sees "changed by someone else. Reload and try again." No update is lost.

## Traceability
- Field rules: PONum `zzzzzzzzz9`, DateEntered `99/99/9999`, SupplierIDNum `zzzzzzzzz9`, ReceiveDate `99/99/9999`
