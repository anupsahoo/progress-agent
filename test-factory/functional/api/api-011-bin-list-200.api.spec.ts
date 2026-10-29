// api-011-bin-list-200: Bin: List returns 200 and a page
// Module: Warehousing · Table: Bin · Endpoint: /api/warehousing/bins
import { test, expect } from '@playwright/test';

test("Bin: List returns 200 and a page", async ({ request }) => {
  const r = await request.get('/api/warehousing/bins?limit=10');
  expect(r.status()).toBe(200);
  const j = await r.json();
  expect(Array.isArray(j.items)).toBe(true);
  expect(j.total).toBeGreaterThanOrEqual(j.items.length);
});
