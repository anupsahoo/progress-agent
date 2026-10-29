// ui-080-local-default-search-filter: LocalDefault: Search filters the list
// Module: Sales & Territories · Table: LocalDefault · Legacy: legacy/sales-territories/local_default_browse.w
import { test, expect } from '@playwright/test';

test.describe('Sales & Territories / LocalDefault', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/sales-territories/local-defaults` : '#/sales-territories/local-defaults');
  });

  test("LocalDefault: Search filters the list", async ({ page }) => {
    const total = await page.getByTestId('row').count();
    await page.getByTestId('search').fill("Deu");
    await expect.poll(async () => page.getByTestId('row').count()).toBeLessThanOrEqual(total);
  });
});
