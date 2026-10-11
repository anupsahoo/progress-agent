# mt-046-department-reject-invalid: Department: Reject values that break the field rules

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
1. Open HR & Payroll > Department maintenance and open any record.
2. Enter Dept Name: `XXXXXXXXXXXXXXXX`.
3. Select Save.

## Expected result
Save is blocked and the field shows: "at most 15 characters". Nothing is written.

## Traceability
- Field rules: DeptCode `x(3)`, DeptName `x(15)`
