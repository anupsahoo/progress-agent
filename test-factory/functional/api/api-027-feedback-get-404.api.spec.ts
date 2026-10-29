// api-027-feedback-get-404: Feedback: Unknown key returns 404
// Module: Customer Management · Table: Feedback · Endpoint: /api/customer-management/feedbacks
import { test, expect } from '@playwright/test';

test("Feedback: Unknown key returns 404", async ({ request }) => {
  const r = await request.get('/api/customer-management/feedbacks/999999');
  expect(r.status()).toBe(404);
});
