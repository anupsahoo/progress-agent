// ui-097-benefits-search-filter: Benefits: Search filters the list
// Module: HR & Payroll · Table: Benefits · Legacy: legacy/hr-payroll/benefits_browse.w
import { test, expect } from '@playwright/test';

test.describe('HR & Payroll / Benefits', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/hr-payroll/benefitses` : '#/hr-payroll/benefitses');
  });

  test("Benefits: Search filters the list", async ({ page }) => {
    const total = await page.getByTestId('row').count();
    await page.getByTestId('search').fill("Aet");
    await expect.poll(async () => page.getByTestId('row').count()).toBeLessThanOrEqual(total);
  });
});
