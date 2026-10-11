# Warehousing: requirements (EARS)

Extracted by FlowPilot from 38 legacy ABL programs (3,699 lines) in `legacy/warehousing/`.
Each requirement traces to the schema rule or program it came from. Reviewed by a person before merge.

## Warehouse

> The warehouse table contains warehouse information including warehouse name and address.

| ID | Requirement | Source |
|---|---|---|
| WH-R001 | The system shall list Warehouse records with search by Warehouse Name, Country, Address and sorting on every column. | `warehouse_browse.w` |
| WH-R002 | When a user opens a Warehouse, the system shall show every field read-only with its legacy label. | `warehouse_inquiry.w` |
| WH-R003 | When a user saves a Warehouse, the system shall identify it by WarehouseNum and reject a duplicate key. | primary index |
| WH-R004 | While another user has changed the same Warehouse, the system shall reject the save and ask the user to reload. | `EXCLUSIVE-LOCK NO-WAIT` in `warehouse_maint.p` |
| WH-R005 | If Warehouse Num is not greater than 0, then the system shall reject the save with "Entrer a number greater than zero". | VALEXP `warehousenum > 0` |
| WH-R006 | The system shall limit Warehouse Name to 30, Country to 20, Address to 35, Address2 to 35 characters. | FORMAT x(n) |
| WH-R007 | When a Warehouse is deleted, the system shall block the delete while other records still reference it and keep an audit record. | `trg/delete_warehouse.p` |
| WH-R008 | When any Warehouse field changes, the system shall record the old and new value with the user and time. | `trg/write_warehouse.p` |

## Bin

> The bin table is used to represent the bins in each warehouse that contain items.

| ID | Requirement | Source |
|---|---|---|
| WH-R009 | The system shall list Bin records with search by Bin Name and sorting on every column. | `bin_browse.w` |
| WH-R010 | When a user opens a Bin, the system shall show every field read-only with its legacy label. | `bin_inquiry.w` |
| WH-R011 | When a user saves a Bin, the system shall identify it by BinNum and reject a duplicate key. | primary index |
| WH-R012 | While another user has changed the same Bin, the system shall reject the save and ask the user to reload. | `EXCLUSIVE-LOCK NO-WAIT` in `bin_maint.p` |
| WH-R013 | If Warehouse Num does not match an existing Warehouse, then the system shall reject the save with "Warehouse must exist.". | VALEXP `CAN-FIND(warehouse OF bin)` |
| WH-R014 | If Item Num does not match an existing Item, then the system shall reject the save with "Item must be on file". | VALEXP `CAN-FIND(item OF bin)` |
| WH-R015 | The system shall limit Bin Name to 30 characters. | FORMAT x(n) |
| WH-R016 | When a Bin is deleted, the system shall block the delete while other records still reference it and keep an audit record. | `trg/delete_bin.p` |
| WH-R017 | When any Bin field changes, the system shall record the old and new value with the user and time. | `trg/write_bin.p` |

## Non-functional

| ID | Requirement |
|---|---|
| WH-R018 | The list endpoint shall answer within 300 ms at the 95th percentile for 50 concurrent users. |
| WH-R019 | All endpoints shall require an authenticated user and log access. |
| WH-R020 | No sample or test data shall contain real customer personal data. |
