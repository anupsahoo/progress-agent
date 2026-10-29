// api-100-vacation-update-409: Vacation: Stale version returns 409
// Module: HR & Payroll · Table: Vacation · Endpoint: /api/hr-payroll/vacations
import { test, expect } from '@playwright/test';

test("Vacation: Stale version returns 409", async ({ request }) => {
  const cur = await (await request.get('/api/hr-payroll/vacations/1/1998-01-02')).json();
  const r = await request.put('/api/hr-payroll/vacations/1/1998-01-02', { data: cur, headers: { 'If-Match': String((cur.version ?? 0) + 7) } });
  expect(r.status()).toBe(409);
});
