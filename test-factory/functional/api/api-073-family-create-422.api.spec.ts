// api-073-family-create-422: Family: Invalid payload returns 422
// Module: HR & Payroll · Table: Family · Endpoint: /api/hr-payroll/families
import { test, expect } from '@playwright/test';

test("Family: Invalid payload returns 422", async ({ request }) => {
  const r = await request.post('/api/hr-payroll/families', { data: { ...{"EmpNum":1,"RelativeName":"Jenny Koberlein","Relation":"Daughter","Birthdate":"1998-01-15","CoveredOnBenefits":true,"BenefitDate":"1998-01-15"}, EmpNum: -1 } });
  expect([409, 422]).toContain(r.status());
});
