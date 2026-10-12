# Performance tests

Planned: **100** · Created in this pull request: **100** · Folder: `test-factory/non-functional/performance/`

The test plan is the single source of truth: the count planned is the count created.

| # | Case | Module | Table |
|---|---|---|---|
| 1 | `perf-001-customer-list-load` | Customer Management | Customer |
| 2 | `perf-002-feedback-list-load` | Customer Management | Feedback |
| 3 | `perf-003-salesrep-list-load` | Sales & Territories | Salesrep |
| 4 | `perf-004-state-list-load` | Sales & Territories | State |
| 5 | `perf-005-local-default-list-load` | Sales & Territories | LocalDefault |
| 6 | `perf-006-supplier-list-load` | Supplier Management | Supplier |
| 7 | `perf-007-supplier-item-xref-list-load` | Supplier Management | SupplierItemXref |
| 8 | `perf-008-item-list-load` | Inventory | Item |
| 9 | `perf-009-inventory-trans-list-load` | Inventory | InventoryTrans |
| 10 | `perf-010-warehouse-list-load` | Warehousing | Warehouse |
| 11 | `perf-011-bin-list-load` | Warehousing | Bin |
| 12 | `perf-012-purchase-order-list-load` | Purchasing | PurchaseOrder |
| 13 | `perf-013-po-line-list-load` | Purchasing | POLine |
| 14 | `perf-014-order-list-load` | Order Entry | Order |
| 15 | `perf-015-order-line-list-load` | Order Entry | OrderLine |
| 16 | `perf-016-ship-to-list-load` | Order Fulfilment | ShipTo |
| 17 | `perf-017-ref-call-list-load` | Credit Management | RefCall |
| 18 | `perf-018-invoice-list-load` | Billing & Invoicing | Invoice |
| 19 | `perf-019-bill-to-list-load` | Billing & Invoicing | BillTo |
| 20 | `perf-020-employee-list-load` | HR & Payroll | Employee |
| 21 | `perf-021-department-list-load` | HR & Payroll | Department |
| 22 | `perf-022-benefits-list-load` | HR & Payroll | Benefits |
| 23 | `perf-023-family-list-load` | HR & Payroll | Family |
| 24 | `perf-024-time-sheet-list-load` | HR & Payroll | TimeSheet |
| 25 | `perf-025-vacation-list-load` | HR & Payroll | Vacation |
| 26 | `perf-026-customer-detail-spike` | Customer Management | Customer |
| 27 | `perf-027-feedback-detail-spike` | Customer Management | Feedback |
| 28 | `perf-028-salesrep-detail-spike` | Sales & Territories | Salesrep |
| 29 | `perf-029-state-detail-spike` | Sales & Territories | State |
| 30 | `perf-030-local-default-detail-spike` | Sales & Territories | LocalDefault |
| 31 | `perf-031-supplier-detail-spike` | Supplier Management | Supplier |
| 32 | `perf-032-supplier-item-xref-detail-spike` | Supplier Management | SupplierItemXref |
| 33 | `perf-033-item-detail-spike` | Inventory | Item |
| 34 | `perf-034-inventory-trans-detail-spike` | Inventory | InventoryTrans |
| 35 | `perf-035-warehouse-detail-spike` | Warehousing | Warehouse |
| 36 | `perf-036-bin-detail-spike` | Warehousing | Bin |
| 37 | `perf-037-purchase-order-detail-spike` | Purchasing | PurchaseOrder |
| 38 | `perf-038-po-line-detail-spike` | Purchasing | POLine |
| 39 | `perf-039-order-detail-spike` | Order Entry | Order |
| 40 | `perf-040-order-line-detail-spike` | Order Entry | OrderLine |
| 41 | `perf-041-ship-to-detail-spike` | Order Fulfilment | ShipTo |
| 42 | `perf-042-ref-call-detail-spike` | Credit Management | RefCall |
| 43 | `perf-043-invoice-detail-spike` | Billing & Invoicing | Invoice |
| 44 | `perf-044-bill-to-detail-spike` | Billing & Invoicing | BillTo |
| 45 | `perf-045-employee-detail-spike` | HR & Payroll | Employee |
| 46 | `perf-046-department-detail-spike` | HR & Payroll | Department |
| 47 | `perf-047-benefits-detail-spike` | HR & Payroll | Benefits |
| 48 | `perf-048-family-detail-spike` | HR & Payroll | Family |
| 49 | `perf-049-time-sheet-detail-spike` | HR & Payroll | TimeSheet |
| 50 | `perf-050-vacation-detail-spike` | HR & Payroll | Vacation |
| 51 | `perf-051-customer-search-stress` | Customer Management | Customer |
| 52 | `perf-052-feedback-search-stress` | Customer Management | Feedback |
| 53 | `perf-053-salesrep-search-stress` | Sales & Territories | Salesrep |
| 54 | `perf-054-state-search-stress` | Sales & Territories | State |
| 55 | `perf-055-local-default-search-stress` | Sales & Territories | LocalDefault |
| 56 | `perf-056-supplier-search-stress` | Supplier Management | Supplier |
| 57 | `perf-057-supplier-item-xref-search-stress` | Supplier Management | SupplierItemXref |
| 58 | `perf-058-item-search-stress` | Inventory | Item |
| 59 | `perf-059-inventory-trans-search-stress` | Inventory | InventoryTrans |
| 60 | `perf-060-warehouse-search-stress` | Warehousing | Warehouse |
| 61 | `perf-061-bin-search-stress` | Warehousing | Bin |
| 62 | `perf-062-purchase-order-search-stress` | Purchasing | PurchaseOrder |
| 63 | `perf-063-po-line-search-stress` | Purchasing | POLine |
| 64 | `perf-064-order-search-stress` | Order Entry | Order |
| 65 | `perf-065-order-line-search-stress` | Order Entry | OrderLine |
| 66 | `perf-066-ship-to-search-stress` | Order Fulfilment | ShipTo |
| 67 | `perf-067-ref-call-search-stress` | Credit Management | RefCall |
| 68 | `perf-068-invoice-search-stress` | Billing & Invoicing | Invoice |
| 69 | `perf-069-bill-to-search-stress` | Billing & Invoicing | BillTo |
| 70 | `perf-070-employee-search-stress` | HR & Payroll | Employee |
| 71 | `perf-071-department-search-stress` | HR & Payroll | Department |
| 72 | `perf-072-benefits-search-stress` | HR & Payroll | Benefits |
| 73 | `perf-073-family-search-stress` | HR & Payroll | Family |
| 74 | `perf-074-time-sheet-search-stress` | HR & Payroll | TimeSheet |
| 75 | `perf-075-vacation-search-stress` | HR & Payroll | Vacation |
| 76 | `perf-076-customer-write-soak` | Customer Management | Customer |
| 77 | `perf-077-feedback-write-soak` | Customer Management | Feedback |
| 78 | `perf-078-salesrep-write-soak` | Sales & Territories | Salesrep |
| 79 | `perf-079-state-write-soak` | Sales & Territories | State |
| 80 | `perf-080-local-default-write-soak` | Sales & Territories | LocalDefault |
| 81 | `perf-081-supplier-write-soak` | Supplier Management | Supplier |
| 82 | `perf-082-supplier-item-xref-write-soak` | Supplier Management | SupplierItemXref |
| 83 | `perf-083-item-write-soak` | Inventory | Item |
| 84 | `perf-084-inventory-trans-write-soak` | Inventory | InventoryTrans |
| 85 | `perf-085-warehouse-write-soak` | Warehousing | Warehouse |
| 86 | `perf-086-bin-write-soak` | Warehousing | Bin |
| 87 | `perf-087-purchase-order-write-soak` | Purchasing | PurchaseOrder |
| 88 | `perf-088-po-line-write-soak` | Purchasing | POLine |
| 89 | `perf-089-order-write-soak` | Order Entry | Order |
| 90 | `perf-090-order-line-write-soak` | Order Entry | OrderLine |
| 91 | `perf-091-ship-to-write-soak` | Order Fulfilment | ShipTo |
| 92 | `perf-092-ref-call-write-soak` | Credit Management | RefCall |
| 93 | `perf-093-invoice-write-soak` | Billing & Invoicing | Invoice |
| 94 | `perf-094-bill-to-write-soak` | Billing & Invoicing | BillTo |
| 95 | `perf-095-employee-write-soak` | HR & Payroll | Employee |
| 96 | `perf-096-department-write-soak` | HR & Payroll | Department |
| 97 | `perf-097-benefits-write-soak` | HR & Payroll | Benefits |
| 98 | `perf-098-family-write-soak` | HR & Payroll | Family |
| 99 | `perf-099-time-sheet-write-soak` | HR & Payroll | TimeSheet |
| 100 | `perf-100-vacation-write-soak` | HR & Payroll | Vacation |
