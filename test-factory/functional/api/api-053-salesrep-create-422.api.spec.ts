// api-053-salesrep-create-422: Salesrep: Invalid payload returns 422
// Module: Sales & Territories · Table: Salesrep · Endpoint: /api/sales-territories/salesreps
import { test, expect } from '@playwright/test';

test("Salesrep: Invalid payload returns 422", async ({ request }) => {
  const r = await request.post('/api/sales-territories/salesreps', { data: { ...{"SalesRep":"BBB","RepName":"Brawn , Bubba B.","Region":"East","MonthQuota":[1600,1648,1697,1748,1800,1854,1910,1967,2026,2087,2150,2215]}, RepName: "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" } });
  expect([409, 422]).toContain(r.status());
});
