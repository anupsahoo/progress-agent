// api-040-order-line-get-404: OrderLine: Unknown key returns 404
// Module: Order Entry · Table: OrderLine · Endpoint: /api/order-entry/order-lines
import { test, expect } from '@playwright/test';

test("OrderLine: Unknown key returns 404", async ({ request }) => {
  const r = await request.get('/api/order-entry/order-lines/999999/999999');
  expect(r.status()).toBe(404);
});
