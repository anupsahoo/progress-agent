// api-034-inventory-trans-get-404: InventoryTrans: Unknown key returns 404
// Module: Inventory · Table: InventoryTrans · Endpoint: /api/inventory/inventory-transes
import { test, expect } from '@playwright/test';

test("InventoryTrans: Unknown key returns 404", async ({ request }) => {
  const r = await request.get('/api/inventory/inventory-transes/999999');
  expect(r.status()).toBe(404);
});
