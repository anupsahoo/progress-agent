// api-082-supplier-item-xref-update-409: SupplierItemXref: Stale version returns 409
// Module: Supplier Management · Table: SupplierItemXref · Endpoint: /api/supplier-management/supplier-item-xrefs
import { test, expect } from '@playwright/test';

test("SupplierItemXref: Stale version returns 409", async ({ request }) => {
  const cur = await (await request.get('/api/supplier-management/supplier-item-xrefs/0/0')).json();
  const r = await request.put('/api/supplier-management/supplier-item-xrefs/0/0', { data: cur, headers: { 'If-Match': String((cur.version ?? 0) + 7) } });
  expect(r.status()).toBe(409);
});
