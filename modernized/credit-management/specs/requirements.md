# Credit Management: requirements (EARS)

Extracted by FlowPilot from 27 legacy ABL programs (3,783 lines) in `legacy/credit-management/`.
Each requirement traces to the schema rule or program it came from. Reviewed by a person before merge.

## RefCall

> The refcall table contains information about a sale.

| ID | Requirement | Source |
|---|---|---|
| CR-R001 | The system shall list RefCall records with search by Call Num, Sales Rep, Parent and sorting on every column. | `ref_call_browse.w` |
| CR-R002 | When a user opens a RefCall, the system shall show every field read-only with its legacy label. | `ref_call_inquiry.w` |
| CR-R003 | When a user saves a RefCall, the system shall identify it by CallNum and reject a duplicate key. | primary index |
| CR-R004 | While another user has changed the same RefCall, the system shall reject the save and ask the user to reload. | `EXCLUSIVE-LOCK NO-WAIT` in `ref_call_maint.p` |
| CR-R005 | If Cust Num is not greater than 0, then the system shall reject the save with "Customer number must be greater than zero". | VALEXP `custnum > 0` |
| CR-R006 | The system shall limit Call Num to 6, Sales Rep to 4, Parent to 6, Txt to 300 characters. | FORMAT x(n) |
| CR-R007 | When a RefCall is deleted, the system shall block the delete while other records still reference it and keep an audit record. | `trg/delete_ref_call.p` |
| CR-R008 | When any RefCall field changes, the system shall record the old and new value with the user and time. | `trg/write_ref_call.p` |

## Non-functional

| ID | Requirement |
|---|---|
| CR-R009 | The list endpoint shall answer within 300 ms at the 95th percentile for 50 concurrent users. |
| CR-R010 | All endpoints shall require an authenticated user and log access. |
| CR-R011 | No sample or test data shall contain real customer personal data. |
