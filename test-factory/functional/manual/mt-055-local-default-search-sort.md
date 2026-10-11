# mt-055-local-default-search-sort: LocalDefault: Search and sort the list

| | |
|---|---|
| Module | Sales & Territories (wave 1) |
| Table | LocalDefault |
| Legacy reference | `legacy/sales-territories/local_default_maint.p` |
| Priority | Medium |
| Type | Manual, UAT |

## Preconditions
- Signed in as a Sales & Territories user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open Sales & Territories > LocalDefault.
2. Type `Can` in Search.
3. Select the Country column header twice.

## Expected result
Only matching rows show. The column sorts ascending, then descending.

## Traceability
- Field rules: Country `x(20)`, Region1Label `x(15)`, Region2Label `x(15)`, PostalLabel `x(15)`
