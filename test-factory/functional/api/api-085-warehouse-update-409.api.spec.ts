// api-085-warehouse-update-409: Warehouse: Stale version returns 409
// Module: Warehousing · Table: Warehouse · Endpoint: /api/warehousing/warehouses
import { test, expect } from '@playwright/test';

test("Warehouse: Stale version returns 409", async ({ request }) => {
  const cur = await (await request.get('/api/warehousing/warehouses/1')).json();
  const r = await request.put('/api/warehousing/warehouses/1', { data: cur, headers: { 'If-Match': String((cur.version ?? 0) + 7) } });
  expect(r.status()).toBe(409);
});
