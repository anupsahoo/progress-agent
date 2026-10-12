# mt-092-ref-call-concurrent-edit: RefCall: Two users edit the same record

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
1. Sign in as user A and user B in two browsers.
2. Both open RefCall CallNum=000001 and select Edit.
3. User A changes a field and saves.
4. User B changes a field and saves.

## Expected result
User A saves. User B sees "changed by someone else. Reload and try again." No update is lost.

## Traceability
- Field rules: CallNum `x(6)`, CustNum `>>>>9`, CallDate `99/99/9999`, SalesRep `x(4)`
