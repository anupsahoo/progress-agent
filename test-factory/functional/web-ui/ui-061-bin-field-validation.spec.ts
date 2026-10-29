// ui-061-bin-field-validation: Bin: Inline field validation
// Module: Warehousing · Table: Bin · Legacy: legacy/warehousing/bin_browse.w
import { test, expect } from '@playwright/test';

test.describe('Warehousing / Bin', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/warehousing/bins` : '#/warehousing/bins');
  });

  test("Bin: Inline field validation", async ({ page }) => {
    await page.getByTestId('row').first().dblclick();
    await page.getByTestId('edit').click();
    await page.getByTestId('field-WarehouseNum').fill("-1");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('error-WarehouseNum')).toBeVisible();
  });
});
