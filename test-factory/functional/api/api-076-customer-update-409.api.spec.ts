// api-076-customer-update-409: Customer: Stale version returns 409
// Module: Customer Management · Table: Customer · Endpoint: /api/customer-management/customers
import { test, expect } from '@playwright/test';

test("Customer: Stale version returns 409", async ({ request }) => {
  const cur = await (await request.get('/api/customer-management/customers/1')).json();
  const r = await request.put('/api/customer-management/customers/1', { data: cur, headers: { 'If-Match': String((cur.version ?? 0) + 7) } });
  expect(r.status()).toBe(409);
});
