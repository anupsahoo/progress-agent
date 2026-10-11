// api-068-invoice-create-422: Invoice: Invalid payload returns 422
// Module: Billing & Invoicing · Table: Invoice · Endpoint: /api/billing-invoicing/invoices
import { test, expect } from '@playwright/test';

test("Invoice: Invalid payload returns 422", async ({ request }) => {
  const r = await request.post('/api/billing-invoicing/invoices', { data: { ...{"Invoicenum":1,"CustNum":53,"InvoiceDate":"1998-01-27","Amount":4402.02,"TotalPaid":5062.32,"Adjustment":0,"OrderNum":1,"ShipCharge":660.3}, Invoicenum: 0 } });
  expect([409, 422]).toContain(r.status());
});
