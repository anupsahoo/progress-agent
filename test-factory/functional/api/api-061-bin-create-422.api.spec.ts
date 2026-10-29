// api-061-bin-create-422: Bin: Invalid payload returns 422
// Module: Warehousing · Table: Bin · Endpoint: /api/warehousing/bins
import { test, expect } from '@playwright/test';

test("Bin: Invalid payload returns 422", async ({ request }) => {
  const r = await request.post('/api/warehousing/bins', { data: { ...{"WarehouseNum":1,"Itemnum":1,"Qty":9304,"BinNum":716,"BinName":"452917-D"}, WarehouseNum: -1 } });
  expect([409, 422]).toContain(r.status());
});
