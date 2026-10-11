# mt-037-purchase-order-reject-invalid: PurchaseOrder: Reject values that break the field rules

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
1. Open Purchasing > PurchaseOrder maintenance and open any record.
2. Enter PO Num: `0`.
3. Select Save.

## Expected result
Save is blocked and the field shows: "PO number must be greater than zero". Nothing is written.

## Traceability
- Field rules: PONum `zzzzzzzzz9`, DateEntered `99/99/9999`, SupplierIDNum `zzzzzzzzz9`, ReceiveDate `99/99/9999`
