// api-074-time-sheet-create-422: TimeSheet: Invalid payload returns 422
// Module: HR & Payroll · Table: TimeSheet · Endpoint: /api/hr-payroll/time-sheets
import { test, expect } from '@playwright/test';

test("TimeSheet: Invalid payload returns 422", async ({ request }) => {
  const r = await request.post('/api/hr-payroll/time-sheets', { data: { ...{"EmpNum":1,"DayRecorded":"1998-01-05","TypeRecorded":"part","AMTimeIn":"855","AMTimeOut":"","PMTimeIn":"","PMTimeOut":"115","RegularHours":4,"OvertimeHours":0.25}, EmpNum: -1 } });
  expect([409, 422]).toContain(r.status());
});
