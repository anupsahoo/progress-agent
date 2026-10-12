// api-080-local-default-update-409: LocalDefault: Stale version returns 409
// Module: Sales & Territories · Table: LocalDefault · Endpoint: /api/sales-territories/local-defaults
import { test, expect } from '@playwright/test';

test("LocalDefault: Stale version returns 409", async ({ request }) => {
  const cur = await (await request.get('/api/sales-territories/local-defaults/1')).json();
  const r = await request.put('/api/sales-territories/local-defaults/1', { data: cur, headers: { 'If-Match': String((cur.version ?? 0) + 7) } });
  expect(r.status()).toBe(409);
});
