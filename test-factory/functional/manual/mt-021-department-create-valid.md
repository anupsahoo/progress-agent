# mt-021-department-create-valid: Department: Create a valid record

| | |
|---|---|
| Module | HR & Payroll (wave 4) |
| Table | Department |
| Legacy reference | `legacy/hr-payroll/department_maint.p` |
| Priority | High |
| Type | Manual, UAT |

## Preconditions
- Signed in as a HR & Payroll user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open HR & Payroll > Department maintenance.
2. Select New.
3. Enter Dept Code: `100` (use a new key value for DeptCode).
4. Enter Dept Name: `Consulting` (use a new key value for DeptCode).
5. Select Save.

## Expected result
The record saves, the banner shows "Department saved." and it appears in the list.

## Traceability
- Field rules: DeptCode `x(3)`, DeptName `x(15)`
