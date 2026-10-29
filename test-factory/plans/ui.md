# Automated UI tests

Planned: **100** · Created in this pull request: **100** · Folder: `test-factory/functional/web-ui/`

The test plan is the single source of truth: the count planned is the count created.

| # | Case | Module | Table |
|---|---|---|---|
| 1 | `ui-001-customer-list-renders` | Customer Management | Customer |
| 2 | `ui-002-feedback-list-renders` | Customer Management | Feedback |
| 3 | `ui-003-salesrep-list-renders` | Sales & Territories | Salesrep |
| 4 | `ui-004-state-list-renders` | Sales & Territories | State |
| 5 | `ui-005-local-default-list-renders` | Sales & Territories | LocalDefault |
| 6 | `ui-006-supplier-list-renders` | Supplier Management | Supplier |
| 7 | `ui-007-supplier-item-xref-list-renders` | Supplier Management | SupplierItemXref |
| 8 | `ui-008-item-list-renders` | Inventory | Item |
| 9 | `ui-009-inventory-trans-list-renders` | Inventory | InventoryTrans |
| 10 | `ui-010-warehouse-list-renders` | Warehousing | Warehouse |
| 11 | `ui-011-bin-list-renders` | Warehousing | Bin |
| 12 | `ui-012-purchase-order-list-renders` | Purchasing | PurchaseOrder |
| 13 | `ui-013-po-line-list-renders` | Purchasing | POLine |
| 14 | `ui-014-order-list-renders` | Order Entry | Order |
| 15 | `ui-015-order-line-list-renders` | Order Entry | OrderLine |
| 16 | `ui-016-ship-to-list-renders` | Order Fulfilment | ShipTo |
| 17 | `ui-017-ref-call-list-renders` | Credit Management | RefCall |
| 18 | `ui-018-invoice-list-renders` | Billing & Invoicing | Invoice |
| 19 | `ui-019-bill-to-list-renders` | Billing & Invoicing | BillTo |
| 20 | `ui-020-employee-list-renders` | HR & Payroll | Employee |
| 21 | `ui-021-department-list-renders` | HR & Payroll | Department |
| 22 | `ui-022-benefits-list-renders` | HR & Payroll | Benefits |
| 23 | `ui-023-family-list-renders` | HR & Payroll | Family |
| 24 | `ui-024-time-sheet-list-renders` | HR & Payroll | TimeSheet |
| 25 | `ui-025-vacation-list-renders` | HR & Payroll | Vacation |
| 26 | `ui-026-customer-create-and-save` | Customer Management | Customer |
| 27 | `ui-027-feedback-create-and-save` | Customer Management | Feedback |
| 28 | `ui-028-salesrep-create-and-save` | Sales & Territories | Salesrep |
| 29 | `ui-029-state-create-and-save` | Sales & Territories | State |
| 30 | `ui-030-local-default-create-and-save` | Sales & Territories | LocalDefault |
| 31 | `ui-031-supplier-create-and-save` | Supplier Management | Supplier |
| 32 | `ui-032-supplier-item-xref-create-and-save` | Supplier Management | SupplierItemXref |
| 33 | `ui-033-item-create-and-save` | Inventory | Item |
| 34 | `ui-034-inventory-trans-create-and-save` | Inventory | InventoryTrans |
| 35 | `ui-035-warehouse-create-and-save` | Warehousing | Warehouse |
| 36 | `ui-036-bin-create-and-save` | Warehousing | Bin |
| 37 | `ui-037-purchase-order-create-and-save` | Purchasing | PurchaseOrder |
| 38 | `ui-038-po-line-create-and-save` | Purchasing | POLine |
| 39 | `ui-039-order-create-and-save` | Order Entry | Order |
| 40 | `ui-040-order-line-create-and-save` | Order Entry | OrderLine |
| 41 | `ui-041-ship-to-create-and-save` | Order Fulfilment | ShipTo |
| 42 | `ui-042-ref-call-create-and-save` | Credit Management | RefCall |
| 43 | `ui-043-invoice-create-and-save` | Billing & Invoicing | Invoice |
| 44 | `ui-044-bill-to-create-and-save` | Billing & Invoicing | BillTo |
| 45 | `ui-045-employee-create-and-save` | HR & Payroll | Employee |
| 46 | `ui-046-department-create-and-save` | HR & Payroll | Department |
| 47 | `ui-047-benefits-create-and-save` | HR & Payroll | Benefits |
| 48 | `ui-048-family-create-and-save` | HR & Payroll | Family |
| 49 | `ui-049-time-sheet-create-and-save` | HR & Payroll | TimeSheet |
| 50 | `ui-050-vacation-create-and-save` | HR & Payroll | Vacation |
| 51 | `ui-051-customer-field-validation` | Customer Management | Customer |
| 52 | `ui-052-feedback-field-validation` | Customer Management | Feedback |
| 53 | `ui-053-salesrep-field-validation` | Sales & Territories | Salesrep |
| 54 | `ui-054-state-field-validation` | Sales & Territories | State |
| 55 | `ui-055-local-default-field-validation` | Sales & Territories | LocalDefault |
| 56 | `ui-056-supplier-field-validation` | Supplier Management | Supplier |
| 57 | `ui-057-supplier-item-xref-field-validation` | Supplier Management | SupplierItemXref |
| 58 | `ui-058-item-field-validation` | Inventory | Item |
| 59 | `ui-059-inventory-trans-field-validation` | Inventory | InventoryTrans |
| 60 | `ui-060-warehouse-field-validation` | Warehousing | Warehouse |
| 61 | `ui-061-bin-field-validation` | Warehousing | Bin |
| 62 | `ui-062-purchase-order-field-validation` | Purchasing | PurchaseOrder |
| 63 | `ui-063-po-line-field-validation` | Purchasing | POLine |
| 64 | `ui-064-order-field-validation` | Order Entry | Order |
| 65 | `ui-065-order-line-field-validation` | Order Entry | OrderLine |
| 66 | `ui-066-ship-to-field-validation` | Order Fulfilment | ShipTo |
| 67 | `ui-067-ref-call-field-validation` | Credit Management | RefCall |
| 68 | `ui-068-invoice-field-validation` | Billing & Invoicing | Invoice |
| 69 | `ui-069-bill-to-field-validation` | Billing & Invoicing | BillTo |
| 70 | `ui-070-employee-field-validation` | HR & Payroll | Employee |
| 71 | `ui-071-department-field-validation` | HR & Payroll | Department |
| 72 | `ui-072-benefits-field-validation` | HR & Payroll | Benefits |
| 73 | `ui-073-family-field-validation` | HR & Payroll | Family |
| 74 | `ui-074-time-sheet-field-validation` | HR & Payroll | TimeSheet |
| 75 | `ui-075-vacation-field-validation` | HR & Payroll | Vacation |
| 76 | `ui-076-customer-search-filter` | Customer Management | Customer |
| 77 | `ui-077-feedback-search-filter` | Customer Management | Feedback |
| 78 | `ui-078-salesrep-search-filter` | Sales & Territories | Salesrep |
| 79 | `ui-079-state-search-filter` | Sales & Territories | State |
| 80 | `ui-080-local-default-search-filter` | Sales & Territories | LocalDefault |
| 81 | `ui-081-supplier-search-filter` | Supplier Management | Supplier |
| 82 | `ui-082-supplier-item-xref-search-filter` | Supplier Management | SupplierItemXref |
| 83 | `ui-083-item-search-filter` | Inventory | Item |
| 84 | `ui-084-inventory-trans-search-filter` | Inventory | InventoryTrans |
| 85 | `ui-085-warehouse-search-filter` | Warehousing | Warehouse |
| 86 | `ui-086-bin-search-filter` | Warehousing | Bin |
| 87 | `ui-087-purchase-order-search-filter` | Purchasing | PurchaseOrder |
| 88 | `ui-088-po-line-search-filter` | Purchasing | POLine |
| 89 | `ui-089-order-search-filter` | Order Entry | Order |
| 90 | `ui-090-order-line-search-filter` | Order Entry | OrderLine |
| 91 | `ui-091-ship-to-search-filter` | Order Fulfilment | ShipTo |
| 92 | `ui-092-ref-call-search-filter` | Credit Management | RefCall |
| 93 | `ui-093-invoice-search-filter` | Billing & Invoicing | Invoice |
| 94 | `ui-094-bill-to-search-filter` | Billing & Invoicing | BillTo |
| 95 | `ui-095-employee-search-filter` | HR & Payroll | Employee |
| 96 | `ui-096-department-search-filter` | HR & Payroll | Department |
| 97 | `ui-097-benefits-search-filter` | HR & Payroll | Benefits |
| 98 | `ui-098-family-search-filter` | HR & Payroll | Family |
| 99 | `ui-099-time-sheet-search-filter` | HR & Payroll | TimeSheet |
| 100 | `ui-100-vacation-search-filter` | HR & Payroll | Vacation |
