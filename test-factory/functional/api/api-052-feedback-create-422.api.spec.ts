// api-052-feedback-create-422: Feedback: Invalid payload returns 422
// Module: Customer Management · Table: Feedback · Endpoint: /api/customer-management/feedbacks
import { test, expect } from '@playwright/test';

test("Feedback: Invalid payload returns 422", async ({ request }) => {
  const r = await request.post('/api/customer-management/feedbacks', { data: { ...{"Contact":"Antti Oyrinmetsa","Company":"Antin Metsastysase","EmailAddress":"aoyrinmetsa@sysma.am.com","Phone":"","Fax":"","Comments":"I enjoy having the selection of products I see here","Department":"","Rating":5}, Contact: "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" } });
  expect([409, 422]).toContain(r.status());
});
