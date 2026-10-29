// api-012-purchase-order-list-200: PurchaseOrder: List returns 200 and a page
// Module: Purchasing · Table: PurchaseOrder · Endpoint: /api/purchasing/purchase-orders
import { test, expect } from '@playwright/test';

test("PurchaseOrder: List returns 200 and a page", async ({ request }) => {
  const r = await request.get('/api/purchasing/purchase-orders?limit=10');
  expect(r.status()).toBe(200);
  const j = await r.json();
  expect(Array.isArray(j.items)).toBe(true);
  expect(j.total).toBeGreaterThanOrEqual(j.items.length);
});
