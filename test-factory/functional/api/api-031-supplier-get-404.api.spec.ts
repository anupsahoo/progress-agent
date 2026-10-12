// api-031-supplier-get-404: Supplier: Unknown key returns 404
// Module: Supplier Management · Table: Supplier · Endpoint: /api/supplier-management/suppliers
import { test, expect } from '@playwright/test';

test("Supplier: Unknown key returns 404", async ({ request }) => {
  const r = await request.get('/api/supplier-management/suppliers/999999');
  expect(r.status()).toBe(404);
});
