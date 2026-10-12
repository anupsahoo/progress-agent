// api-010-warehouse-list-200: Warehouse: List returns 200 and a page
// Module: Warehousing · Table: Warehouse · Endpoint: /api/warehousing/warehouses
import { test, expect } from '@playwright/test';

test("Warehouse: List returns 200 and a page", async ({ request }) => {
  const r = await request.get('/api/warehousing/warehouses?limit=10');
  expect(r.status()).toBe(200);
  const j = await r.json();
  expect(Array.isArray(j.items)).toBe(true);
  expect(j.total).toBeGreaterThanOrEqual(j.items.length);
});
