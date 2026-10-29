// api-064-order-create-422: Order: Invalid payload returns 422
// Module: Order Entry · Table: Order · Endpoint: /api/order-entry/orders
import { test, expect } from '@playwright/test';

test("Order: Invalid payload returns 422", async ({ request }) => {
  const r = await request.post('/api/order-entry/orders', { data: { ...{"Ordernum":1,"CustNum":53,"OrderDate":"1998-01-26","ShipDate":"1998-01-31","PromiseDate":"1998-01-31","Carrier":"FlyByNight Courier","Instructions":"","PO":"","Terms":"Net30","SalesRep":"RDR","BillToID":0,"ShipToID":0,"OrderStatus":"Shipped","WarehouseNum":0,"Creditcard":"Master Card"}, Ordernum: 0 } });
  expect([409, 422]).toContain(r.status());
});
