// api-079-state-update-409: State: Stale version returns 409
// Module: Sales & Territories · Table: State · Endpoint: /api/sales-territories/states
import { test, expect } from '@playwright/test';

test("State: Stale version returns 409", async ({ request }) => {
  const cur = await (await request.get('/api/sales-territories/states/AK')).json();
  const r = await request.put('/api/sales-territories/states/AK', { data: cur, headers: { 'If-Match': String((cur.version ?? 0) + 7) } });
  expect(r.status()).toBe(409);
});
