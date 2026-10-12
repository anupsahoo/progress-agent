# mt-003-salesrep-create-valid: Salesrep: Create a valid record

| | |
|---|---|
| Module | Sales & Territories (wave 1) |
| Table | Salesrep |
| Legacy reference | `legacy/sales-territories/salesrep_maint.p` |
| Priority | High |
| Type | Manual, UAT |

## Preconditions
- Signed in as a Sales & Territories user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open Sales & Territories > Salesrep maintenance.
2. Select New.
3. Enter Sales Rep: `BBB` (use a new key value for SalesRep).
4. Enter Rep Name: `Brawn , Bubba B.` (use a new key value for SalesRep).
5. Enter Region: `East` (use a new key value for SalesRep).
6. Select Save.

## Expected result
The record saves, the banner shows "Salesrep saved." and it appears in the list.

## Traceability
- Field rules: SalesRep `x(4)`, RepName `x(30)`, Region `x(8)`
