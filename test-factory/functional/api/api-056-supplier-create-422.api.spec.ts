// api-056-supplier-create-422: Supplier: Invalid payload returns 422
// Module: Supplier Management · Table: Supplier · Endpoint: /api/supplier-management/suppliers
import { test, expect } from '@playwright/test';

test("Supplier: Invalid payload returns 422", async ({ request }) => {
  const r = await request.post('/api/supplier-management/suppliers', { data: { ...{"SupplierIDNum":1,"Name":"GolfWorld Supplies","Address":"276 North Street","Address2":"-","City":"Boston","State":"MA","PostalCode":"02114","Country":"USA","Phone":"(617) 450-0087","Comments":"Ship all products 2nd Day Air.","Password":"demo","LoginDate":"1998-03-26","ShipAmount":100,"Discount":47}, SupplierIDNum: 0 } });
  expect([409, 422]).toContain(r.status());
});
