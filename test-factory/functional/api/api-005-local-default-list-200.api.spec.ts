// api-005-local-default-list-200: LocalDefault: List returns 200 and a page
// Module: Sales & Territories · Table: LocalDefault · Endpoint: /api/sales-territories/local-defaults
import { test, expect } from '@playwright/test';

test("LocalDefault: List returns 200 and a page", async ({ request }) => {
  const r = await request.get('/api/sales-territories/local-defaults?limit=10');
  expect(r.status()).toBe(200);
  const j = await r.json();
  expect(Array.isArray(j.items)).toBe(true);
  expect(j.total).toBeGreaterThanOrEqual(j.items.length);
});
