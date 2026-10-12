# Purchasing: requirements (EARS)

Extracted by FlowPilot from 39 legacy ABL programs (3,644 lines) in `legacy/purchasing/`.
Each requirement traces to the schema rule or program it came from. Reviewed by a person before merge.

## PurchaseOrder

> The purchaseorder table contains information pertaining to the purchase order including: PO number and status.

| ID | Requirement | Source |
|---|---|---|
| PO-R001 | The system shall list PurchaseOrder records with search by PO Status and sorting on every column. | `purchase_order_browse.w` |
| PO-R002 | When a user opens a PurchaseOrder, the system shall show every field read-only with its legacy label. | `purchase_order_inquiry.w` |
| PO-R003 | When a user saves a PurchaseOrder, the system shall identify it by PONum and reject a duplicate key. | primary index |
| PO-R004 | While another user has changed the same PurchaseOrder, the system shall reject the save and ask the user to reload. | `EXCLUSIVE-LOCK NO-WAIT` in `purchase_order_maint.p` |
| PO-R005 | If PO Num is not greater than 0, then the system shall reject the save with "PO number must be greater than zero". | VALEXP `ponum > 0` |
| PO-R006 | If Supplier ID does not match an existing Supplier, then the system shall reject the save with "Supplier must exist.". | VALEXP `CAN-FIND(supplier OF purchaseorder)` |
| PO-R007 | The system shall limit PO Status to 20 characters. | FORMAT x(n) |
| PO-R008 | When a PurchaseOrder is deleted, the system shall block the delete while other records still reference it and keep an audit record. | `trg/delete_purchase_order.p` |
| PO-R009 | When any PurchaseOrder field changes, the system shall record the old and new value with the user and time. | `trg/write_purchase_order.p` |

## POLine

> The poline table contains the PO detail information including the item and quantity on the PO.

| ID | Requirement | Source |
|---|---|---|
| PO-R010 | The system shall list POLine records with search by PO Line Status and sorting on every column. | `po_line_browse.w` |
| PO-R011 | When a user opens a POLine, the system shall show every field read-only with its legacy label. | `po_line_inquiry.w` |
| PO-R012 | When a user saves a POLine, the system shall identify it by PONum + Linenum and reject a duplicate key. | primary index |
| PO-R013 | While another user has changed the same POLine, the system shall reject the save and ask the user to reload. | `EXCLUSIVE-LOCK NO-WAIT` in `po_line_maint.p` |
| PO-R014 | If Item Num does not match an existing Item, then the system shall reject the save with "Item must be on file". | VALEXP `CAN-FIND(item OF poline)` |
| PO-R015 | If Order Num does not match an existing PurchaseOrder, then the system shall reject the save with "Purchase order must exist.". | VALEXP `can-find(purchaseorder of poline)` |
| PO-R016 | The system shall limit PO Line Status to 20 characters. | FORMAT x(n) |
| PO-R017 | When a POLine is deleted, the system shall block the delete while other records still reference it and keep an audit record. | `trg/delete_po_line.p` |
| PO-R018 | When any POLine field changes, the system shall record the old and new value with the user and time. | `trg/write_po_line.p` |

## Non-functional

| ID | Requirement |
|---|---|
| PO-R019 | The list endpoint shall answer within 300 ms at the 95th percentile for 50 concurrent users. |
| PO-R020 | All endpoints shall require an authenticated user and log access. |
| PO-R021 | No sample or test data shall contain real customer personal data. |
