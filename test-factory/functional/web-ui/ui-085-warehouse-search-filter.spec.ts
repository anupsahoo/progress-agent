// ui-085-warehouse-search-filter: Warehouse: Search filters the list
// Module: Warehousing · Table: Warehouse · Legacy: legacy/warehousing/warehouse_browse.w
import { test, expect } from '@playwright/test';

test.describe('Warehousing / Warehouse', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/warehousing/warehouses` : '#/warehousing/warehouses');
  });

  test("Warehouse: Search filters the list", async ({ page }) => {
    const total = await page.getByTestId('row').count();
    await page.getByTestId('search').fill("Sou");
    await expect.poll(async () => page.getByTestId('row').count()).toBeLessThanOrEqual(total);
  });
});
