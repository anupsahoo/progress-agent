# mt-070-employee-search-sort: Employee: Search and sort the list

| | |
|---|---|
| Module | HR & Payroll (wave 4) |
| Table | Employee |
| Legacy reference | `legacy/hr-payroll/employee_maint.p` |
| Priority | Medium |
| Type | Manual, UAT |

## Preconditions
- Signed in as a HR & Payroll user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open HR & Payroll > Employee.
2. Type `Kob` in Search.
3. Select the Emp No column header twice.

## Expected result
Only matching rows show. The column sorts ascending, then descending.

## Traceability
- Field rules: EmpNum `zzzzzzzzz9`, LastName `x(25)`, FirstName `x(15)`, Address `x(35)`
