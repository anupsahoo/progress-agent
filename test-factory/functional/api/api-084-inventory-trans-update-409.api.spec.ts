// api-084-inventory-trans-update-409: InventoryTrans: Stale version returns 409
// Module: Inventory · Table: InventoryTrans · Endpoint: /api/inventory/inventory-transes
import { test, expect } from '@playwright/test';

test("InventoryTrans: Stale version returns 409", async ({ request }) => {
  const cur = await (await request.get('/api/inventory/inventory-transes/81')).json();
  const r = await request.put('/api/inventory/inventory-transes/81', { data: cur, headers: { 'If-Match': String((cur.version ?? 0) + 7) } });
  expect(r.status()).toBe(409);
});
