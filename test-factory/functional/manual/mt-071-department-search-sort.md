# mt-071-department-search-sort: Department: Search and sort the list

| | |
|---|---|
| Module | HR & Payroll (wave 4) |
| Table | Department |
| Legacy reference | `legacy/hr-payroll/department_maint.p` |
| Priority | Medium |
| Type | Manual, UAT |

## Preconditions
- Signed in as a HR & Payroll user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open HR & Payroll > Department.
2. Type `100` in Search.
3. Select the Dept Code column header twice.

## Expected result
Only matching rows show. The column sorts ascending, then descending.

## Traceability
- Field rules: DeptCode `x(3)`, DeptName `x(15)`
