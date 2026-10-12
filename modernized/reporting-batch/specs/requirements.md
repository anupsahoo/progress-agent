# Reporting & Batch: requirements (EARS)

Extracted by FlowPilot from 18 legacy ABL programs (2,475 lines) in `legacy/reporting-batch/`.
Each requirement traces to the schema rule or program it came from. Reviewed by a person before merge.

## Customer

> The customer table contains customer information including balance and address.

| ID | Requirement | Source |
|---|---|---|
| RB-R001 | The system shall list Customer records with search by Country, Name, Address and sorting on every column. | `customer_browse.w` |
| RB-R002 | When a user opens a Customer, the system shall show every field read-only with its legacy label. | `customer_inquiry.w` |

## Order

> The order table contains order header information.

| ID | Requirement | Source |
|---|---|---|
| RB-R003 | The system shall list Order records with search by Carrier, Instructions, PO and sorting on every column. | `order_browse.w` |
| RB-R004 | When a user opens a Order, the system shall show every field read-only with its legacy label. | `order_inquiry.w` |

## OrderLine

> The orderline table contains order detail information including item number and quantity ordered.

| ID | Requirement | Source |
|---|---|---|
| RB-R005 | The system shall list OrderLine records with search by Order Line Status and sorting on every column. | `order_line_browse.w` |
| RB-R006 | When a user opens a OrderLine, the system shall show every field read-only with its legacy label. | `order_line_inquiry.w` |

## Non-functional

| ID | Requirement |
|---|---|
| RB-R007 | The list endpoint shall answer within 300 ms at the 95th percentile for 50 concurrent users. |
| RB-R008 | All endpoints shall require an authenticated user and log access. |
| RB-R009 | No sample or test data shall contain real customer personal data. |
