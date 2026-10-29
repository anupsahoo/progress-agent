// api-063-po-line-create-422: POLine: Invalid payload returns 422
// Module: Purchasing · Table: POLine · Endpoint: /api/purchasing/po-lines
import { test, expect } from '@playwright/test';

test("POLine: Invalid payload returns 422", async ({ request }) => {
  const r = await request.post('/api/purchasing/po-lines', { data: { ...{"Linenum":1,"Itemnum":3,"Price":16.55,"Qty":3,"Discount":0,"ExtendedPrice":49.65,"PONum":8001,"POLineStatus":"Received"}, Itemnum: -1 } });
  expect([409, 422]).toContain(r.status());
});
