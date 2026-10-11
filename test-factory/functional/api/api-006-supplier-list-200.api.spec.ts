// api-006-supplier-list-200: Supplier: List returns 200 and a page
// Module: Supplier Management · Table: Supplier · Endpoint: /api/supplier-management/suppliers
import { test, expect } from '@playwright/test';

test("Supplier: List returns 200 and a page", async ({ request }) => {
  const r = await request.get('/api/supplier-management/suppliers?limit=10');
  expect(r.status()).toBe(200);
  const j = await r.json();
  expect(Array.isArray(j.items)).toBe(true);
  expect(j.total).toBeGreaterThanOrEqual(j.items.length);
});
