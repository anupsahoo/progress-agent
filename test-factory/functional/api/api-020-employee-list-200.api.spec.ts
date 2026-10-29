// api-020-employee-list-200: Employee: List returns 200 and a page
// Module: HR & Payroll · Table: Employee · Endpoint: /api/hr-payroll/employees
import { test, expect } from '@playwright/test';

test("Employee: List returns 200 and a page", async ({ request }) => {
  const r = await request.get('/api/hr-payroll/employees?limit=10');
  expect(r.status()).toBe(200);
  const j = await r.json();
  expect(Array.isArray(j.items)).toBe(true);
  expect(j.total).toBeGreaterThanOrEqual(j.items.length);
});
