// ui-010-warehouse-list-renders: Warehouse: List renders with legacy labels
// Module: Warehousing · Table: Warehouse · Legacy: legacy/warehousing/warehouse_browse.w
import { test, expect } from '@playwright/test';

test.describe('Warehousing / Warehouse', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/warehousing/warehouses` : '#/warehousing/warehouses');
  });

  test("Warehouse: List renders with legacy labels", async ({ page }) => {
    await expect(page.getByTestId('warehouse-list')).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Warehouse Num" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Warehouse Name" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Country" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Address" })).toBeVisible();
    await expect(page.getByTestId('row').first()).toBeVisible();
  });
});
