// ui-015-order-line-list-renders: OrderLine: List renders with legacy labels
// Module: Order Entry · Table: OrderLine · Legacy: legacy/order-entry/order_line_browse.w
import { test, expect } from '@playwright/test';

test.describe('Order Entry / OrderLine', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/order-entry/order-lines` : '#/order-entry/order-lines');
  });

  test("OrderLine: List renders with legacy labels", async ({ page }) => {
    await expect(page.getByTestId('order-line-list')).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Order Num" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Line Num" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Item Num" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Price" })).toBeVisible();
    await expect(page.getByTestId('row').first()).toBeVisible();
  });
});
