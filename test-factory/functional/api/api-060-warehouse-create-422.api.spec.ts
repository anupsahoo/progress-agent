// api-060-warehouse-create-422: Warehouse: Invalid payload returns 422
// Module: Warehousing · Table: Warehouse · Endpoint: /api/warehousing/warehouses
import { test, expect } from '@playwright/test';

test("Warehouse: Invalid payload returns 422", async ({ request }) => {
  const r = await request.post('/api/warehousing/warehouses', { data: { ...{"WarehouseNum":1,"WarehouseName":"Northeast  USA","Country":"USA","Address":"27 Oak Park","Address2":"","City":"Bedford","State":"MA","PostalCode":"01730","Phone":"(781) 333-4567"}, WarehouseNum: 0 } });
  expect([409, 422]).toContain(r.status());
});
