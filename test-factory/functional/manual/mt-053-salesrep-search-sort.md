# mt-053-salesrep-search-sort: Salesrep: Search and sort the list

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
1. Open Sales & Territories > Salesrep.
2. Type `BBB` in Search.
3. Select the Sales Rep column header twice.

## Expected result
Only matching rows show. The column sorts ascending, then descending.

## Traceability
- Field rules: SalesRep `x(4)`, RepName `x(30)`, Region `x(8)`
