// api-097-benefits-update-409: Benefits: Stale version returns 409
// Module: HR & Payroll · Table: Benefits · Endpoint: /api/hr-payroll/benefitses
import { test, expect } from '@playwright/test';

test("Benefits: Stale version returns 409", async ({ request }) => {
  const cur = await (await request.get('/api/hr-payroll/benefitses/2')).json();
  const r = await request.put('/api/hr-payroll/benefitses/2', { data: cur, headers: { 'If-Match': String((cur.version ?? 0) + 7) } });
  expect(r.status()).toBe(409);
});
