// api-086-bin-update-409: Bin: Stale version returns 409
// Module: Warehousing · Table: Bin · Endpoint: /api/warehousing/bins
import { test, expect } from '@playwright/test';

test("Bin: Stale version returns 409", async ({ request }) => {
  const cur = await (await request.get('/api/warehousing/bins/716')).json();
  const r = await request.put('/api/warehousing/bins/716', { data: cur, headers: { 'If-Match': String((cur.version ?? 0) + 7) } });
  expect(r.status()).toBe(409);
});
