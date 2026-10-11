// ui-008-item-list-renders: Item: List renders with legacy labels
// Module: Inventory · Table: Item · Legacy: legacy/inventory/item_browse.w
import { test, expect } from '@playwright/test';

test.describe('Inventory / Item', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/inventory/items` : '#/inventory/items');
  });

  test("Item: List renders with legacy labels", async ({ page }) => {
    await expect(page.getByTestId('item-list')).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Item Num" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Item Name" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Price" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "On Hand" })).toBeVisible();
    await expect(page.getByTestId('row').first()).toBeVisible();
  });
});
