# Order Fulfilment: requirements (EARS)

Extracted by FlowPilot from 26 legacy ABL programs (3,062 lines) in `legacy/order-fulfilment/`.
Each requirement traces to the schema rule or program it came from. Reviewed by a person before merge.

## ShipTo

> The shipto table contains the ship to address information for an order.

| ID | Requirement | Source |
|---|---|---|
| OF-R001 | The system shall list ShipTo records with search by Contact, Address, Address2 and sorting on every column. | `ship_to_browse.w` |
| OF-R002 | When a user opens a ShipTo, the system shall show every field read-only with its legacy label. | `ship_to_inquiry.w` |
| OF-R003 | When a user saves a ShipTo, the system shall identify it by CustNum + ShipToID and reject a duplicate key. | primary index |
| OF-R004 | While another user has changed the same ShipTo, the system shall reject the save and ask the user to reload. | `EXCLUSIVE-LOCK NO-WAIT` in `ship_to_maint.p` |
| OF-R005 | If Cust Num does not match an existing Customer, then the system shall reject the save with "Customer must exist". | VALEXP `CAN-FIND(customer OF shipto)` |
| OF-R006 | The system shall limit Contact to 30, Address to 35, Address2 to 35, City to 25 characters. | FORMAT x(n) |
| OF-R007 | When a ShipTo is deleted, the system shall block the delete while other records still reference it and keep an audit record. | `trg/delete_ship_to.p` |
| OF-R008 | When any ShipTo field changes, the system shall record the old and new value with the user and time. | `trg/write_ship_to.p` |

## Non-functional

| ID | Requirement |
|---|---|
| OF-R009 | The list endpoint shall answer within 300 ms at the 95th percentile for 50 concurrent users. |
| OF-R010 | All endpoints shall require an authenticated user and log access. |
| OF-R011 | No sample or test data shall contain real customer personal data. |
