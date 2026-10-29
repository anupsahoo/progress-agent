// api-048-family-get-404: Family: Unknown key returns 404
// Module: HR & Payroll · Table: Family · Endpoint: /api/hr-payroll/families
import { test, expect } from '@playwright/test';

test("Family: Unknown key returns 404", async ({ request }) => {
  const r = await request.get('/api/hr-payroll/families/999999/999999');
  expect(r.status()).toBe(404);
});
