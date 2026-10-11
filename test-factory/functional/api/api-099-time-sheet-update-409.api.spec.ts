// api-099-time-sheet-update-409: TimeSheet: Stale version returns 409
// Module: HR & Payroll · Table: TimeSheet · Endpoint: /api/hr-payroll/time-sheets
import { test, expect } from '@playwright/test';

test("TimeSheet: Stale version returns 409", async ({ request }) => {
  const cur = await (await request.get('/api/hr-payroll/time-sheets/1/1998-01-05')).json();
  const r = await request.put('/api/hr-payroll/time-sheets/1/1998-01-05', { data: cur, headers: { 'If-Match': String((cur.version ?? 0) + 7) } });
  expect(r.status()).toBe(409);
});
