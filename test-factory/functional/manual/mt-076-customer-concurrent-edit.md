# mt-076-customer-concurrent-edit: Customer: Two users edit the same record

| | |
|---|---|
| Module | Customer Management (wave 1) |
| Table | Customer |
| Legacy reference | `legacy/customer-management/customer_maint.p` |
| Priority | High |
| Type | Manual, UAT |

## Preconditions
- Signed in as a Customer Management user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Sign in as user A and user B in two browsers.
2. Both open Customer CustNum=1 and select Edit.
3. User A changes a field and saves.
4. User B changes a field and saves.

## Expected result
User A saves. User B sees "changed by someone else. Reload and try again." No update is lost.

## Traceability
- Field rules: CustNum `>>>>9`, Country `x(20)`, Name `x(30)`, Address `x(35)`
