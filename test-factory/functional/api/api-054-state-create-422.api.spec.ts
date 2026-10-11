// api-054-state-create-422: State: Invalid payload returns 422
// Module: Sales & Territories · Table: State · Endpoint: /api/sales-territories/states
import { test, expect } from '@playwright/test';

test("State: Invalid payload returns 422", async ({ request }) => {
  const r = await request.post('/api/sales-territories/states', { data: { ...{"State":"AK","StateName":"Alaska","Region":"West"}, StateName: "XXXXXXXXXXXXXXXXXXXXX" } });
  expect([409, 422]).toContain(r.status());
});
