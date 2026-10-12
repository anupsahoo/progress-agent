// api-019-bill-to-list-200: BillTo: List returns 200 and a page
// Module: Billing & Invoicing · Table: BillTo · Endpoint: /api/billing-invoicing/bill-tos
import { test, expect } from '@playwright/test';

test("BillTo: List returns 200 and a page", async ({ request }) => {
  const r = await request.get('/api/billing-invoicing/bill-tos?limit=10');
  expect(r.status()).toBe(200);
  const j = await r.json();
  expect(Array.isArray(j.items)).toBe(true);
  expect(j.total).toBeGreaterThanOrEqual(j.items.length);
});
