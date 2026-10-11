# Sports2000 Enterprise: legacy estate (sample)

502 Progress OpenEdge ABL programs, 50,809 lines, across 12 business modules over the
25-table sports2000 schema. This estate is generated from the public sports2000 demo schema to
show modernization at enterprise scale. It is sample code, not a production system.

| Module | Wave | Tables | Programs | Lines |
|---|---|---|---|---|
| Customer Management | 1 | Customer, Feedback | 39 | 4,523 |
| Sales & Territories | 1 | Salesrep, State, LocalDefault | 52 | 4,585 |
| Supplier Management | 1 | Supplier, SupplierItemXref | 38 | 3,860 |
| Inventory | 2 | Item, InventoryTrans | 39 | 4,417 |
| Warehousing | 2 | Warehouse, Bin | 38 | 3,699 |
| Purchasing | 2 | PurchaseOrder, POLine | 39 | 3,644 |
| Order Entry | 3 | Order, OrderLine | 40 | 4,665 |
| Order Fulfilment | 3 | ShipTo | 26 | 3,062 |
| Credit Management | 3 | RefCall | 27 | 3,783 |
| Billing & Invoicing | 4 | Invoice, BillTo | 39 | 3,852 |
| HR & Payroll | 4 | Employee, Department, Benefits, Family, TimeSheet, Vacation | 95 | 7,815 |
| Reporting & Batch | 4 | (reads Customer, Order, OrderLine, Invoice, Item, Salesrep) | 18 | 2,475 |
| Shared services | 1 | | 12 | 429 |

Modernized code lands under `modernized/<module>/` through pull requests opened by FlowPilot. A person reviews and merges every one.
