// api-036-bin-get-404: Bin: Unknown key returns 404
// Module: Warehousing · Table: Bin · Endpoint: /api/warehousing/bins
import { test, expect } from '@playwright/test';

test("Bin: Unknown key returns 404", async ({ request }) => {
  const r = await request.get('/api/warehousing/bins/999999');
  expect(r.status()).toBe(404);
});
