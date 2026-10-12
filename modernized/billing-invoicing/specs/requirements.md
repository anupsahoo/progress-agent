# Billing & Invoicing: requirements (EARS)

Extracted by FlowPilot from 39 legacy ABL programs (3,852 lines) in `legacy/billing-invoicing/`.
Each requirement traces to the schema rule or program it came from. Reviewed by a person before merge.

## Invoice

> The invoice table contains transactions for the receivable module.

| ID | Requirement | Source |
|---|---|---|
| BI-R001 | The system shall list Invoice records with search by key and sorting on every column. | `invoice_browse.w` |
| BI-R002 | When a user opens a Invoice, the system shall show every field read-only with its legacy label. | `invoice_inquiry.w` |
| BI-R003 | When a user saves a Invoice, the system shall identify it by Invoicenum and reject a duplicate key. | primary index |
| BI-R004 | While another user has changed the same Invoice, the system shall reject the save and ask the user to reload. | `EXCLUSIVE-LOCK NO-WAIT` in `invoice_maint.p` |
| BI-R005 | If Invoice Num is not greater than 0, then the system shall reject the save with "Invoice number cannot be zero". | VALEXP `invoicenum > 0` |
| BI-R006 | If Cust Num does not match an existing Customer, then the system shall reject the save with "The Customer number entered must be a valid one.". | VALEXP `CAN-FIND(customer OF invoice)` |
| BI-R007 | When a Invoice is deleted, the system shall block the delete while other records still reference it and keep an audit record. | `trg/delete_invoice.p` |
| BI-R008 | When any Invoice field changes, the system shall record the old and new value with the user and time. | `trg/write_invoice.p` |

## BillTo

> The billto table contains bill to address information for an order.

| ID | Requirement | Source |
|---|---|---|
| BI-R009 | The system shall list BillTo records with search by Name, Address, Address2 and sorting on every column. | `bill_to_browse.w` |
| BI-R010 | When a user opens a BillTo, the system shall show every field read-only with its legacy label. | `bill_to_inquiry.w` |
| BI-R011 | When a user saves a BillTo, the system shall identify it by CustNum + BillToID and reject a duplicate key. | primary index |
| BI-R012 | While another user has changed the same BillTo, the system shall reject the save and ask the user to reload. | `EXCLUSIVE-LOCK NO-WAIT` in `bill_to_maint.p` |
| BI-R013 | If Cust Num does not match an existing Customer, then the system shall reject the save with "Customer number must be greater than zero". | VALEXP `CAN-FIND(customer OF billto)` |
| BI-R014 | The system shall limit Name to 30, Address to 35, Address2 to 35, City to 25 characters. | FORMAT x(n) |
| BI-R015 | When a BillTo is deleted, the system shall block the delete while other records still reference it and keep an audit record. | `trg/delete_bill_to.p` |
| BI-R016 | When any BillTo field changes, the system shall record the old and new value with the user and time. | `trg/write_bill_to.p` |

## Non-functional

| ID | Requirement |
|---|---|
| BI-R017 | The list endpoint shall answer within 300 ms at the 95th percentile for 50 concurrent users. |
| BI-R018 | All endpoints shall require an authenticated user and log access. |
| BI-R019 | No sample or test data shall contain real customer personal data. |
