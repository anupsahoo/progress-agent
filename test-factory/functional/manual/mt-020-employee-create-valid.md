# mt-020-employee-create-valid: Employee: Create a valid record

| | |
|---|---|
| Module | HR & Payroll (wave 4) |
| Table | Employee |
| Legacy reference | `legacy/hr-payroll/employee_maint.p` |
| Priority | High |
| Type | Manual, UAT |

## Preconditions
- Signed in as a HR & Payroll user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open HR & Payroll > Employee maintenance.
2. Select New.
3. Enter Emp No: `1` (use a new key value for EmpNum).
4. Enter Last Name: `Koberlein` (use a new key value for EmpNum).
5. Enter First Name: `Kelly` (use a new key value for EmpNum).
6. Enter Address: `4500 Main Street` (use a new key value for EmpNum).
7. Enter Address2: `Apt 22` (use a new key value for EmpNum).
8. Enter City: `Houston` (use a new key value for EmpNum).
9. Select Save.

## Expected result
The record saves, the banner shows "Employee saved." and it appears in the list.

## Traceability
- Field rules: EmpNum `zzzzzzzzz9`, LastName `x(25)`, FirstName `x(15)`, Address `x(35)`
