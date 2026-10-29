# mt-049-time-sheet-reject-invalid: TimeSheet: Reject values that break the field rules

| | |
|---|---|
| Module | HR & Payroll (wave 4) |
| Table | TimeSheet |
| Legacy reference | `legacy/hr-payroll/time_sheet_maint.p` |
| Priority | Medium |
| Type | Manual, UAT |

## Preconditions
- Signed in as a HR & Payroll user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open HR & Payroll > TimeSheet maintenance and open any record.
2. Enter Emp No: `-1`.
3. Select Save.

## Expected result
Save is blocked and the field shows: "Employee must exist.". Nothing is written.

## Traceability
- Field rules: EmpNum `zzzzzzzzz9`, DayRecorded `99/99/9999`, TypeRecorded `x(8)`, AMTimeIn `xx:xx`
