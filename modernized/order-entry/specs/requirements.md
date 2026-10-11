# Order Entry: requirements (EARS)

Extracted by FlowPilot from 40 legacy ABL programs (4,665 lines) in `legacy/order-entry/`.
Each requirement traces to the schema rule or program it came from. Reviewed by a person before merge.

## Order

> The order table contains order header information.

| ID | Requirement | Source |
|---|---|---|
| OE-R001 | The system shall list Order records with search by Carrier, Instructions, PO and sorting on every column. | `order_browse.w` |
| OE-R002 | When a user opens a Order, the system shall show every field read-only with its legacy label. | `order_inquiry.w` |
| OE-R003 | When a user saves a Order, the system shall identify it by Ordernum and reject a duplicate key. | primary index |
| OE-R004 | While another user has changed the same Order, the system shall reject the save and ask the user to reload. | `EXCLUSIVE-LOCK NO-WAIT` in `order_maint.p` |
| OE-R005 | If Order Num is not greater than 0, then the system shall reject the save with "Order number must be greater than zero". | VALEXP `ordernum > 0` |
| OE-R006 | If Cust Num does not match an existing Customer, then the system shall reject the save with "Customer must already exist.". | VALEXP `CAN-FIND(customer OF order)` |
| OE-R007 | If Warehouse Num does not match an existing Warehouse and is not 0, then the system shall reject the save with "Entrer a number greater than zero". | VALEXP `(warehousenum = 0) or can-find(warehouse of order)` |
| OE-R008 | The system shall limit Carrier to 25, Instructions to 50, PO to 20, Terms to 20 characters. | FORMAT x(n) |
| OE-R009 | When a Order is deleted, the system shall block the delete while other records still reference it and keep an audit record. | `trg/delete_order.p` |
| OE-R010 | When any Order field changes, the system shall record the old and new value with the user and time. | `trg/write_order.p` |

## OrderLine

> The orderline table contains order detail information including item number and quantity ordered.

| ID | Requirement | Source |
|---|---|---|
| OE-R011 | The system shall list OrderLine records with search by Order Line Status and sorting on every column. | `order_line_browse.w` |
| OE-R012 | When a user opens a OrderLine, the system shall show every field read-only with its legacy label. | `order_line_inquiry.w` |
| OE-R013 | When a user saves a OrderLine, the system shall identify it by Ordernum + Linenum and reject a duplicate key. | primary index |
| OE-R014 | While another user has changed the same OrderLine, the system shall reject the save and ask the user to reload. | `EXCLUSIVE-LOCK NO-WAIT` in `order_line_maint.p` |
| OE-R015 | If Order Num does not match an existing Order, then the system shall reject the save with "Order must exist". | VALEXP `CAN-FIND(order OF orderline)` |
| OE-R016 | If Item Num does not match an existing Item, then the system shall reject the save with "Item must be on file". | VALEXP `CAN-FIND(item OF orderline)` |
| OE-R017 | The system shall limit Order Line Status to 20 characters. | FORMAT x(n) |
| OE-R018 | When a OrderLine is deleted, the system shall block the delete while other records still reference it and keep an audit record. | `trg/delete_order_line.p` |
| OE-R019 | When any OrderLine field changes, the system shall record the old and new value with the user and time. | `trg/write_order_line.p` |

## Non-functional

| ID | Requirement |
|---|---|
| OE-R020 | The list endpoint shall answer within 300 ms at the 95th percentile for 50 concurrent users. |
| OE-R021 | All endpoints shall require an authenticated user and log access. |
| OE-R022 | No sample or test data shall contain real customer personal data. |
