# mt-054-state-search-sort: State: Search and sort the list

| | |
|---|---|
| Module | Sales & Territories (wave 1) |
| Table | State |
| Legacy reference | `legacy/sales-territories/state_maint.p` |
| Priority | Medium |
| Type | Manual, UAT |

## Preconditions
- Signed in as a Sales & Territories user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open Sales & Territories > State.
2. Type `AK` in Search.
3. Select the State column header twice.

## Expected result
Only matching rows show. The column sorts ascending, then descending.

## Traceability
- Field rules: State `x(20)`, StateName `x(20)`, Region `x(8)`
