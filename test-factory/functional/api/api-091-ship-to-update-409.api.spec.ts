// api-091-ship-to-update-409: ShipTo: Stale version returns 409
// Module: Order Fulfilment · Table: ShipTo · Endpoint: /api/order-fulfilment/ship-tos
import { test, expect } from '@playwright/test';

test("ShipTo: Stale version returns 409", async ({ request }) => {
  const cur = await (await request.get('/api/order-fulfilment/ship-tos/5/1')).json();
  const r = await request.put('/api/order-fulfilment/ship-tos/5/1', { data: cur, headers: { 'If-Match': String((cur.version ?? 0) + 7) } });
  expect(r.status()).toBe(409);
});
