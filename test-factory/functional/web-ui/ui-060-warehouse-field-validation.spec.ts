// ui-060-warehouse-field-validation: Warehouse: Inline field validation
// Module: Warehousing · Table: Warehouse · Legacy: legacy/warehousing/warehouse_browse.w
import { test, expect } from '@playwright/test';

test.describe('Warehousing / Warehouse', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/warehousing/warehouses` : '#/warehousing/warehouses');
  });

  test("Warehouse: Inline field validation", async ({ page }) => {
    await page.getByTestId('row').first().dblclick();
    await page.getByTestId('edit').click();
    await page.getByTestId('field-WarehouseNum').fill("0");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('error-WarehouseNum')).toBeVisible();
  });
});
