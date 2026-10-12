// api-017-ref-call-list-200: RefCall: List returns 200 and a page
// Module: Credit Management · Table: RefCall · Endpoint: /api/credit-management/ref-calls
import { test, expect } from '@playwright/test';

test("RefCall: List returns 200 and a page", async ({ request }) => {
  const r = await request.get('/api/credit-management/ref-calls?limit=10');
  expect(r.status()).toBe(200);
  const j = await r.json();
  expect(Array.isArray(j.items)).toBe(true);
  expect(j.total).toBeGreaterThanOrEqual(j.items.length);
});
