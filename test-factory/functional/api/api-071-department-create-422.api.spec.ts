// api-071-department-create-422: Department: Invalid payload returns 422
// Module: HR & Payroll · Table: Department · Endpoint: /api/hr-payroll/departments
import { test, expect } from '@playwright/test';

test("Department: Invalid payload returns 422", async ({ request }) => {
  const r = await request.post('/api/hr-payroll/departments', { data: { ...{"DeptCode":"100","DeptName":"Consulting"}, DeptName: "XXXXXXXXXXXXXXXX" } });
  expect([409, 422]).toContain(r.status());
});
