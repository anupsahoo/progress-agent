// api-049-time-sheet-get-404: TimeSheet: Unknown key returns 404
// Module: HR & Payroll · Table: TimeSheet · Endpoint: /api/hr-payroll/time-sheets
import { test, expect } from '@playwright/test';

test("TimeSheet: Unknown key returns 404", async ({ request }) => {
  const r = await request.get('/api/hr-payroll/time-sheets/999999/999999');
  expect(r.status()).toBe(404);
});
