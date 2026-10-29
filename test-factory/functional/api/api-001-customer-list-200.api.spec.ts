// api-001-customer-list-200: Customer: List returns 200 and a page
// Module: Customer Management · Table: Customer · Endpoint: /api/customer-management/customers
import { test, expect } from '@playwright/test';

test("Customer: List returns 200 and a page", async ({ request }) => {
  const r = await request.get('/api/customer-management/customers?limit=10');
  expect(r.status()).toBe(200);
  const j = await r.json();
  expect(Array.isArray(j.items)).toBe(true);
  expect(j.total).toBeGreaterThanOrEqual(j.items.length);
});
