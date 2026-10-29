// api-021-department-list-200: Department: List returns 200 and a page
// Module: HR & Payroll · Table: Department · Endpoint: /api/hr-payroll/departments
import { test, expect } from '@playwright/test';

test("Department: List returns 200 and a page", async ({ request }) => {
  const r = await request.get('/api/hr-payroll/departments?limit=10');
  expect(r.status()).toBe(200);
  const j = await r.json();
  expect(Array.isArray(j.items)).toBe(true);
  expect(j.total).toBeGreaterThanOrEqual(j.items.length);
});
