// api-026-customer-get-404: Customer: Unknown key returns 404
// Module: Customer Management · Table: Customer · Endpoint: /api/customer-management/customers
import { test, expect } from '@playwright/test';

test("Customer: Unknown key returns 404", async ({ request }) => {
  const r = await request.get('/api/customer-management/customers/999999');
  expect(r.status()).toBe(404);
});
