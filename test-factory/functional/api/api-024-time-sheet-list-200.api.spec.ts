// api-024-time-sheet-list-200: TimeSheet: List returns 200 and a page
// Module: HR & Payroll · Table: TimeSheet · Endpoint: /api/hr-payroll/time-sheets
import { test, expect } from '@playwright/test';

test("TimeSheet: List returns 200 and a page", async ({ request }) => {
  const r = await request.get('/api/hr-payroll/time-sheets?limit=10');
  expect(r.status()).toBe(200);
  const j = await r.json();
  expect(Array.isArray(j.items)).toBe(true);
  expect(j.total).toBeGreaterThanOrEqual(j.items.length);
});
