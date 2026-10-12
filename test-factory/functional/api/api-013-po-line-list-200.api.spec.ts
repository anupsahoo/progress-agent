// api-013-po-line-list-200: POLine: List returns 200 and a page
// Module: Purchasing · Table: POLine · Endpoint: /api/purchasing/po-lines
import { test, expect } from '@playwright/test';

test("POLine: List returns 200 and a page", async ({ request }) => {
  const r = await request.get('/api/purchasing/po-lines?limit=10');
  expect(r.status()).toBe(200);
  const j = await r.json();
  expect(Array.isArray(j.items)).toBe(true);
  expect(j.total).toBeGreaterThanOrEqual(j.items.length);
});
