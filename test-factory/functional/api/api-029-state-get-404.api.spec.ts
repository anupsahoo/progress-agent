// api-029-state-get-404: State: Unknown key returns 404
// Module: Sales & Territories · Table: State · Endpoint: /api/sales-territories/states
import { test, expect } from '@playwright/test';

test("State: Unknown key returns 404", async ({ request }) => {
  const r = await request.get('/api/sales-territories/states/999999');
  expect(r.status()).toBe(404);
});
