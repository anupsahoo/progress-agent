// api-047-benefits-get-404: Benefits: Unknown key returns 404
// Module: HR & Payroll · Table: Benefits · Endpoint: /api/hr-payroll/benefitses
import { test, expect } from '@playwright/test';

test("Benefits: Unknown key returns 404", async ({ request }) => {
  const r = await request.get('/api/hr-payroll/benefitses/999999');
  expect(r.status()).toBe(404);
});
