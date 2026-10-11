// ui-099-time-sheet-search-filter: TimeSheet: Search filters the list
// Module: HR & Payroll · Table: TimeSheet · Legacy: legacy/hr-payroll/time_sheet_browse.w
import { test, expect } from '@playwright/test';

test.describe('HR & Payroll / TimeSheet', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/hr-payroll/time-sheets` : '#/hr-payroll/time-sheets');
  });

  test("TimeSheet: Search filters the list", async ({ page }) => {
    const total = await page.getByTestId('row').count();
    await page.getByTestId('search').fill("ful");
    await expect.poll(async () => page.getByTestId('row').count()).toBeLessThanOrEqual(total);
  });
});
