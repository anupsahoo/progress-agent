# mt-051-customer-search-sort: Customer: Search and sort the list

| | |
|---|---|
| Module | Customer Management (wave 1) |
| Table | Customer |
| Legacy reference | `legacy/customer-management/customer_maint.p` |
| Priority | Medium |
| Type | Manual, UAT |

## Preconditions
- Signed in as a Customer Management user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open Customer Management > Customer.
2. Type `USA` in Search.
3. Select the Cust Num column header twice.

## Expected result
Only matching rows show. The column sorts ascending, then descending.

## Traceability
- Field rules: CustNum `>>>>9`, Country `x(20)`, Name `x(30)`, Address `x(35)`
