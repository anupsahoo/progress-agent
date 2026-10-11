# mt-012-purchase-order-create-valid: PurchaseOrder: Create a valid record

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
1. Open Purchasing > PurchaseOrder maintenance.
2. Select New.
3. Enter PO Num: `8001` (use a new key value for PONum).
4. Enter Date Entered: `1998-05-05` (use a new key value for PONum).
5. Enter Supplier ID: `1` (use a new key value for PONum).
6. Enter Date Received: `1998-07-29` (use a new key value for PONum).
7. Enter PO Status: `Received` (use a new key value for PONum).
8. Select Save.

## Expected result
The record saves, the banner shows "PurchaseOrder saved." and it appears in the list.

## Traceability
- Field rules: PONum `zzzzzzzzz9`, DateEntered `99/99/9999`, SupplierIDNum `zzzzzzzzz9`, ReceiveDate `99/99/9999`
