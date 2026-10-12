# mt-028-salesrep-reject-invalid: Salesrep: Reject values that break the field rules

| | |
|---|---|
| Module | Sales & Territories (wave 1) |
| Table | Salesrep |
| Legacy reference | `legacy/sales-territories/salesrep_maint.p` |
| Priority | Medium |
| Type | Manual, UAT |

## Preconditions
- Signed in as a Sales & Territories user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open Sales & Territories > Salesrep maintenance and open any record.
2. Enter Rep Name: `XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX`.
3. Select Save.

## Expected result
Save is blocked and the field shows: "at most 30 characters". Nothing is written.

## Traceability
- Field rules: SalesRep `x(4)`, RepName `x(30)`, Region `x(8)`
