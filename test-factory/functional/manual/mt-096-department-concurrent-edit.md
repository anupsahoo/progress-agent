# mt-096-department-concurrent-edit: Department: Two users edit the same record

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
1. Sign in as user A and user B in two browsers.
2. Both open Department DeptCode=100 and select Edit.
3. User A changes a field and saves.
4. User B changes a field and saves.

## Expected result
User A saves. User B sees "changed by someone else. Reload and try again." No update is lost.

## Traceability
- Field rules: DeptCode `x(3)`, DeptName `x(15)`
