// api-002-feedback-list-200: Feedback: List returns 200 and a page
// Module: Customer Management · Table: Feedback · Endpoint: /api/customer-management/feedbacks
import { test, expect } from '@playwright/test';

test("Feedback: List returns 200 and a page", async ({ request }) => {
  const r = await request.get('/api/customer-management/feedbacks?limit=10');
  expect(r.status()).toBe(200);
  const j = await r.json();
  expect(Array.isArray(j.items)).toBe(true);
  expect(j.total).toBeGreaterThanOrEqual(j.items.length);
});
