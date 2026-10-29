// ui-014-order-list-renders: Order: List renders with legacy labels
// Module: Order Entry · Table: Order · Legacy: legacy/order-entry/order_browse.w
import { test, expect } from '@playwright/test';

test.describe('Order Entry / Order', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/order-entry/orders` : '#/order-entry/orders');
  });

  test("Order: List renders with legacy labels", async ({ page }) => {
    await expect(page.getByTestId('order-list')).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Order Num" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Cust Num" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Ordered" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Shipped" })).toBeVisible();
    await expect(page.getByTestId('row').first()).toBeVisible();
  });
});
