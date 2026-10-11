// api-081-supplier-update-409: Supplier: Stale version returns 409
// Module: Supplier Management · Table: Supplier · Endpoint: /api/supplier-management/suppliers
import { test, expect } from '@playwright/test';

test("Supplier: Stale version returns 409", async ({ request }) => {
  const cur = await (await request.get('/api/supplier-management/suppliers/1')).json();
  const r = await request.put('/api/supplier-management/suppliers/1', { data: cur, headers: { 'If-Match': String((cur.version ?? 0) + 7) } });
  expect(r.status()).toBe(409);
});
