// ui-059-inventory-trans-field-validation: InventoryTrans: Inline field validation
// Module: Inventory · Table: InventoryTrans · Legacy: legacy/inventory/inventory_trans_browse.w
import { test, expect } from '@playwright/test';

test.describe('Inventory / InventoryTrans', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/inventory/inventory-transes` : '#/inventory/inventory-transes');
  });

  test("InventoryTrans: Inline field validation", async ({ page }) => {
    await page.getByTestId('row').first().dblclick();
    await page.getByTestId('edit').click();
    await page.getByTestId('field-Itemnum').fill("-1");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('error-Itemnum')).toBeVisible();
  });
});
