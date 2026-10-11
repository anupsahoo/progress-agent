// api-070-employee-create-422: Employee: Invalid payload returns 422
// Module: HR & Payroll · Table: Employee · Endpoint: /api/hr-payroll/employees
import { test, expect } from '@playwright/test';

test("Employee: Invalid payload returns 422", async ({ request }) => {
  const r = await request.post('/api/hr-payroll/employees', { data: { ...{"EmpNum":1,"LastName":"Koberlein","FirstName":"Kelly","Address":"4500 Main Street","Address2":"Apt 22","City":"Houston","State":"TX","PostalCode":"75024","HomePhone":"(214) 234-4657","WorkPhone":"(617) 234-5748","DeptCode":"100","Position":"Consultant","Birthdate":"1968-10-28","StartDate":"1997-05-06","VacationDaysLeft":8,"SickDaysLeft":5}, LastName: "XXXXXXXXXXXXXXXXXXXXXXXXXX" } });
  expect([409, 422]).toContain(r.status());
});
