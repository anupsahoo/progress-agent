# mt-067-ref-call-search-sort: RefCall: Search and sort the list

| | |
|---|---|
| Module | Credit Management (wave 3) |
| Table | RefCall |
| Legacy reference | `legacy/credit-management/ref_call_maint.p` |
| Priority | Medium |
| Type | Manual, UAT |

## Preconditions
- Signed in as a Credit Management user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open Credit Management > RefCall.
2. Type `000` in Search.
3. Select the Call Num column header twice.

## Expected result
Only matching rows show. The column sorts ascending, then descending.

## Traceability
- Field rules: CallNum `x(6)`, CustNum `>>>>9`, CallDate `99/99/9999`, SalesRep `x(4)`
