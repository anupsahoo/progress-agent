// api-023-family-list-200: Family: List returns 200 and a page
// Module: HR & Payroll · Table: Family · Endpoint: /api/hr-payroll/families
import { test, expect } from '@playwright/test';

test("Family: List returns 200 and a page", async ({ request }) => {
  const r = await request.get('/api/hr-payroll/families?limit=10');
  expect(r.status()).toBe(200);
  const j = await r.json();
  expect(Array.isArray(j.items)).toBe(true);
  expect(j.total).toBeGreaterThanOrEqual(j.items.length);
});
