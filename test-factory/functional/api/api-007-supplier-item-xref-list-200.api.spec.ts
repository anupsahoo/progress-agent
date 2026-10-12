// api-007-supplier-item-xref-list-200: SupplierItemXref: List returns 200 and a page
// Module: Supplier Management · Table: SupplierItemXref · Endpoint: /api/supplier-management/supplier-item-xrefs
import { test, expect } from '@playwright/test';

test("SupplierItemXref: List returns 200 and a page", async ({ request }) => {
  const r = await request.get('/api/supplier-management/supplier-item-xrefs?limit=10');
  expect(r.status()).toBe(200);
  const j = await r.json();
  expect(Array.isArray(j.items)).toBe(true);
  expect(j.total).toBeGreaterThanOrEqual(j.items.length);
});
