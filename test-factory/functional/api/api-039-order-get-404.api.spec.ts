// api-039-order-get-404: Order: Unknown key returns 404
// Module: Order Entry · Table: Order · Endpoint: /api/order-entry/orders
import { test, expect } from '@playwright/test';

test("Order: Unknown key returns 404", async ({ request }) => {
  const r = await request.get('/api/order-entry/orders/999999');
  expect(r.status()).toBe(404);
});
