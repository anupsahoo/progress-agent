# mt-095-employee-concurrent-edit: Employee: Two users edit the same record

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
1. Sign in as user A and user B in two browsers.
2. Both open Employee EmpNum=1 and select Edit.
3. User A changes a field and saves.
4. User B changes a field and saves.

## Expected result
User A saves. User B sees "changed by someone else. Reload and try again." No update is lost.

## Traceability
- Field rules: EmpNum `zzzzzzzzz9`, LastName `x(25)`, FirstName `x(15)`, Address `x(35)`
