// api-089-order-update-409: Order: Stale version returns 409
// Module: Order Entry · Table: Order · Endpoint: /api/order-entry/orders
import { test, expect } from '@playwright/test';

test("Order: Stale version returns 409", async ({ request }) => {
  const cur = await (await request.get('/api/order-entry/orders/1')).json();
  const r = await request.put('/api/order-entry/orders/1', { data: cur, headers: { 'If-Match': String((cur.version ?? 0) + 7) } });
  expect(r.status()).toBe(409);
});
