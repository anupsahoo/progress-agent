// api-083-item-update-409: Item: Stale version returns 409
// Module: Inventory · Table: Item · Endpoint: /api/inventory/items
import { test, expect } from '@playwright/test';

test("Item: Stale version returns 409", async ({ request }) => {
  const cur = await (await request.get('/api/inventory/items/1')).json();
  const r = await request.put('/api/inventory/items/1', { data: cur, headers: { 'If-Match': String((cur.version ?? 0) + 7) } });
  expect(r.status()).toBe(409);
});
