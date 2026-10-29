// ui-012-purchase-order-list-renders: PurchaseOrder: List renders with legacy labels
// Module: Purchasing · Table: PurchaseOrder · Legacy: legacy/purchasing/purchase_order_browse.w
import { test, expect } from '@playwright/test';

test.describe('Purchasing / PurchaseOrder', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/purchasing/purchase-orders` : '#/purchasing/purchase-orders');
  });

  test("PurchaseOrder: List renders with legacy labels", async ({ page }) => {
    await expect(page.getByTestId('purchase-order-list')).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "PO Num" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Date Entered" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Supplier ID" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Date Received" })).toBeVisible();
    await expect(page.getByTestId('row').first()).toBeVisible();
  });
});
