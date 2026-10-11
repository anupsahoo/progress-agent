// ui-035-warehouse-create-and-save: Warehouse: Create and save
// Module: Warehousing · Table: Warehouse · Legacy: legacy/warehousing/warehouse_browse.w
import { test, expect } from '@playwright/test';

test.describe('Warehousing / Warehouse', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/warehousing/warehouses` : '#/warehousing/warehouses');
  });

  test("Warehouse: Create and save", async ({ page }) => {
    await page.getByTestId('new').click();
    await page.getByTestId('field-WarehouseNum').fill("90002");
    await page.getByTestId('field-WarehouseName').fill("Southeast USA");
    await page.getByTestId('field-Country').fill("USA");
    await page.getByTestId('field-Address').fill("4567 Peach Rd");
    await page.getByTestId('field-Address2').fill("");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('banner')).toHaveText('Warehouse saved.');
  });
});
