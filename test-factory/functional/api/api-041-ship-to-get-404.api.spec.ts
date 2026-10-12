// api-041-ship-to-get-404: ShipTo: Unknown key returns 404
// Module: Order Fulfilment · Table: ShipTo · Endpoint: /api/order-fulfilment/ship-tos
import { test, expect } from '@playwright/test';

test("ShipTo: Unknown key returns 404", async ({ request }) => {
  const r = await request.get('/api/order-fulfilment/ship-tos/999999/999999');
  expect(r.status()).toBe(404);
});
