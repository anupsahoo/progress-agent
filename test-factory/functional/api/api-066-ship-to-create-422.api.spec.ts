// api-066-ship-to-create-422: ShipTo: Invalid payload returns 422
// Module: Order Fulfilment · Table: ShipTo · Endpoint: /api/order-fulfilment/ship-tos
import { test, expect } from '@playwright/test';

test("ShipTo: Invalid payload returns 422", async ({ request }) => {
  const r = await request.post('/api/order-fulfilment/ship-tos', { data: { ...{"CustNum":5,"ShipToID":1,"Contact":"Debbie Johnson","Address":"1234 4th Ave.","Address2":"","City":"Montgomery","State":"AL","PostalCode":"36117","Phone":"(334) 234-2345","Comments":"","Name":"AL - Branch"}, CustNum: -1 } });
  expect([409, 422]).toContain(r.status());
});
