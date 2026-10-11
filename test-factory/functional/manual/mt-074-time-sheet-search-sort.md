# mt-074-time-sheet-search-sort: TimeSheet: Search and sort the list

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
1. Open HR & Payroll > TimeSheet.
2. Type `par` in Search.
3. Select the Emp No column header twice.

## Expected result
Only matching rows show. The column sorts ascending, then descending.

## Traceability
- Field rules: EmpNum `zzzzzzzzz9`, DayRecorded `99/99/9999`, TypeRecorded `x(8)`, AMTimeIn `xx:xx`
