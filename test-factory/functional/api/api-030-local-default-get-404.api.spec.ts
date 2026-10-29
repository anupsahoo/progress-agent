// api-030-local-default-get-404: LocalDefault: Unknown key returns 404
// Module: Sales & Territories · Table: LocalDefault · Endpoint: /api/sales-territories/local-defaults
import { test, expect } from '@playwright/test';

test("LocalDefault: Unknown key returns 404", async ({ request }) => {
  const r = await request.get('/api/sales-territories/local-defaults/999999');
  expect(r.status()).toBe(404);
});
