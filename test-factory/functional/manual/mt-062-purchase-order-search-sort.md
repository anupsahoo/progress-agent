# mt-062-purchase-order-search-sort: PurchaseOrder: Search and sort the list

| | |
|---|---|
| Module | Purchasing (wave 2) |
| Table | PurchaseOrder |
| Legacy reference | `legacy/purchasing/purchase_order_maint.p` |
| Priority | Medium |
| Type | Manual, UAT |

## Preconditions
- Signed in as a Purchasing user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open Purchasing > PurchaseOrder.
2. Type `Rec` in Search.
3. Select the PO Num column header twice.

## Expected result
Only matching rows show. The column sorts ascending, then descending.

## Traceability
- Field rules: PONum `zzzzzzzzz9`, DateEntered `99/99/9999`, SupplierIDNum `zzzzzzzzz9`, ReceiveDate `99/99/9999`
