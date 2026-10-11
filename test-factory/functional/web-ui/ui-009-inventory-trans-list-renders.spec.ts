// ui-009-inventory-trans-list-renders: InventoryTrans: List renders with legacy labels
// Module: Inventory · Table: InventoryTrans · Legacy: legacy/inventory/inventory_trans_browse.w
import { test, expect } from '@playwright/test';

test.describe('Inventory / InventoryTrans', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/inventory/inventory-transes` : '#/inventory/inventory-transes');
  });

  test("InventoryTrans: List renders with legacy labels", async ({ page }) => {
    await expect(page.getByTestId('inventory-trans-list')).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Inventory Trans Num" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Warehouse Num" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Bin Num" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Qty" })).toBeVisible();
    await expect(page.getByTestId('row').first()).toBeVisible();
  });
});
