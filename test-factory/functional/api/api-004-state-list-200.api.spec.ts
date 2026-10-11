// api-004-state-list-200: State: List returns 200 and a page
// Module: Sales & Territories · Table: State · Endpoint: /api/sales-territories/states
import { test, expect } from '@playwright/test';

test("State: List returns 200 and a page", async ({ request }) => {
  const r = await request.get('/api/sales-territories/states?limit=10');
  expect(r.status()).toBe(200);
  const j = await r.json();
  expect(Array.isArray(j.items)).toBe(true);
  expect(j.total).toBeGreaterThanOrEqual(j.items.length);
});
