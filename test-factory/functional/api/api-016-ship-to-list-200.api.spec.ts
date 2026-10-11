// api-016-ship-to-list-200: ShipTo: List returns 200 and a page
// Module: Order Fulfilment · Table: ShipTo · Endpoint: /api/order-fulfilment/ship-tos
import { test, expect } from '@playwright/test';

test("ShipTo: List returns 200 and a page", async ({ request }) => {
  const r = await request.get('/api/order-fulfilment/ship-tos?limit=10');
  expect(r.status()).toBe(200);
  const j = await r.json();
  expect(Array.isArray(j.items)).toBe(true);
  expect(j.total).toBeGreaterThanOrEqual(j.items.length);
});
