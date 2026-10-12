// api-028-salesrep-get-404: Salesrep: Unknown key returns 404
// Module: Sales & Territories · Table: Salesrep · Endpoint: /api/sales-territories/salesreps
import { test, expect } from '@playwright/test';

test("Salesrep: Unknown key returns 404", async ({ request }) => {
  const r = await request.get('/api/sales-territories/salesreps/999999');
  expect(r.status()).toBe(404);
});
