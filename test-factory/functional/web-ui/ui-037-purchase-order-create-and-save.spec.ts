// ui-037-purchase-order-create-and-save: PurchaseOrder: Create and save
// Module: Purchasing · Table: PurchaseOrder · Legacy: legacy/purchasing/purchase_order_browse.w
import { test, expect } from '@playwright/test';

test.describe('Purchasing / PurchaseOrder', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/purchasing/purchase-orders` : '#/purchasing/purchase-orders');
  });

  test("PurchaseOrder: Create and save", async ({ page }) => {
    await page.getByTestId('new').click();
    await page.getByTestId('field-PONum').fill("98002");
    await page.getByTestId('field-DateEntered').fill("1998-05-01");
    await page.getByTestId('field-SupplierIDNum').fill("2");
    await page.getByTestId('field-ReceiveDate').fill("2024-01-15");
    await page.getByTestId('field-POStatus').fill("Ordered");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('banner')).toHaveText('PurchaseOrder saved.');
  });
});
