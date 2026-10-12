// api-072-benefits-create-422: Benefits: Invalid payload returns 422
// Module: HR & Payroll · Table: Benefits · Endpoint: /api/hr-payroll/benefitses
import { test, expect } from '@playwright/test';

test("Benefits: Invalid payload returns 422", async ({ request }) => {
  const r = await request.post('/api/hr-payroll/benefitses', { data: { ...{"EmpNum":2,"HealthCare":"Aetna PP","LifeInsurance":45000,"Pension401K":15,"StockPurchase":10,"MedicalSpending":1000,"DependentCare":1500}, EmpNum: -1 } });
  expect([409, 422]).toContain(r.status());
});
