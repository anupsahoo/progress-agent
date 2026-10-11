# mt-044-bill-to-reject-invalid: BillTo: Reject values that break the field rules

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
1. Open Billing & Invoicing > BillTo maintenance and open any record.
2. Enter Cust Num: `-1`.
3. Select Save.

## Expected result
Save is blocked and the field shows: "Customer number must be greater than zero". Nothing is written.

## Traceability
- Field rules: CustNum `>>>>9`, BillToID `zzzzzzzzz9`, Name `x(30)`, Address `x(35)`
