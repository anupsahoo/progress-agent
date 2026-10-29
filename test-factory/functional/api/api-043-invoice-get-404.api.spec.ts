// api-043-invoice-get-404: Invoice: Unknown key returns 404
// Module: Billing & Invoicing · Table: Invoice · Endpoint: /api/billing-invoicing/invoices
import { test, expect } from '@playwright/test';

test("Invoice: Unknown key returns 404", async ({ request }) => {
  const r = await request.get('/api/billing-invoicing/invoices/999999');
  expect(r.status()).toBe(404);
});
