// api-065-order-line-create-422: OrderLine: Invalid payload returns 422
// Module: Order Entry · Table: OrderLine · Endpoint: /api/order-entry/order-lines
import { test, expect } from '@playwright/test';

test("OrderLine: Invalid payload returns 422", async ({ request }) => {
  const r = await request.post('/api/order-entry/order-lines', { data: { ...{"Ordernum":1,"Linenum":1,"Itemnum":54,"Price":4.86,"Qty":30,"Discount":10,"ExtendedPrice":131.22,"OrderLineStatus":"Shipped"}, Ordernum: -1 } });
  expect([409, 422]).toContain(r.status());
});
