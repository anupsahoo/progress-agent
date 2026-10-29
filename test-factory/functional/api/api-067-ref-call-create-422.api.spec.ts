// api-067-ref-call-create-422: RefCall: Invalid payload returns 422
// Module: Credit Management · Table: RefCall · Endpoint: /api/credit-management/ref-calls
import { test, expect } from '@playwright/test';

test("RefCall: Invalid payload returns 422", async ({ request }) => {
  const r = await request.post('/api/credit-management/ref-calls', { data: { ...{"CallNum":"000001","CustNum":2,"CallDate":"1998-01-05","SalesRep":"DKP","Parent":"","Txt":"Ordered frisbees. We sent Ultimate style, they want Guts. Guts are on backorder, I told them they would receive them by May."}, CustNum: 0 } });
  expect([409, 422]).toContain(r.status());
});
