// api-014-order-list-200: Order: List returns 200 and a page
// Module: Order Entry · Table: Order · Endpoint: /api/order-entry/orders
import { test, expect } from '@playwright/test';

test("Order: List returns 200 and a page", async ({ request }) => {
  const r = await request.get('/api/order-entry/orders?limit=10');
  expect(r.status()).toBe(200);
  const j = await r.json();
  expect(Array.isArray(j.items)).toBe(true);
  expect(j.total).toBeGreaterThanOrEqual(j.items.length);
});
