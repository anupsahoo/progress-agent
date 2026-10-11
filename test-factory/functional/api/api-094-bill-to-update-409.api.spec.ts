// api-094-bill-to-update-409: BillTo: Stale version returns 409
// Module: Billing & Invoicing · Table: BillTo · Endpoint: /api/billing-invoicing/bill-tos
import { test, expect } from '@playwright/test';

test("BillTo: Stale version returns 409", async ({ request }) => {
  const cur = await (await request.get('/api/billing-invoicing/bill-tos/5/1')).json();
  const r = await request.put('/api/billing-invoicing/bill-tos/5/1', { data: cur, headers: { 'If-Match': String((cur.version ?? 0) + 7) } });
  expect(r.status()).toBe(409);
});
