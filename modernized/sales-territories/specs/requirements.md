# Sales & Territories: requirements (EARS)

Extracted by FlowPilot from 52 legacy ABL programs (4,585 lines) in `legacy/sales-territories/`.
Each requirement traces to the schema rule or program it came from. Reviewed by a person before merge.

## Salesrep

> The salesrep table contains sales representative information

| ID | Requirement | Source |
|---|---|---|
| ST-R001 | The system shall list Salesrep records with search by Sales Rep, Rep Name, Region and sorting on every column. | `salesrep_browse.w` |
| ST-R002 | When a user opens a Salesrep, the system shall show every field read-only with its legacy label. | `salesrep_inquiry.w` |
| ST-R003 | When a user saves a Salesrep, the system shall identify it by SalesRep and reject a duplicate key. | primary index |
| ST-R004 | While another user has changed the same Salesrep, the system shall reject the save and ask the user to reload. | `EXCLUSIVE-LOCK NO-WAIT` in `salesrep_maint.p` |
| ST-R005 | The system shall limit Sales Rep to 4, Rep Name to 30, Region to 8 characters. | FORMAT x(n) |
| ST-R006 | When a Salesrep is deleted, the system shall block the delete while other records still reference it and keep an audit record. | `trg/delete_salesrep.p` |
| ST-R007 | When any Salesrep field changes, the system shall record the old and new value with the user and time. | `trg/write_salesrep.p` |

## State

> The state table contans state abbreviations and corresponding sales regions

| ID | Requirement | Source |
|---|---|---|
| ST-R008 | The system shall list State records with search by State, State Name, Region and sorting on every column. | `state_browse.w` |
| ST-R009 | When a user opens a State, the system shall show every field read-only with its legacy label. | `state_inquiry.w` |
| ST-R010 | When a user saves a State, the system shall identify it by State and reject a duplicate key. | primary index |
| ST-R011 | While another user has changed the same State, the system shall reject the save and ask the user to reload. | `EXCLUSIVE-LOCK NO-WAIT` in `state_maint.p` |
| ST-R012 | The system shall limit State to 20, State Name to 20, Region to 8 characters. | FORMAT x(n) |
| ST-R013 | When a State is deleted, the system shall block the delete while other records still reference it and keep an audit record. | `trg/delete_state.p` |
| ST-R014 | When any State field changes, the system shall record the old and new value with the user and time. | `trg/write_state.p` |

## LocalDefault

> The local default table contains default information for the application.

| ID | Requirement | Source |
|---|---|---|
| ST-R015 | The system shall list LocalDefault records with search by Country, Region1 Label, Region2 Label and sorting on every column. | `local_default_browse.w` |
| ST-R016 | When a user opens a LocalDefault, the system shall show every field read-only with its legacy label. | `local_default_inquiry.w` |
| ST-R017 | When a user saves a LocalDefault, the system shall identify it by LocalDefNum and reject a duplicate key. | primary index |
| ST-R018 | While another user has changed the same LocalDefault, the system shall reject the save and ask the user to reload. | `EXCLUSIVE-LOCK NO-WAIT` in `local_default_maint.p` |
| ST-R019 | The system shall limit Country to 20, Region1 Label to 15, Region2 Label to 15, Postal Label to 15 characters. | FORMAT x(n) |
| ST-R020 | When a LocalDefault is deleted, the system shall block the delete while other records still reference it and keep an audit record. | `trg/delete_local_default.p` |
| ST-R021 | When any LocalDefault field changes, the system shall record the old and new value with the user and time. | `trg/write_local_default.p` |

## Non-functional

| ID | Requirement |
|---|---|
| ST-R022 | The list endpoint shall answer within 300 ms at the 95th percentile for 50 concurrent users. |
| ST-R023 | All endpoints shall require an authenticated user and log access. |
| ST-R024 | No sample or test data shall contain real customer personal data. |
