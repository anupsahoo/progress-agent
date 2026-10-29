# mt-022-benefits-create-valid: Benefits: Create a valid record

| | |
|---|---|
| Module | HR & Payroll (wave 4) |
| Table | Benefits |
| Legacy reference | `legacy/hr-payroll/benefits_maint.p` |
| Priority | High |
| Type | Manual, UAT |

## Preconditions
- Signed in as a HR & Payroll user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open HR & Payroll > Benefits maintenance.
2. Select New.
3. Enter Emp No: `2` (use a new key value for EmpNum).
4. Enter Health Care: `Aetna PP` (use a new key value for EmpNum).
5. Enter Life Insurance: `45000` (use a new key value for EmpNum).
6. Enter Pension401K: `15` (use a new key value for EmpNum).
7. Enter Stock Purchase: `10` (use a new key value for EmpNum).
8. Enter Medical Spending: `1000` (use a new key value for EmpNum).
9. Select Save.

## Expected result
The record saves, the banner shows "Benefits saved." and it appears in the list.

## Traceability
- Field rules: EmpNum `zzzzzzzzz9`, HealthCare `x(8)`, LifeInsurance `$>>,>>>,>>>`, Pension401K `>>,>>9`
