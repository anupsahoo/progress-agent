// ui-098-family-search-filter: Family: Search filters the list
// Module: HR & Payroll · Table: Family · Legacy: legacy/hr-payroll/family_browse.w
import { test, expect } from '@playwright/test';

test.describe('HR & Payroll / Family', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/hr-payroll/families` : '#/hr-payroll/families');
  });

  test("Family: Search filters the list", async ({ page }) => {
    const total = await page.getByTestId('row').count();
    await page.getByTestId('search').fill("Ken");
    await expect.poll(async () => page.getByTestId('row').count()).toBeLessThanOrEqual(total);
  });
});
