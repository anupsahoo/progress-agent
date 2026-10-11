// api-050-vacation-get-404: Vacation: Unknown key returns 404
// Module: HR & Payroll · Table: Vacation · Endpoint: /api/hr-payroll/vacations
import { test, expect } from '@playwright/test';

test("Vacation: Unknown key returns 404", async ({ request }) => {
  const r = await request.get('/api/hr-payroll/vacations/999999/999999');
  expect(r.status()).toBe(404);
});
