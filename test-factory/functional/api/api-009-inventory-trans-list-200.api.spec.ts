// api-009-inventory-trans-list-200: InventoryTrans: List returns 200 and a page
// Module: Inventory · Table: InventoryTrans · Endpoint: /api/inventory/inventory-transes
import { test, expect } from '@playwright/test';

test("InventoryTrans: List returns 200 and a page", async ({ request }) => {
  const r = await request.get('/api/inventory/inventory-transes?limit=10');
  expect(r.status()).toBe(200);
  const j = await r.json();
  expect(Array.isArray(j.items)).toBe(true);
  expect(j.total).toBeGreaterThanOrEqual(j.items.length);
});
