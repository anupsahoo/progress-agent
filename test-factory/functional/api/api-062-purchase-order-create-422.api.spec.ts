// api-062-purchase-order-create-422: PurchaseOrder: Invalid payload returns 422
// Module: Purchasing · Table: PurchaseOrder · Endpoint: /api/purchasing/purchase-orders
import { test, expect } from '@playwright/test';

test("PurchaseOrder: Invalid payload returns 422", async ({ request }) => {
  const r = await request.post('/api/purchasing/purchase-orders', { data: { ...{"PONum":8001,"DateEntered":"1998-05-05","SupplierIDNum":1,"ReceiveDate":"1998-07-29","POStatus":"Received"}, PONum: 0 } });
  expect([409, 422]).toContain(r.status());
});
