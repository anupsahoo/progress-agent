# mt-025-vacation-create-valid: Vacation: Create a valid record

| | |
|---|---|
| Module | HR & Payroll (wave 4) |
| Table | Vacation |
| Legacy reference | `legacy/hr-payroll/vacation_maint.p` |
| Priority | High |
| Type | Manual, UAT |

## Preconditions
- Signed in as a HR & Payroll user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open HR & Payroll > Vacation maintenance.
2. Select New.
3. Enter Emp No: `1` (use a new key value for EmpNum, StartDate).
4. Enter Start Date: `1998-01-02` (use a new key value for EmpNum, StartDate).
5. Enter End Date: `1998-01-02` (use a new key value for EmpNum, StartDate).
6. Select Save.

## Expected result
The record saves, the banner shows "Vacation saved." and it appears in the list.

## Traceability
- Field rules: EmpNum `zzzzzzzzz9`, StartDate `99/99/9999`, EndDate `99/99/9999`
