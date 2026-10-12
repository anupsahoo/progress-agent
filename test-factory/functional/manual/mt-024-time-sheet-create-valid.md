# mt-024-time-sheet-create-valid: TimeSheet: Create a valid record

| | |
|---|---|
| Module | HR & Payroll (wave 4) |
| Table | TimeSheet |
| Legacy reference | `legacy/hr-payroll/time_sheet_maint.p` |
| Priority | High |
| Type | Manual, UAT |

## Preconditions
- Signed in as a HR & Payroll user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open HR & Payroll > TimeSheet maintenance.
2. Select New.
3. Enter Emp No: `1` (use a new key value for EmpNum, DayRecorded).
4. Enter Day Recorded: `1998-01-05` (use a new key value for EmpNum, DayRecorded).
5. Enter Type Recorded: `part` (use a new key value for EmpNum, DayRecorded).
6. Enter AM Time In: `855` (use a new key value for EmpNum, DayRecorded).
7. Enter AM Time Out: `` (use a new key value for EmpNum, DayRecorded).
8. Enter PM Time In: `` (use a new key value for EmpNum, DayRecorded).
9. Select Save.

## Expected result
The record saves, the banner shows "TimeSheet saved." and it appears in the list.

## Traceability
- Field rules: EmpNum `zzzzzzzzz9`, DayRecorded `99/99/9999`, TypeRecorded `x(8)`, AMTimeIn `xx:xx`
