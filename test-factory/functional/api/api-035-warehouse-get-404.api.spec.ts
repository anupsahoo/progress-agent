// api-035-warehouse-get-404: Warehouse: Unknown key returns 404
// Module: Warehousing · Table: Warehouse · Endpoint: /api/warehousing/warehouses
import { test, expect } from '@playwright/test';

test("Warehouse: Unknown key returns 404", async ({ request }) => {
  const r = await request.get('/api/warehousing/warehouses/999999');
  expect(r.status()).toBe(404);
});
