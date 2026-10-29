# mt-069-bill-to-search-sort: BillTo: Search and sort the list

| | |
|---|---|
| Module | Billing & Invoicing (wave 4) |
| Table | BillTo |
| Legacy reference | `legacy/billing-invoicing/bill_to_maint.p` |
| Priority | Medium |
| Type | Manual, UAT |

## Preconditions
- Signed in as a Billing & Invoicing user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open Billing & Invoicing > BillTo.
2. Type `AL ` in Search.
3. Select the Cust Num column header twice.

## Expected result
Only matching rows show. The column sorts ascending, then descending.

## Traceability
- Field rules: CustNum `>>>>9`, BillToID `zzzzzzzzz9`, Name `x(30)`, Address `x(35)`
