// api-008-item-list-200: Item: List returns 200 and a page
// Module: Inventory · Table: Item · Endpoint: /api/inventory/items
import { test, expect } from '@playwright/test';

test("Item: List returns 200 and a page", async ({ request }) => {
  const r = await request.get('/api/inventory/items?limit=10');
  expect(r.status()).toBe(200);
  const j = await r.json();
  expect(Array.isArray(j.items)).toBe(true);
  expect(j.total).toBeGreaterThanOrEqual(j.items.length);
});
