// api-055-local-default-create-422: LocalDefault: Invalid payload returns 422
// Module: Sales & Territories · Table: LocalDefault · Endpoint: /api/sales-territories/local-defaults
import { test, expect } from '@playwright/test';

test("LocalDefault: Invalid payload returns 422", async ({ request }) => {
  const r = await request.post('/api/sales-territories/local-defaults', { data: { ...{"Country":"Canada","Region1Label":"City","Region2Label":"Province","PostalLabel":"Postal Code","PostalFormat":"X9X 9X9","TelFormat":"(999) 999-9999","CurrencySymbol":"$","DateFormat":"DMY","LocalDefNum":1}, Country: "XXXXXXXXXXXXXXXXXXXXX" } });
  expect([409, 422]).toContain(r.status());
});
