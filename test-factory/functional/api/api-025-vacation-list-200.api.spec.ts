// api-025-vacation-list-200: Vacation: List returns 200 and a page
// Module: HR & Payroll · Table: Vacation · Endpoint: /api/hr-payroll/vacations
import { test, expect } from '@playwright/test';

test("Vacation: List returns 200 and a page", async ({ request }) => {
  const r = await request.get('/api/hr-payroll/vacations?limit=10');
  expect(r.status()).toBe(200);
  const j = await r.json();
  expect(Array.isArray(j.items)).toBe(true);
  expect(j.total).toBeGreaterThanOrEqual(j.items.length);
});
