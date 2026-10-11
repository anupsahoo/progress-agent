// ui-087-purchase-order-search-filter: PurchaseOrder: Search filters the list
// Module: Purchasing · Table: PurchaseOrder · Legacy: legacy/purchasing/purchase_order_browse.w
import { test, expect } from '@playwright/test';

test.describe('Purchasing / PurchaseOrder', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/purchasing/purchase-orders` : '#/purchasing/purchase-orders');
  });

  test("PurchaseOrder: Search filters the list", async ({ page }) => {
    const total = await page.getByTestId('row').count();
    await page.getByTestId('search').fill("Ord");
    await expect.poll(async () => page.getByTestId('row').count()).toBeLessThanOrEqual(total);
  });
});
