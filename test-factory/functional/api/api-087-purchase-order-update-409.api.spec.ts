// api-087-purchase-order-update-409: PurchaseOrder: Stale version returns 409
// Module: Purchasing · Table: PurchaseOrder · Endpoint: /api/purchasing/purchase-orders
import { test, expect } from '@playwright/test';

test("PurchaseOrder: Stale version returns 409", async ({ request }) => {
  const cur = await (await request.get('/api/purchasing/purchase-orders/8001')).json();
  const r = await request.put('/api/purchasing/purchase-orders/8001', { data: cur, headers: { 'If-Match': String((cur.version ?? 0) + 7) } });
  expect(r.status()).toBe(409);
});
