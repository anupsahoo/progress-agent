# Security tests

Planned: **100** · Created in this pull request: **100** · Folder: `test-factory/non-functional/security/`

The test plan is the single source of truth: the count planned is the count created.

| # | Case | Module | Table |
|---|---|---|---|
| 1 | `sec-001-customer-a01-idor` | Customer Management | Customer |
| 2 | `sec-002-feedback-a01-idor` | Customer Management | Feedback |
| 3 | `sec-003-salesrep-a01-idor` | Sales & Territories | Salesrep |
| 4 | `sec-004-state-a01-idor` | Sales & Territories | State |
| 5 | `sec-005-local-default-a01-idor` | Sales & Territories | LocalDefault |
| 6 | `sec-006-supplier-a01-idor` | Supplier Management | Supplier |
| 7 | `sec-007-supplier-item-xref-a01-idor` | Supplier Management | SupplierItemXref |
| 8 | `sec-008-item-a01-idor` | Inventory | Item |
| 9 | `sec-009-inventory-trans-a01-idor` | Inventory | InventoryTrans |
| 10 | `sec-010-warehouse-a01-idor` | Warehousing | Warehouse |
| 11 | `sec-011-bin-a01-idor` | Warehousing | Bin |
| 12 | `sec-012-purchase-order-a01-idor` | Purchasing | PurchaseOrder |
| 13 | `sec-013-po-line-a01-idor` | Purchasing | POLine |
| 14 | `sec-014-order-a01-idor` | Order Entry | Order |
| 15 | `sec-015-order-line-a01-idor` | Order Entry | OrderLine |
| 16 | `sec-016-ship-to-a01-idor` | Order Fulfilment | ShipTo |
| 17 | `sec-017-ref-call-a01-idor` | Credit Management | RefCall |
| 18 | `sec-018-invoice-a01-idor` | Billing & Invoicing | Invoice |
| 19 | `sec-019-bill-to-a01-idor` | Billing & Invoicing | BillTo |
| 20 | `sec-020-employee-a01-idor` | HR & Payroll | Employee |
| 21 | `sec-021-department-a01-idor` | HR & Payroll | Department |
| 22 | `sec-022-benefits-a01-idor` | HR & Payroll | Benefits |
| 23 | `sec-023-family-a01-idor` | HR & Payroll | Family |
| 24 | `sec-024-time-sheet-a01-idor` | HR & Payroll | TimeSheet |
| 25 | `sec-025-vacation-a01-idor` | HR & Payroll | Vacation |
| 26 | `sec-026-customer-a03-injection` | Customer Management | Customer |
| 27 | `sec-027-feedback-a03-injection` | Customer Management | Feedback |
| 28 | `sec-028-salesrep-a03-injection` | Sales & Territories | Salesrep |
| 29 | `sec-029-state-a03-injection` | Sales & Territories | State |
| 30 | `sec-030-local-default-a03-injection` | Sales & Territories | LocalDefault |
| 31 | `sec-031-supplier-a03-injection` | Supplier Management | Supplier |
| 32 | `sec-032-supplier-item-xref-a03-injection` | Supplier Management | SupplierItemXref |
| 33 | `sec-033-item-a03-injection` | Inventory | Item |
| 34 | `sec-034-inventory-trans-a03-injection` | Inventory | InventoryTrans |
| 35 | `sec-035-warehouse-a03-injection` | Warehousing | Warehouse |
| 36 | `sec-036-bin-a03-injection` | Warehousing | Bin |
| 37 | `sec-037-purchase-order-a03-injection` | Purchasing | PurchaseOrder |
| 38 | `sec-038-po-line-a03-injection` | Purchasing | POLine |
| 39 | `sec-039-order-a03-injection` | Order Entry | Order |
| 40 | `sec-040-order-line-a03-injection` | Order Entry | OrderLine |
| 41 | `sec-041-ship-to-a03-injection` | Order Fulfilment | ShipTo |
| 42 | `sec-042-ref-call-a03-injection` | Credit Management | RefCall |
| 43 | `sec-043-invoice-a03-injection` | Billing & Invoicing | Invoice |
| 44 | `sec-044-bill-to-a03-injection` | Billing & Invoicing | BillTo |
| 45 | `sec-045-employee-a03-injection` | HR & Payroll | Employee |
| 46 | `sec-046-department-a03-injection` | HR & Payroll | Department |
| 47 | `sec-047-benefits-a03-injection` | HR & Payroll | Benefits |
| 48 | `sec-048-family-a03-injection` | HR & Payroll | Family |
| 49 | `sec-049-time-sheet-a03-injection` | HR & Payroll | TimeSheet |
| 50 | `sec-050-vacation-a03-injection` | HR & Payroll | Vacation |
| 51 | `sec-051-customer-a05-headers` | Customer Management | Customer |
| 52 | `sec-052-feedback-a05-headers` | Customer Management | Feedback |
| 53 | `sec-053-salesrep-a05-headers` | Sales & Territories | Salesrep |
| 54 | `sec-054-state-a05-headers` | Sales & Territories | State |
| 55 | `sec-055-local-default-a05-headers` | Sales & Territories | LocalDefault |
| 56 | `sec-056-supplier-a05-headers` | Supplier Management | Supplier |
| 57 | `sec-057-supplier-item-xref-a05-headers` | Supplier Management | SupplierItemXref |
| 58 | `sec-058-item-a05-headers` | Inventory | Item |
| 59 | `sec-059-inventory-trans-a05-headers` | Inventory | InventoryTrans |
| 60 | `sec-060-warehouse-a05-headers` | Warehousing | Warehouse |
| 61 | `sec-061-bin-a05-headers` | Warehousing | Bin |
| 62 | `sec-062-purchase-order-a05-headers` | Purchasing | PurchaseOrder |
| 63 | `sec-063-po-line-a05-headers` | Purchasing | POLine |
| 64 | `sec-064-order-a05-headers` | Order Entry | Order |
| 65 | `sec-065-order-line-a05-headers` | Order Entry | OrderLine |
| 66 | `sec-066-ship-to-a05-headers` | Order Fulfilment | ShipTo |
| 67 | `sec-067-ref-call-a05-headers` | Credit Management | RefCall |
| 68 | `sec-068-invoice-a05-headers` | Billing & Invoicing | Invoice |
| 69 | `sec-069-bill-to-a05-headers` | Billing & Invoicing | BillTo |
| 70 | `sec-070-employee-a05-headers` | HR & Payroll | Employee |
| 71 | `sec-071-department-a05-headers` | HR & Payroll | Department |
| 72 | `sec-072-benefits-a05-headers` | HR & Payroll | Benefits |
| 73 | `sec-073-family-a05-headers` | HR & Payroll | Family |
| 74 | `sec-074-time-sheet-a05-headers` | HR & Payroll | TimeSheet |
| 75 | `sec-075-vacation-a05-headers` | HR & Payroll | Vacation |
| 76 | `sec-076-customer-a07-auth` | Customer Management | Customer |
| 77 | `sec-077-feedback-a07-auth` | Customer Management | Feedback |
| 78 | `sec-078-salesrep-a07-auth` | Sales & Territories | Salesrep |
| 79 | `sec-079-state-a07-auth` | Sales & Territories | State |
| 80 | `sec-080-local-default-a07-auth` | Sales & Territories | LocalDefault |
| 81 | `sec-081-supplier-a07-auth` | Supplier Management | Supplier |
| 82 | `sec-082-supplier-item-xref-a07-auth` | Supplier Management | SupplierItemXref |
| 83 | `sec-083-item-a07-auth` | Inventory | Item |
| 84 | `sec-084-inventory-trans-a07-auth` | Inventory | InventoryTrans |
| 85 | `sec-085-warehouse-a07-auth` | Warehousing | Warehouse |
| 86 | `sec-086-bin-a07-auth` | Warehousing | Bin |
| 87 | `sec-087-purchase-order-a07-auth` | Purchasing | PurchaseOrder |
| 88 | `sec-088-po-line-a07-auth` | Purchasing | POLine |
| 89 | `sec-089-order-a07-auth` | Order Entry | Order |
| 90 | `sec-090-order-line-a07-auth` | Order Entry | OrderLine |
| 91 | `sec-091-ship-to-a07-auth` | Order Fulfilment | ShipTo |
| 92 | `sec-092-ref-call-a07-auth` | Credit Management | RefCall |
| 93 | `sec-093-invoice-a07-auth` | Billing & Invoicing | Invoice |
| 94 | `sec-094-bill-to-a07-auth` | Billing & Invoicing | BillTo |
| 95 | `sec-095-employee-a07-auth` | HR & Payroll | Employee |
| 96 | `sec-096-department-a07-auth` | HR & Payroll | Department |
| 97 | `sec-097-benefits-a07-auth` | HR & Payroll | Benefits |
| 98 | `sec-098-family-a07-auth` | HR & Payroll | Family |
| 99 | `sec-099-time-sheet-a07-auth` | HR & Payroll | TimeSheet |
| 100 | `sec-100-vacation-a07-auth` | HR & Payroll | Vacation |
