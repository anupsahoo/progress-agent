// ui-036-bin-create-and-save: Bin: Create and save
// Module: Warehousing · Table: Bin · Legacy: legacy/warehousing/bin_browse.w
import { test, expect } from '@playwright/test';

test.describe('Warehousing / Bin', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/warehousing/bins` : '#/warehousing/bins');
  });

  test("Bin: Create and save", async ({ page }) => {
    await page.getByTestId('new').click();
    await page.getByTestId('field-BinNum').fill("90717");
    await page.getByTestId('field-WarehouseNum').fill("1");
    await page.getByTestId('field-Itemnum').fill("2");
    await page.getByTestId('field-Qty').fill("9273");
    await page.getByTestId('field-BinName').fill("691289-Q");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('banner')).toHaveText('Bin saved.');
  });
});
