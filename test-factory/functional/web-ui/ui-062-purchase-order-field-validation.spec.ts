// ui-062-purchase-order-field-validation: PurchaseOrder: Inline field validation
// Module: Purchasing · Table: PurchaseOrder · Legacy: legacy/purchasing/purchase_order_browse.w
import { test, expect } from '@playwright/test';

test.describe('Purchasing / PurchaseOrder', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/purchasing/purchase-orders` : '#/purchasing/purchase-orders');
  });

  test("PurchaseOrder: Inline field validation", async ({ page }) => {
    await page.getByTestId('row').first().dblclick();
    await page.getByTestId('edit').click();
    await page.getByTestId('field-PONum').fill("0");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('error-PONum')).toBeVisible();
  });
});
