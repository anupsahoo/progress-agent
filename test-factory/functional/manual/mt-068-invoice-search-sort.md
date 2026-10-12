# mt-068-invoice-search-sort: Invoice: Search and sort the list

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
1. Open Billing & Invoicing > Invoice.
2. Type `1` in Search.
3. Select the Invoice Num column header twice.

## Expected result
Only matching rows show. The column sorts ascending, then descending.

## Traceability
- Field rules: Invoicenum `zzzzzzzzz9`, CustNum `>>>>9`, InvoiceDate `99/99/9999`, Amount `->>,>>9.99`
