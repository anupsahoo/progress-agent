# mt-026-customer-reject-invalid: Customer: Reject values that break the field rules

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
1. Open Customer Management > Customer maintenance and open any record.
2. Enter Cust Num: `0`.
3. Select Save.

## Expected result
Save is blocked and the field shows: "Customer number must be greater than zero". Nothing is written.

## Traceability
- Field rules: CustNum `>>>>9`, Country `x(20)`, Name `x(30)`, Address `x(35)`
