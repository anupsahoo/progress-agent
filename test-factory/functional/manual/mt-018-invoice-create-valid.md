# mt-018-invoice-create-valid: Invoice: Create a valid record

| | |
|---|---|
| Module | Billing & Invoicing (wave 4) |
| Table | Invoice |
| Legacy reference | `legacy/billing-invoicing/invoice_maint.p` |
| Priority | High |
| Type | Manual, UAT |

## Preconditions
- Signed in as a Billing & Invoicing user.
- Test data from `test-factory/test-data` (synthetic, sports2000 sample).

## Steps
1. Open Billing & Invoicing > Invoice maintenance.
2. Select New.
3. Enter Invoice Num: `1` (use a new key value for Invoicenum).
4. Enter Cust Num: `53` (use a new key value for Invoicenum).
5. Enter Invoice Date: `1998-01-27` (use a new key value for Invoicenum).
6. Enter Amount: `4402.02` (use a new key value for Invoicenum).
7. Enter Total Paid: `5062.32` (use a new key value for Invoicenum).
8. Enter Adjustment: `0` (use a new key value for Invoicenum).
9. Select Save.

## Expected result
The record saves, the banner shows "Invoice saved." and it appears in the list.

## Traceability
- Field rules: Invoicenum `zzzzzzzzz9`, CustNum `>>>>9`, InvoiceDate `99/99/9999`, Amount `->>,>>9.99`
