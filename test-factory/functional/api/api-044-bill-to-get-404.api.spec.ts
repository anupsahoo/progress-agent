// api-044-bill-to-get-404: BillTo: Unknown key returns 404
// Module: Billing & Invoicing · Table: BillTo · Endpoint: /api/billing-invoicing/bill-tos
import { test, expect } from '@playwright/test';

test("BillTo: Unknown key returns 404", async ({ request }) => {
  const r = await request.get('/api/billing-invoicing/bill-tos/999999/999999');
  expect(r.status()).toBe(404);
});
