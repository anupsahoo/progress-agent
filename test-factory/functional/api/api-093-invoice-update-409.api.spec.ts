// api-093-invoice-update-409: Invoice: Stale version returns 409
// Module: Billing & Invoicing · Table: Invoice · Endpoint: /api/billing-invoicing/invoices
import { test, expect } from '@playwright/test';

test("Invoice: Stale version returns 409", async ({ request }) => {
  const cur = await (await request.get('/api/billing-invoicing/invoices/1')).json();
  const r = await request.put('/api/billing-invoicing/invoices/1', { data: cur, headers: { 'If-Match': String((cur.version ?? 0) + 7) } });
  expect(r.status()).toBe(409);
});
