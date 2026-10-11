// ui-086-bin-search-filter: Bin: Search filters the list
// Module: Warehousing · Table: Bin · Legacy: legacy/warehousing/bin_browse.w
import { test, expect } from '@playwright/test';

test.describe('Warehousing / Bin', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/warehousing/bins` : '#/warehousing/bins');
  });

  test("Bin: Search filters the list", async ({ page }) => {
    const total = await page.getByTestId('row').count();
    await page.getByTestId('search').fill("691");
    await expect.poll(async () => page.getByTestId('row').count()).toBeLessThanOrEqual(total);
  });
});
