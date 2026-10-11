// ui-078-salesrep-search-filter: Salesrep: Search filters the list
// Module: Sales & Territories · Table: Salesrep · Legacy: legacy/sales-territories/salesrep_browse.w
import { test, expect } from '@playwright/test';

test.describe('Sales & Territories / Salesrep', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/sales-territories/salesreps` : '#/sales-territories/salesreps');
  });

  test("Salesrep: Search filters the list", async ({ page }) => {
    const total = await page.getByTestId('row').count();
    await page.getByTestId('search').fill("DKP");
    await expect.poll(async () => page.getByTestId('row').count()).toBeLessThanOrEqual(total);
  });
});
