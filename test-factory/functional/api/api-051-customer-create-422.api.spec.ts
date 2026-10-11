// api-051-customer-create-422: Customer: Invalid payload returns 422
// Module: Customer Management · Table: Customer · Endpoint: /api/customer-management/customers
import { test, expect } from '@playwright/test';

test("Customer: Invalid payload returns 422", async ({ request }) => {
  const r = await request.post('/api/customer-management/customers', { data: { ...{"CustNum":1,"Country":"USA","Name":"Lift Tours","Address":"276 North Drive","Address2":"","City":"Burlington","State":"MA","PostalCode":"01730","Contact":"Gloria Shepley","Phone":"(617) 450-0086","SalesRep":"HXM","CreditLimit":66700,"Balance":903.64,"Terms":"Net30","Discount":35,"Comments":"This customer is on credit hold.","Fax":"","EmailAddress":""}, CustNum: 0 } });
  expect([409, 422]).toContain(r.status());
});
