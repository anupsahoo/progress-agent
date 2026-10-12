// api-088-po-line-update-409: POLine: Stale version returns 409
// Module: Purchasing · Table: POLine · Endpoint: /api/purchasing/po-lines
import { test, expect } from '@playwright/test';

test("POLine: Stale version returns 409", async ({ request }) => {
  const cur = await (await request.get('/api/purchasing/po-lines/8001/1')).json();
  const r = await request.put('/api/purchasing/po-lines/8001/1', { data: cur, headers: { 'If-Match': String((cur.version ?? 0) + 7) } });
  expect(r.status()).toBe(409);
});
