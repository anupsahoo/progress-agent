// api-078-salesrep-update-409: Salesrep: Stale version returns 409
// Module: Sales & Territories · Table: Salesrep · Endpoint: /api/sales-territories/salesreps
import { test, expect } from '@playwright/test';

test("Salesrep: Stale version returns 409", async ({ request }) => {
  const cur = await (await request.get('/api/sales-territories/salesreps/BBB')).json();
  const r = await request.put('/api/sales-territories/salesreps/BBB', { data: cur, headers: { 'If-Match': String((cur.version ?? 0) + 7) } });
  expect(r.status()).toBe(409);
});
