# Supplier Management: requirements (EARS)

Extracted by FlowPilot from 38 legacy ABL programs (3,860 lines) in `legacy/supplier-management/`.
Each requirement traces to the schema rule or program it came from. Reviewed by a person before merge.

## Supplier

> The supplier table contains a supplier's name, address and additional information pertaining to the supplier.

| ID | Requirement | Source |
|---|---|---|
| SM-R001 | The system shall list Supplier records with search by Name, Address, Address2 and sorting on every column. | `supplier_browse.w` |
| SM-R002 | When a user opens a Supplier, the system shall show every field read-only with its legacy label. | `supplier_inquiry.w` |
| SM-R003 | When a user saves a Supplier, the system shall identify it by SupplierIDNum and reject a duplicate key. | primary index |
| SM-R004 | While another user has changed the same Supplier, the system shall reject the save and ask the user to reload. | `EXCLUSIVE-LOCK NO-WAIT` in `supplier_maint.p` |
| SM-R005 | If Supplier ID is not greater than 0, then the system shall reject the save with "Supplier number must be greater than zero". | VALEXP `supplier.SupplierIDnum > 0` |
| SM-R006 | If Discount is not at least 0, then the system shall reject the save with "Discount must be greater or equal to 0". | VALEXP `Discount >= 0` |
| SM-R007 | The system shall limit Name to 30, Address to 35, Address2 to 35, City to 25 characters. | FORMAT x(n) |
| SM-R008 | When a Supplier is deleted, the system shall block the delete while other records still reference it and keep an audit record. | `trg/delete_supplier.p` |
| SM-R009 | When any Supplier field changes, the system shall record the old and new value with the user and time. | `trg/write_supplier.p` |

## SupplierItemXref

> The supplieritemxref lists all of the items that are supplied by a particlar supplier.

| ID | Requirement | Source |
|---|---|---|
| SM-R010 | The system shall list SupplierItemXref records with search by key and sorting on every column. | `supplier_item_xref_browse.w` |
| SM-R011 | When a user opens a SupplierItemXref, the system shall show every field read-only with its legacy label. | `supplier_item_xref_inquiry.w` |
| SM-R012 | When a user saves a SupplierItemXref, the system shall identify it by SupplierIDNum + Itemnum and reject a duplicate key. | primary index |
| SM-R013 | While another user has changed the same SupplierItemXref, the system shall reject the save and ask the user to reload. | `EXCLUSIVE-LOCK NO-WAIT` in `supplier_item_xref_maint.p` |
| SM-R014 | If Supplier ID does not match an existing Supplier, then the system shall reject the save with "Supplier must exist.". | VALEXP `CAN-FIND(supplier OF supplieritemxref)` |
| SM-R015 | If Item # does not match an existing Item, then the system shall reject the save with "Item must be on file.". | VALEXP `CAN-FIND(item OF supplieritemxref)` |
| SM-R016 | When a SupplierItemXref is deleted, the system shall block the delete while other records still reference it and keep an audit record. | `trg/delete_supplier_item_xref.p` |
| SM-R017 | When any SupplierItemXref field changes, the system shall record the old and new value with the user and time. | `trg/write_supplier_item_xref.p` |

## Non-functional

| ID | Requirement |
|---|---|
| SM-R018 | The list endpoint shall answer within 300 ms at the 95th percentile for 50 concurrent users. |
| SM-R019 | All endpoints shall require an authenticated user and log access. |
| SM-R020 | No sample or test data shall contain real customer personal data. |
