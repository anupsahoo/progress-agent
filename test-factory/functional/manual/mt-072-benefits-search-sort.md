# mt-072-benefits-search-sort: Benefits: Search and sort the list

| | |
|---|---|
| Module | HR & Payroll (wave 4) |
| Table | Benefits |
| Legacy reference | `legacy/hr-payroll/benefits_maint.p` |
| Priority | Medium |
| Type | Manual, UAT |

## Preconditions
- Signed in as a HR & Payroll user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open HR & Payroll > Benefits.
2. Type `Aet` in Search.
3. Select the Emp No column header twice.

## Expected result
Only matching rows show. The column sorts ascending, then descending.

## Traceability
- Field rules: EmpNum `zzzzzzzzz9`, HealthCare `x(8)`, LifeInsurance `$>>,>>>,>>>`, Pension401K `>>,>>9`
