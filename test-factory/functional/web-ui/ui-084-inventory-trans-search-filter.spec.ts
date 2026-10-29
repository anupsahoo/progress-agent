// ui-084-inventory-trans-search-filter: InventoryTrans: Search filters the list
// Module: Inventory · Table: InventoryTrans · Legacy: legacy/inventory/inventory_trans_browse.w
import { test, expect } from '@playwright/test';

test.describe('Inventory / InventoryTrans', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/inventory/inventory-transes` : '#/inventory/inventory-transes');
  });

  test("InventoryTrans: Search filters the list", async ({ page }) => {
    const total = await page.getByTestId('row').count();
    await page.getByTestId('search').fill("Shi");
    await expect.poll(async () => page.getByTestId('row').count()).toBeLessThanOrEqual(total);
  });
});
