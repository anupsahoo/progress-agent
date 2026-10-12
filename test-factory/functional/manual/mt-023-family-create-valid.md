# mt-023-family-create-valid: Family: Create a valid record

| | |
|---|---|
| Module | HR & Payroll (wave 4) |
| Table | Family |
| Legacy reference | `legacy/hr-payroll/family_maint.p` |
| Priority | High |
| Type | Manual, UAT |

## Preconditions
- Signed in as a HR & Payroll user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open HR & Payroll > Family maintenance.
2. Select New.
3. Enter Emp No: `1` (use a new key value for EmpNum, RelativeName).
4. Enter Relative Name: `Jenny Koberlein` (use a new key value for EmpNum, RelativeName).
5. Enter Relation: `Daughter` (use a new key value for EmpNum, RelativeName).
6. Enter Birthdate: `1998-01-15` (use a new key value for EmpNum, RelativeName).
7. Enter Covered On Benefits: `true` (use a new key value for EmpNum, RelativeName).
8. Enter Benefit Date: `1998-01-15` (use a new key value for EmpNum, RelativeName).
9. Select Save.

## Expected result
The record saves, the banner shows "Family saved." and it appears in the list.

## Traceability
- Field rules: EmpNum `zzzzzzzzz9`, RelativeName `x(15)`, Relation `x(15)`, Birthdate `99/99/9999`
