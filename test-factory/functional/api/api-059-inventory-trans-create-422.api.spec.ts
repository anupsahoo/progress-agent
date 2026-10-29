// api-059-inventory-trans-create-422: InventoryTrans: Invalid payload returns 422
// Module: Inventory · Table: InventoryTrans · Endpoint: /api/inventory/inventory-transes
import { test, expect } from '@playwright/test';

test("InventoryTrans: Invalid payload returns 422", async ({ request }) => {
  const r = await request.post('/api/inventory/inventory-transes', { data: { ...{"InvTransNum":81,"WarehouseNum":1,"BinNum":760,"Qty":5,"Itemnum":45,"TransDate":"1998-07-29","InvType":"Receiving","PONum":8001,"Ordernum":0,"Transtime":"15:19"}, Itemnum: -1 } });
  expect([409, 422]).toContain(r.status());
});
