// ui-034-inventory-trans-create-and-save: InventoryTrans: Create and save
// Module: Inventory · Table: InventoryTrans · Legacy: legacy/inventory/inventory_trans_browse.w
import { test, expect } from '@playwright/test';

test.describe('Inventory / InventoryTrans', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/inventory/inventory-transes` : '#/inventory/inventory-transes');
  });

  test("InventoryTrans: Create and save", async ({ page }) => {
    await page.getByTestId('new').click();
    await page.getByTestId('field-InvTransNum').fill("90069");
    await page.getByTestId('field-WarehouseNum').fill("0");
    await page.getByTestId('field-BinNum').fill("0");
    await page.getByTestId('field-Qty').fill("2");
    await page.getByTestId('field-Itemnum').fill("45");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('banner')).toHaveText('InventoryTrans saved.');
  });
});
