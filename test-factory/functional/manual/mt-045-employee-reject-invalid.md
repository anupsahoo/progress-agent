# mt-045-employee-reject-invalid: Employee: Reject values that break the field rules

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
1. Open HR & Payroll > Employee maintenance and open any record.
2. Enter Last Name: `XXXXXXXXXXXXXXXXXXXXXXXXXX`.
3. Select Save.

## Expected result
Save is blocked and the field shows: "at most 25 characters". Nothing is written.

## Traceability
- Field rules: EmpNum `zzzzzzzzz9`, LastName `x(25)`, FirstName `x(15)`, Address `x(35)`
