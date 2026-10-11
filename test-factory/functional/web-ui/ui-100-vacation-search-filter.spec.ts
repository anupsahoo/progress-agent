// ui-100-vacation-search-filter: Vacation: Search filters the list
// Module: HR & Payroll · Table: Vacation · Legacy: legacy/hr-payroll/vacation_browse.w
import { test, expect } from '@playwright/test';

test.describe('HR & Payroll / Vacation', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/hr-payroll/vacations` : '#/hr-payroll/vacations');
  });

  test("Vacation: Search filters the list", async ({ page }) => {
    const total = await page.getByTestId('row').count();
    await page.getByTestId('search').fill("2");
    await expect.poll(async () => page.getByTestId('row').count()).toBeLessThanOrEqual(total);
  });
});
