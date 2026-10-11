// api-018-invoice-list-200: Invoice: List returns 200 and a page
// Module: Billing & Invoicing · Table: Invoice · Endpoint: /api/billing-invoicing/invoices
import { test, expect } from '@playwright/test';

test("Invoice: List returns 200 and a page", async ({ request }) => {
  const r = await request.get('/api/billing-invoicing/invoices?limit=10');
  expect(r.status()).toBe(200);
  const j = await r.json();
  expect(Array.isArray(j.items)).toBe(true);
  expect(j.total).toBeGreaterThanOrEqual(j.items.length);
});
