# mt-073-family-search-sort: Family: Search and sort the list

| | |
|---|---|
| Module | HR & Payroll (wave 4) |
| Table | Family |
| Legacy reference | `legacy/hr-payroll/family_maint.p` |
| Priority | Medium |
| Type | Manual, UAT |

## Preconditions
- Signed in as a HR & Payroll user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open HR & Payroll > Family.
2. Type `Jen` in Search.
3. Select the Emp No column header twice.

## Expected result
Only matching rows show. The column sorts ascending, then descending.

## Traceability
- Field rules: EmpNum `zzzzzzzzz9`, RelativeName `x(15)`, Relation `x(15)`, Birthdate `99/99/9999`
