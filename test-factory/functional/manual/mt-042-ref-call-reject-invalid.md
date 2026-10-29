# mt-042-ref-call-reject-invalid: RefCall: Reject values that break the field rules

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
1. Open Credit Management > RefCall maintenance and open any record.
2. Enter Cust Num: `0`.
3. Select Save.

## Expected result
Save is blocked and the field shows: "Customer number must be greater than zero". Nothing is written.

## Traceability
- Field rules: CallNum `x(6)`, CustNum `>>>>9`, CallDate `99/99/9999`, SalesRep `x(4)`
