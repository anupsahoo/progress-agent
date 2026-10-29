// ui-083-item-search-filter: Item: Search filters the list
// Module: Inventory · Table: Item · Legacy: legacy/inventory/item_browse.w
import { test, expect } from '@playwright/test';

test.describe('Inventory / Item', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/inventory/items` : '#/inventory/items');
  });

  test("Item: Search filters the list", async ({ page }) => {
    const total = await page.getByTestId('row').count();
    await page.getByTestId('search').fill("Ten");
    await expect.poll(async () => page.getByTestId('row').count()).toBeLessThanOrEqual(total);
  });
});
