// ui-033-item-create-and-save: Item: Create and save
// Module: Inventory · Table: Item · Legacy: legacy/inventory/item_browse.w
import { test, expect } from '@playwright/test';

test.describe('Inventory / Item', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/inventory/items` : '#/inventory/items');
  });

  test("Item: Create and save", async ({ page }) => {
    await page.getByTestId('new').click();
    await page.getByTestId('field-Itemnum').fill("90002");
    await page.getByTestId('field-ItemName').fill("Tennis Racquet");
    await page.getByTestId('field-Price').fill("119.5");
    await page.getByTestId('field-Onhand').fill("12987");
    await page.getByTestId('field-Allocated').fill("9038");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('banner')).toHaveText('Item saved.');
  });
});
