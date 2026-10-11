// api-045-employee-get-404: Employee: Unknown key returns 404
// Module: HR & Payroll · Table: Employee · Endpoint: /api/hr-payroll/employees
import { test, expect } from '@playwright/test';

test("Employee: Unknown key returns 404", async ({ request }) => {
  const r = await request.get('/api/hr-payroll/employees/999999');
  expect(r.status()).toBe(404);
});
