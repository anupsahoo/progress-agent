// api-033-item-get-404: Item: Unknown key returns 404
// Module: Inventory · Table: Item · Endpoint: /api/inventory/items
import { test, expect } from '@playwright/test';

test("Item: Unknown key returns 404", async ({ request }) => {
  const r = await request.get('/api/inventory/items/999999');
  expect(r.status()).toBe(404);
});
