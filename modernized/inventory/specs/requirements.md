# Inventory: requirements (EARS)

Extracted by FlowPilot from 39 legacy ABL programs (4,417 lines) in `legacy/inventory/`.
Each requirement traces to the schema rule or program it came from. Reviewed by a person before merge.

## Item

> The item table provides a quick reference for items in stock and quantity on-hand.

| ID | Requirement | Source |
|---|---|---|
| IN-R001 | The system shall list Item records with search by Item Name, Cat-Description, Category1 and sorting on every column. | `item_browse.w` |
| IN-R002 | When a user opens a Item, the system shall show every field read-only with its legacy label. | `item_inquiry.w` |
| IN-R003 | When a user saves a Item, the system shall identify it by Itemnum and reject a duplicate key. | primary index |
| IN-R004 | While another user has changed the same Item, the system shall reject the save and ask the user to reload. | `EXCLUSIVE-LOCK NO-WAIT` in `item_maint.p` |
| IN-R005 | If Item Num is not at least 0, then the system shall reject the save with "Item number must be greater or equal to 0". | VALEXP `itemnum >= 0` |
| IN-R006 | The system shall limit Item Name to 25, Cat-Description to 200, Category1 to 30, Category2 to 30 characters. | FORMAT x(n) |
| IN-R007 | When a Item is deleted, the system shall block the delete while other records still reference it and keep an audit record. | `trg/delete_item.p` |
| IN-R008 | When any Item field changes, the system shall record the old and new value with the user and time. | `trg/write_item.p` |

## InventoryTrans

> The inventorytrans table contains information about the movement of inventory.

| ID | Requirement | Source |
|---|---|---|
| IN-R009 | The system shall list InventoryTrans records with search by Type, Trans Time and sorting on every column. | `inventory_trans_browse.w` |
| IN-R010 | When a user opens a InventoryTrans, the system shall show every field read-only with its legacy label. | `inventory_trans_inquiry.w` |
| IN-R011 | When a user saves a InventoryTrans, the system shall identify it by InvTransNum and reject a duplicate key. | primary index |
| IN-R012 | While another user has changed the same InventoryTrans, the system shall reject the save and ask the user to reload. | `EXCLUSIVE-LOCK NO-WAIT` in `inventory_trans_maint.p` |
| IN-R013 | If Item Num does not match an existing Item, then the system shall reject the save with "Item must be on file.". | VALEXP `CAN-FIND(item OF inventorytrans)` |
| IN-R014 | The system shall limit Type to 12, Trans Time to 5 characters. | FORMAT x(n) |
| IN-R015 | When a InventoryTrans is deleted, the system shall block the delete while other records still reference it and keep an audit record. | `trg/delete_inventory_trans.p` |
| IN-R016 | When any InventoryTrans field changes, the system shall record the old and new value with the user and time. | `trg/write_inventory_trans.p` |

## Non-functional

| ID | Requirement |
|---|---|
| IN-R017 | The list endpoint shall answer within 300 ms at the 95th percentile for 50 concurrent users. |
| IN-R018 | All endpoints shall require an authenticated user and log access. |
| IN-R019 | No sample or test data shall contain real customer personal data. |
