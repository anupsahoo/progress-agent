// api-096-department-update-409: Department: Stale version returns 409
// Module: HR & Payroll · Table: Department · Endpoint: /api/hr-payroll/departments
import { test, expect } from '@playwright/test';

test("Department: Stale version returns 409", async ({ request }) => {
  const cur = await (await request.get('/api/hr-payroll/departments/100')).json();
  const r = await request.put('/api/hr-payroll/departments/100', { data: cur, headers: { 'If-Match': String((cur.version ?? 0) + 7) } });
  expect(r.status()).toBe(409);
});
