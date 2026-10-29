// api-015-order-line-list-200: OrderLine: List returns 200 and a page
// Module: Order Entry · Table: OrderLine · Endpoint: /api/order-entry/order-lines
import { test, expect } from '@playwright/test';

test("OrderLine: List returns 200 and a page", async ({ request }) => {
  const r = await request.get('/api/order-entry/order-lines?limit=10');
  expect(r.status()).toBe(200);
  const j = await r.json();
  expect(Array.isArray(j.items)).toBe(true);
  expect(j.total).toBeGreaterThanOrEqual(j.items.length);
});
