// api-092-ref-call-update-409: RefCall: Stale version returns 409
// Module: Credit Management · Table: RefCall · Endpoint: /api/credit-management/ref-calls
import { test, expect } from '@playwright/test';

test("RefCall: Stale version returns 409", async ({ request }) => {
  const cur = await (await request.get('/api/credit-management/ref-calls/000001')).json();
  const r = await request.put('/api/credit-management/ref-calls/000001', { data: cur, headers: { 'If-Match': String((cur.version ?? 0) + 7) } });
  expect(r.status()).toBe(409);
});
