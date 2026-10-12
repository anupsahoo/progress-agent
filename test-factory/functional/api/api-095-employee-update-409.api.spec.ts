// api-095-employee-update-409: Employee: Stale version returns 409
// Module: HR & Payroll · Table: Employee · Endpoint: /api/hr-payroll/employees
import { test, expect } from '@playwright/test';

test("Employee: Stale version returns 409", async ({ request }) => {
  const cur = await (await request.get('/api/hr-payroll/employees/1')).json();
  const r = await request.put('/api/hr-payroll/employees/1', { data: cur, headers: { 'If-Match': String((cur.version ?? 0) + 7) } });
  expect(r.status()).toBe(409);
});
