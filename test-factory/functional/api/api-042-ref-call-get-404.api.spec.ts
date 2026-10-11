// api-042-ref-call-get-404: RefCall: Unknown key returns 404
// Module: Credit Management · Table: RefCall · Endpoint: /api/credit-management/ref-calls
import { test, expect } from '@playwright/test';

test("RefCall: Unknown key returns 404", async ({ request }) => {
  const r = await request.get('/api/credit-management/ref-calls/999999');
  expect(r.status()).toBe(404);
});
