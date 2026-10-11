// api-098-family-update-409: Family: Stale version returns 409
// Module: HR & Payroll · Table: Family · Endpoint: /api/hr-payroll/families
import { test, expect } from '@playwright/test';

test("Family: Stale version returns 409", async ({ request }) => {
  const cur = await (await request.get('/api/hr-payroll/families/1/Jenny%20Koberlein')).json();
  const r = await request.put('/api/hr-payroll/families/1/Jenny%20Koberlein', { data: cur, headers: { 'If-Match': String((cur.version ?? 0) + 7) } });
  expect(r.status()).toBe(409);
});
