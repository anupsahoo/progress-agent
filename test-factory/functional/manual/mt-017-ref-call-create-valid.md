# mt-017-ref-call-create-valid: RefCall: Create a valid record

| | |
|---|---|
| Module | Credit Management (wave 3) |
| Table | RefCall |
| Legacy reference | `legacy/credit-management/ref_call_maint.p` |
| Priority | High |
| Type | Manual, UAT |

## Preconditions
- Signed in as a Credit Management user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open Credit Management > RefCall maintenance.
2. Select New.
3. Enter Call Num: `000001` (use a new key value for CallNum).
4. Enter Cust Num: `2` (use a new key value for CallNum).
5. Enter Call Date: `1998-01-05` (use a new key value for CallNum).
6. Enter Sales Rep: `DKP` (use a new key value for CallNum).
7. Enter Parent: `` (use a new key value for CallNum).
8. Enter Txt: `Ordered frisbees. We sent Ultimate style, they want Guts. Guts are on backorder, I told them they would receive them by May.` (use a new key value for CallNum).
9. Select Save.

## Expected result
The record saves, the banner shows "RefCall saved." and it appears in the list.

## Traceability
- Field rules: CallNum `x(6)`, CustNum `>>>>9`, CallDate `99/99/9999`, SalesRep `x(4)`
