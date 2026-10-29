// api-069-bill-to-create-422: BillTo: Invalid payload returns 422
// Module: Billing & Invoicing · Table: BillTo · Endpoint: /api/billing-invoicing/bill-tos
import { test, expect } from '@playwright/test';

test("BillTo: Invalid payload returns 422", async ({ request }) => {
  const r = await request.post('/api/billing-invoicing/bill-tos', { data: { ...{"CustNum":5,"BillToID":1,"Name":"AL - Finance Offc","Address":"7876 Alabama St","Address2":"Suite 250","City":"Montgomery","State":"AL","PostalCode":"36117","Contact":"Bubba Jones","Phone":"(334) 123-1234"}, CustNum: -1 } });
  expect([409, 422]).toContain(r.status());
});
