# Customer Management: requirements (EARS)

Extracted by FlowPilot from 39 legacy ABL programs (4,523 lines) in `legacy/customer-management/`.
Each requirement traces to the schema rule or program it came from. Reviewed by a person before merge.

## Customer

> The customer table contains customer information including balance and address.

| ID | Requirement | Source |
|---|---|---|
| CM-R001 | The system shall list Customer records with search by Country, Name, Address and sorting on every column. | `customer_browse.w` |
| CM-R002 | When a user opens a Customer, the system shall show every field read-only with its legacy label. | `customer_inquiry.w` |
| CM-R003 | When a user saves a Customer, the system shall identify it by CustNum and reject a duplicate key. | primary index |
| CM-R004 | While another user has changed the same Customer, the system shall reject the save and ask the user to reload. | `EXCLUSIVE-LOCK NO-WAIT` in `customer_maint.p` |
| CM-R005 | If Cust Num is not greater than 0, then the system shall reject the save with "Customer number must be greater than zero". | VALEXP `custnum > 0` |
| CM-R006 | If Sales Rep does not match an existing Salesrep, then the system shall reject the save with "The Sales Rep's name you've entered must exist in the Salesrep table.". | VALEXP `CAN-FIND(Salesrep OF Customer)` |
| CM-R007 | If Credit Limit is not at least 0, then the system shall reject the save with "Credit Limit must be >= 0 and <= 9,999,999". | VALEXP `CreditLimit >= 0 AND CreditLimit <= 9999999` |
| CM-R008 | If Discount is not at least 0, then the system shall reject the save with "Discount must be greater or equal to 0". | VALEXP `Discount >= 0` |
| CM-R009 | The system shall limit Country to 20, Name to 30, Address to 35, Address2 to 35 characters. | FORMAT x(n) |
| CM-R010 | When a Customer is deleted, the system shall block the delete while other records still reference it and keep an audit record. | `trg/delete_customer.p` |
| CM-R011 | When any Customer field changes, the system shall record the old and new value with the user and time. | `trg/write_customer.p` |

## Feedback

> The feedback table allows customers to provide feedback about what they like and don't like.

| ID | Requirement | Source |
|---|---|---|
| CM-R012 | The system shall list Feedback records with search by Contact Name, Company, Email and sorting on every column. | `feedback_browse.w` |
| CM-R013 | When a user opens a Feedback, the system shall show every field read-only with its legacy label. | `feedback_inquiry.w` |
| CM-R014 | When a user saves a Feedback, the system shall identify it by Department and reject a duplicate key. | primary index |
| CM-R015 | While another user has changed the same Feedback, the system shall reject the save and ask the user to reload. | `EXCLUSIVE-LOCK NO-WAIT` in `feedback_maint.p` |
| CM-R016 | The system shall limit Contact Name to 30, Company to 20, Email to 50, Phone to 20 characters. | FORMAT x(n) |
| CM-R017 | When a Feedback is deleted, the system shall block the delete while other records still reference it and keep an audit record. | `trg/delete_feedback.p` |
| CM-R018 | When any Feedback field changes, the system shall record the old and new value with the user and time. | `trg/write_feedback.p` |

## Non-functional

| ID | Requirement |
|---|---|
| CM-R019 | The list endpoint shall answer within 300 ms at the 95th percentile for 50 concurrent users. |
| CM-R020 | All endpoints shall require an authenticated user and log access. |
| CM-R021 | No sample or test data shall contain real customer personal data. |
