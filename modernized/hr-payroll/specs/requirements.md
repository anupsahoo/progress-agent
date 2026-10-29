# HR & Payroll: requirements (EARS)

Extracted by FlowPilot from 95 legacy ABL programs (7,815 lines) in `legacy/hr-payroll/`.
Each requirement traces to the schema rule or program it came from. Reviewed by a person before merge.

## Employee

> The employee table stores employee information including name and address

| ID | Requirement | Source |
|---|---|---|
| HR-R001 | The system shall list Employee records with search by Last Name, First Name, Address and sorting on every column. | `employee_browse.w` |
| HR-R002 | When a user opens a Employee, the system shall show every field read-only with its legacy label. | `employee_inquiry.w` |
| HR-R003 | When a user saves a Employee, the system shall identify it by EmpNum and reject a duplicate key. | primary index |
| HR-R004 | While another user has changed the same Employee, the system shall reject the save and ask the user to reload. | `EXCLUSIVE-LOCK NO-WAIT` in `employee_maint.p` |
| HR-R005 | If Dept Code does not match an existing Department, then the system shall reject the save with "Department must exist.". | VALEXP `CAN-FIND(department of employee)` |
| HR-R006 | The system shall limit Last Name to 25, First Name to 15, Address to 35, Address2 to 35 characters. | FORMAT x(n) |
| HR-R007 | When a Employee is deleted, the system shall block the delete while other records still reference it and keep an audit record. | `trg/delete_employee.p` |
| HR-R008 | When any Employee field changes, the system shall record the old and new value with the user and time. | `trg/write_employee.p` |

## Department

> The department contains a master listing of departments.

| ID | Requirement | Source |
|---|---|---|
| HR-R009 | The system shall list Department records with search by Dept Code, Dept Name and sorting on every column. | `department_browse.w` |
| HR-R010 | When a user opens a Department, the system shall show every field read-only with its legacy label. | `department_inquiry.w` |
| HR-R011 | When a user saves a Department, the system shall identify it by DeptCode and reject a duplicate key. | primary index |
| HR-R012 | While another user has changed the same Department, the system shall reject the save and ask the user to reload. | `EXCLUSIVE-LOCK NO-WAIT` in `department_maint.p` |
| HR-R013 | The system shall limit Dept Code to 3, Dept Name to 15 characters. | FORMAT x(n) |
| HR-R014 | When a Department is deleted, the system shall block the delete while other records still reference it and keep an audit record. | `trg/delete_department.p` |
| HR-R015 | When any Department field changes, the system shall record the old and new value with the user and time. | `trg/write_department.p` |

## Benefits

> The benefits table contains employee benefits.

| ID | Requirement | Source |
|---|---|---|
| HR-R016 | The system shall list Benefits records with search by Health Care and sorting on every column. | `benefits_browse.w` |
| HR-R017 | When a user opens a Benefits, the system shall show every field read-only with its legacy label. | `benefits_inquiry.w` |
| HR-R018 | When a user saves a Benefits, the system shall identify it by EmpNum and reject a duplicate key. | primary index |
| HR-R019 | While another user has changed the same Benefits, the system shall reject the save and ask the user to reload. | `EXCLUSIVE-LOCK NO-WAIT` in `benefits_maint.p` |
| HR-R020 | If Emp No does not match an existing Employee, then the system shall reject the save with "Employee must exist.". | VALEXP `CAN-FIND(employee OF benefits)` |
| HR-R021 | The system shall limit Health Care to 8 characters. | FORMAT x(n) |
| HR-R022 | When a Benefits is deleted, the system shall block the delete while other records still reference it and keep an audit record. | `trg/delete_benefits.p` |
| HR-R023 | When any Benefits field changes, the system shall record the old and new value with the user and time. | `trg/write_benefits.p` |

## Family

> The family table tracks an employee's family

| ID | Requirement | Source |
|---|---|---|
| HR-R024 | The system shall list Family records with search by Relative Name, Relation and sorting on every column. | `family_browse.w` |
| HR-R025 | When a user opens a Family, the system shall show every field read-only with its legacy label. | `family_inquiry.w` |
| HR-R026 | When a user saves a Family, the system shall identify it by EmpNum + RelativeName and reject a duplicate key. | primary index |
| HR-R027 | While another user has changed the same Family, the system shall reject the save and ask the user to reload. | `EXCLUSIVE-LOCK NO-WAIT` in `family_maint.p` |
| HR-R028 | If Emp No does not match an existing Employee, then the system shall reject the save with "Employee must exist.". | VALEXP `CAN-FIND(employee OF family)` |
| HR-R029 | The system shall limit Relative Name to 15, Relation to 15 characters. | FORMAT x(n) |
| HR-R030 | When a Family is deleted, the system shall block the delete while other records still reference it and keep an audit record. | `trg/delete_family.p` |
| HR-R031 | When any Family field changes, the system shall record the old and new value with the user and time. | `trg/write_family.p` |

## TimeSheet

> The timesheet table records time in and out, hours worked, and overtime.

| ID | Requirement | Source |
|---|---|---|
| HR-R032 | The system shall list TimeSheet records with search by Type Recorded, AM Time In, AM Time Out and sorting on every column. | `time_sheet_browse.w` |
| HR-R033 | When a user opens a TimeSheet, the system shall show every field read-only with its legacy label. | `time_sheet_inquiry.w` |
| HR-R034 | When a user saves a TimeSheet, the system shall identify it by EmpNum + DayRecorded and reject a duplicate key. | primary index |
| HR-R035 | While another user has changed the same TimeSheet, the system shall reject the save and ask the user to reload. | `EXCLUSIVE-LOCK NO-WAIT` in `time_sheet_maint.p` |
| HR-R036 | If Emp No does not match an existing Employee, then the system shall reject the save with "Employee must exist.". | VALEXP `CAN-FIND(employee OF timesheet)` |
| HR-R037 | The system shall limit Type Recorded to 8, AM Time In to 5, AM Time Out to 5, PM Time In to 5 characters. | FORMAT x(n) |
| HR-R038 | When a TimeSheet is deleted, the system shall block the delete while other records still reference it and keep an audit record. | `trg/delete_time_sheet.p` |
| HR-R039 | When any TimeSheet field changes, the system shall record the old and new value with the user and time. | `trg/write_time_sheet.p` |

## Vacation

> The vacation table keeps track of employee vacation time.

| ID | Requirement | Source |
|---|---|---|
| HR-R040 | The system shall list Vacation records with search by key and sorting on every column. | `vacation_browse.w` |
| HR-R041 | When a user opens a Vacation, the system shall show every field read-only with its legacy label. | `vacation_inquiry.w` |
| HR-R042 | When a user saves a Vacation, the system shall identify it by EmpNum + StartDate and reject a duplicate key. | primary index |
| HR-R043 | While another user has changed the same Vacation, the system shall reject the save and ask the user to reload. | `EXCLUSIVE-LOCK NO-WAIT` in `vacation_maint.p` |
| HR-R044 | If Emp No is not at least 0, then the system shall reject the save with "Employee must exist". | VALEXP `CAN-FIND(employee WHERE employee.empnum = vacation.empnum)` |
| HR-R045 | When a Vacation is deleted, the system shall block the delete while other records still reference it and keep an audit record. | `trg/delete_vacation.p` |
| HR-R046 | When any Vacation field changes, the system shall record the old and new value with the user and time. | `trg/write_vacation.p` |

## Non-functional

| ID | Requirement |
|---|---|
| HR-R047 | The list endpoint shall answer within 300 ms at the 95th percentile for 50 concurrent users. |
| HR-R048 | All endpoints shall require an authenticated user and log access. |
| HR-R049 | No sample or test data shall contain real customer personal data. |
