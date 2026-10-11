// ui-011-bin-list-renders: Bin: List renders with legacy labels
// Module: Warehousing · Table: Bin · Legacy: legacy/warehousing/bin_browse.w
import { test, expect } from '@playwright/test';

test.describe('Warehousing / Bin', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/warehousing/bins` : '#/warehousing/bins');
  });

  test("Bin: List renders with legacy labels", async ({ page }) => {
    await expect(page.getByTestId('bin-list')).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Warehouse Num" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Item Num" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Qty" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Bin Num" })).toBeVisible();
    await expect(page.getByTestId('row').first()).toBeVisible();
  });
});
