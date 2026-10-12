// api-077-feedback-update-409: Feedback: Stale version returns 409
// Module: Customer Management · Table: Feedback · Endpoint: /api/customer-management/feedbacks
import { test, expect } from '@playwright/test';

test("Feedback: Stale version returns 409", async ({ request }) => {
  const cur = await (await request.get('/api/customer-management/feedbacks/')).json();
  const r = await request.put('/api/customer-management/feedbacks/', { data: cur, headers: { 'If-Match': String((cur.version ?? 0) + 7) } });
  expect(r.status()).toBe(409);
});
