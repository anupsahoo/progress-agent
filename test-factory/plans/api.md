# API tests

Planned: **100** · Created in this pull request: **100** · Folder: `test-factory/functional/api/`

The test plan is the single source of truth: the count planned is the count created.

| # | Case | Module | Table |
|---|---|---|---|
| 1 | `api-001-customer-list-200` | Customer Management | Customer |
| 2 | `api-002-feedback-list-200` | Customer Management | Feedback |
| 3 | `api-003-salesrep-list-200` | Sales & Territories | Salesrep |
| 4 | `api-004-state-list-200` | Sales & Territories | State |
| 5 | `api-005-local-default-list-200` | Sales & Territories | LocalDefault |
| 6 | `api-006-supplier-list-200` | Supplier Management | Supplier |
| 7 | `api-007-supplier-item-xref-list-200` | Supplier Management | SupplierItemXref |
| 8 | `api-008-item-list-200` | Inventory | Item |
| 9 | `api-009-inventory-trans-list-200` | Inventory | InventoryTrans |
| 10 | `api-010-warehouse-list-200` | Warehousing | Warehouse |
| 11 | `api-011-bin-list-200` | Warehousing | Bin |
| 12 | `api-012-purchase-order-list-200` | Purchasing | PurchaseOrder |
| 13 | `api-013-po-line-list-200` | Purchasing | POLine |
| 14 | `api-014-order-list-200` | Order Entry | Order |
| 15 | `api-015-order-line-list-200` | Order Entry | OrderLine |
| 16 | `api-016-ship-to-list-200` | Order Fulfilment | ShipTo |
| 17 | `api-017-ref-call-list-200` | Credit Management | RefCall |
| 18 | `api-018-invoice-list-200` | Billing & Invoicing | Invoice |
| 19 | `api-019-bill-to-list-200` | Billing & Invoicing | BillTo |
| 20 | `api-020-employee-list-200` | HR & Payroll | Employee |
| 21 | `api-021-department-list-200` | HR & Payroll | Department |
| 22 | `api-022-benefits-list-200` | HR & Payroll | Benefits |
| 23 | `api-023-family-list-200` | HR & Payroll | Family |
| 24 | `api-024-time-sheet-list-200` | HR & Payroll | TimeSheet |
| 25 | `api-025-vacation-list-200` | HR & Payroll | Vacation |
| 26 | `api-026-customer-get-404` | Customer Management | Customer |
| 27 | `api-027-feedback-get-404` | Customer Management | Feedback |
| 28 | `api-028-salesrep-get-404` | Sales & Territories | Salesrep |
| 29 | `api-029-state-get-404` | Sales & Territories | State |
| 30 | `api-030-local-default-get-404` | Sales & Territories | LocalDefault |
| 31 | `api-031-supplier-get-404` | Supplier Management | Supplier |
| 32 | `api-032-supplier-item-xref-get-404` | Supplier Management | SupplierItemXref |
| 33 | `api-033-item-get-404` | Inventory | Item |
| 34 | `api-034-inventory-trans-get-404` | Inventory | InventoryTrans |
| 35 | `api-035-warehouse-get-404` | Warehousing | Warehouse |
| 36 | `api-036-bin-get-404` | Warehousing | Bin |
| 37 | `api-037-purchase-order-get-404` | Purchasing | PurchaseOrder |
| 38 | `api-038-po-line-get-404` | Purchasing | POLine |
| 39 | `api-039-order-get-404` | Order Entry | Order |
| 40 | `api-040-order-line-get-404` | Order Entry | OrderLine |
| 41 | `api-041-ship-to-get-404` | Order Fulfilment | ShipTo |
| 42 | `api-042-ref-call-get-404` | Credit Management | RefCall |
| 43 | `api-043-invoice-get-404` | Billing & Invoicing | Invoice |
| 44 | `api-044-bill-to-get-404` | Billing & Invoicing | BillTo |
| 45 | `api-045-employee-get-404` | HR & Payroll | Employee |
| 46 | `api-046-department-get-404` | HR & Payroll | Department |
| 47 | `api-047-benefits-get-404` | HR & Payroll | Benefits |
| 48 | `api-048-family-get-404` | HR & Payroll | Family |
| 49 | `api-049-time-sheet-get-404` | HR & Payroll | TimeSheet |
| 50 | `api-050-vacation-get-404` | HR & Payroll | Vacation |
| 51 | `api-051-customer-create-422` | Customer Management | Customer |
| 52 | `api-052-feedback-create-422` | Customer Management | Feedback |
| 53 | `api-053-salesrep-create-422` | Sales & Territories | Salesrep |
| 54 | `api-054-state-create-422` | Sales & Territories | State |
| 55 | `api-055-local-default-create-422` | Sales & Territories | LocalDefault |
| 56 | `api-056-supplier-create-422` | Supplier Management | Supplier |
| 57 | `api-057-supplier-item-xref-create-422` | Supplier Management | SupplierItemXref |
| 58 | `api-058-item-create-422` | Inventory | Item |
| 59 | `api-059-inventory-trans-create-422` | Inventory | InventoryTrans |
| 60 | `api-060-warehouse-create-422` | Warehousing | Warehouse |
| 61 | `api-061-bin-create-422` | Warehousing | Bin |
| 62 | `api-062-purchase-order-create-422` | Purchasing | PurchaseOrder |
| 63 | `api-063-po-line-create-422` | Purchasing | POLine |
| 64 | `api-064-order-create-422` | Order Entry | Order |
| 65 | `api-065-order-line-create-422` | Order Entry | OrderLine |
| 66 | `api-066-ship-to-create-422` | Order Fulfilment | ShipTo |
| 67 | `api-067-ref-call-create-422` | Credit Management | RefCall |
| 68 | `api-068-invoice-create-422` | Billing & Invoicing | Invoice |
| 69 | `api-069-bill-to-create-422` | Billing & Invoicing | BillTo |
| 70 | `api-070-employee-create-422` | HR & Payroll | Employee |
| 71 | `api-071-department-create-422` | HR & Payroll | Department |
| 72 | `api-072-benefits-create-422` | HR & Payroll | Benefits |
| 73 | `api-073-family-create-422` | HR & Payroll | Family |
| 74 | `api-074-time-sheet-create-422` | HR & Payroll | TimeSheet |
| 75 | `api-075-vacation-create-422` | HR & Payroll | Vacation |
| 76 | `api-076-customer-update-409` | Customer Management | Customer |
| 77 | `api-077-feedback-update-409` | Customer Management | Feedback |
| 78 | `api-078-salesrep-update-409` | Sales & Territories | Salesrep |
| 79 | `api-079-state-update-409` | Sales & Territories | State |
| 80 | `api-080-local-default-update-409` | Sales & Territories | LocalDefault |
| 81 | `api-081-supplier-update-409` | Supplier Management | Supplier |
| 82 | `api-082-supplier-item-xref-update-409` | Supplier Management | SupplierItemXref |
| 83 | `api-083-item-update-409` | Inventory | Item |
| 84 | `api-084-inventory-trans-update-409` | Inventory | InventoryTrans |
| 85 | `api-085-warehouse-update-409` | Warehousing | Warehouse |
| 86 | `api-086-bin-update-409` | Warehousing | Bin |
| 87 | `api-087-purchase-order-update-409` | Purchasing | PurchaseOrder |
| 88 | `api-088-po-line-update-409` | Purchasing | POLine |
| 89 | `api-089-order-update-409` | Order Entry | Order |
| 90 | `api-090-order-line-update-409` | Order Entry | OrderLine |
| 91 | `api-091-ship-to-update-409` | Order Fulfilment | ShipTo |
| 92 | `api-092-ref-call-update-409` | Credit Management | RefCall |
| 93 | `api-093-invoice-update-409` | Billing & Invoicing | Invoice |
| 94 | `api-094-bill-to-update-409` | Billing & Invoicing | BillTo |
| 95 | `api-095-employee-update-409` | HR & Payroll | Employee |
| 96 | `api-096-department-update-409` | HR & Payroll | Department |
| 97 | `api-097-benefits-update-409` | HR & Payroll | Benefits |
| 98 | `api-098-family-update-409` | HR & Payroll | Family |
| 99 | `api-099-time-sheet-update-409` | HR & Payroll | TimeSheet |
| 100 | `api-100-vacation-update-409` | HR & Payroll | Vacation |
