// api-022-benefits-list-200: Benefits: List returns 200 and a page
// Module: HR & Payroll · Table: Benefits · Endpoint: /api/hr-payroll/benefitses
import { test, expect } from '@playwright/test';

test("Benefits: List returns 200 and a page", async ({ request }) => {
  const r = await request.get('/api/hr-payroll/benefitses?limit=10');
  expect(r.status()).toBe(200);
  const j = await r.json();
  expect(Array.isArray(j.items)).toBe(true);
  expect(j.total).toBeGreaterThanOrEqual(j.items.length);
});
