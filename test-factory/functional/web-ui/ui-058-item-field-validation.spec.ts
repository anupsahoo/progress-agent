// ui-058-item-field-validation: Item: Inline field validation
// Module: Inventory · Table: Item · Legacy: legacy/inventory/item_browse.w
import { test, expect } from '@playwright/test';

test.describe('Inventory / Item', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/inventory/items` : '#/inventory/items');
  });

  test("Item: Inline field validation", async ({ page }) => {
    await page.getByTestId('row').first().dblclick();
    await page.getByTestId('edit').click();
    await page.getByTestId('field-Itemnum').fill("-1");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('error-Itemnum')).toBeVisible();
  });
});
