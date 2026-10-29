# mt-093-invoice-concurrent-edit: Invoice: Two users edit the same record

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
1. Sign in as user A and user B in two browsers.
2. Both open Invoice Invoicenum=1 and select Edit.
3. User A changes a field and saves.
4. User B changes a field and saves.

## Expected result
User A saves. User B sees "changed by someone else. Reload and try again." No update is lost.

## Traceability
- Field rules: Invoicenum `zzzzzzzzz9`, CustNum `>>>>9`, InvoiceDate `99/99/9999`, Amount `->>,>>9.99`
