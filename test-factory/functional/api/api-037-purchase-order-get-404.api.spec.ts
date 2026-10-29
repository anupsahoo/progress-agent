// api-037-purchase-order-get-404: PurchaseOrder: Unknown key returns 404
// Module: Purchasing · Table: PurchaseOrder · Endpoint: /api/purchasing/purchase-orders
import { test, expect } from '@playwright/test';

test("PurchaseOrder: Unknown key returns 404", async ({ request }) => {
  const r = await request.get('/api/purchasing/purchase-orders/999999');
  expect(r.status()).toBe(404);
});
