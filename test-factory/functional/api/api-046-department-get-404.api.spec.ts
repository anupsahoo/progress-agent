// api-046-department-get-404: Department: Unknown key returns 404
// Module: HR & Payroll · Table: Department · Endpoint: /api/hr-payroll/departments
import { test, expect } from '@playwright/test';

test("Department: Unknown key returns 404", async ({ request }) => {
  const r = await request.get('/api/hr-payroll/departments/999999');
  expect(r.status()).toBe(404);
});
