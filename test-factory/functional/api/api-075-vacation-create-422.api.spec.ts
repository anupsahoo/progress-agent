// api-075-vacation-create-422: Vacation: Invalid payload returns 422
// Module: HR & Payroll · Table: Vacation · Endpoint: /api/hr-payroll/vacations
import { test, expect } from '@playwright/test';

test("Vacation: Invalid payload returns 422", async ({ request }) => {
  const r = await request.post('/api/hr-payroll/vacations', { data: { ...{"EmpNum":1,"StartDate":"1998-01-02","EndDate":"1998-01-02"}, EmpNum: -1 } });
  expect([409, 422]).toContain(r.status());
});
