// api-003-salesrep-list-200: Salesrep: List returns 200 and a page
// Module: Sales & Territories · Table: Salesrep · Endpoint: /api/sales-territories/salesreps
import { test, expect } from '@playwright/test';

test("Salesrep: List returns 200 and a page", async ({ request }) => {
  const r = await request.get('/api/sales-territories/salesreps?limit=10');
  expect(r.status()).toBe(200);
  const j = await r.json();
  expect(Array.isArray(j.items)).toBe(true);
  expect(j.total).toBeGreaterThanOrEqual(j.items.length);
});
