# mt-043-invoice-reject-invalid: Invoice: Reject values that break the field rules

| | |
|---|---|
| Module | Billing & Invoicing (wave 4) |
| Table | Invoice |
| Legacy reference | `legacy/billing-invoicing/invoice_maint.p` |
| Priority | Medium |
| Type | Manual, UAT |

## Preconditions
- Signed in as a Billing & Invoicing user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open Billing & Invoicing > Invoice maintenance and open any record.
2. Enter Invoice Num: `0`.
3. Select Save.

## Expected result
Save is blocked and the field shows: "Invoice number cannot be zero". Nothing is written.

## Traceability
- Field rules: Invoicenum `zzzzzzzzz9`, CustNum `>>>>9`, InvoiceDate `99/99/9999`, Amount `->>,>>9.99`
