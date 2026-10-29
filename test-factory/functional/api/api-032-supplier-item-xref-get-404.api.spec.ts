// api-032-supplier-item-xref-get-404: SupplierItemXref: Unknown key returns 404
// Module: Supplier Management · Table: SupplierItemXref · Endpoint: /api/supplier-management/supplier-item-xrefs
import { test, expect } from '@playwright/test';

test("SupplierItemXref: Unknown key returns 404", async ({ request }) => {
  const r = await request.get('/api/supplier-management/supplier-item-xrefs/999999/999999');
  expect(r.status()).toBe(404);
});
