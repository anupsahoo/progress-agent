// api-090-order-line-update-409: OrderLine: Stale version returns 409
// Module: Order Entry · Table: OrderLine · Endpoint: /api/order-entry/order-lines
import { test, expect } from '@playwright/test';

test("OrderLine: Stale version returns 409", async ({ request }) => {
  const cur = await (await request.get('/api/order-entry/order-lines/1/1')).json();
  const r = await request.put('/api/order-entry/order-lines/1/1', { data: cur, headers: { 'If-Match': String((cur.version ?? 0) + 7) } });
  expect(r.status()).toBe(409);
});
