// api-038-po-line-get-404: POLine: Unknown key returns 404
// Module: Purchasing · Table: POLine · Endpoint: /api/purchasing/po-lines
import { test, expect } from '@playwright/test';

test("POLine: Unknown key returns 404", async ({ request }) => {
  const r = await request.get('/api/purchasing/po-lines/999999/999999');
  expect(r.status()).toBe(404);
});
