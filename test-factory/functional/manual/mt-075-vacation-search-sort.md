# mt-075-vacation-search-sort: Vacation: Search and sort the list

| | |
|---|---|
| Module | HR & Payroll (wave 4) |
| Table | Vacation |
| Legacy reference | `legacy/hr-payroll/vacation_maint.p` |
| Priority | Medium |
| Type | Manual, UAT |

## Preconditions
- Signed in as a HR & Payroll user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open HR & Payroll > Vacation.
2. Type `1` in Search.
3. Select the Emp No column header twice.

## Expected result
Only matching rows show. The column sorts ascending, then descending.

## Traceability
- Field rules: EmpNum `zzzzzzzzz9`, StartDate `99/99/9999`, EndDate `99/99/9999`
