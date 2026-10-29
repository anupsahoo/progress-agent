# mt-094-bill-to-concurrent-edit: BillTo: Two users edit the same record

| | |
|---|---|
| Module | Billing & Invoicing (wave 4) |
| Table | BillTo |
| Legacy reference | `legacy/billing-invoicing/bill_to_maint.p` |
| Priority | High |
| Type | Manual, UAT |

## Preconditions
- Signed in as a Billing & Invoicing user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Sign in as user A and user B in two browsers.
2. Both open BillTo CustNum=5, BillToID=1 and select Edit.
3. User A changes a field and saves.
4. User B changes a field and saves.

## Expected result
User A saves. User B sees "changed by someone else. Reload and try again." No update is lost.

## Traceability
- Field rules: CustNum `>>>>9`, BillToID `zzzzzzzzz9`, Name `x(30)`, Address `x(35)`
