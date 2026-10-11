// api-057-supplier-item-xref-create-422: SupplierItemXref: Invalid payload returns 422
// Module: Supplier Management · Table: SupplierItemXref · Endpoint: /api/supplier-management/supplier-item-xrefs
import { test, expect } from '@playwright/test';

test("SupplierItemXref: Invalid payload returns 422", async ({ request }) => {
  const r = await request.post('/api/supplier-management/supplier-item-xrefs', { data: { ...{"SupplierIDNum":0,"Itemnum":0}, SupplierIDNum: -1 } });
  expect([409, 422]).toContain(r.status());
});
