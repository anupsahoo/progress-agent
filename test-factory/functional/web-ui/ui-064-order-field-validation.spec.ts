// ui-064-order-field-validation: Order: Inline field validation
// Module: Order Entry · Table: Order · Legacy: legacy/order-entry/order_browse.w
import { test, expect } from '@playwright/test';

test.describe('Order Entry / Order', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/order-entry/orders` : '#/order-entry/orders');
  });

  test("Order: Inline field validation", async ({ page }) => {
    await page.getByTestId('row').first().dblclick();
    await page.getByTestId('edit').click();
    await page.getByTestId('field-Ordernum').fill("0");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('error-Ordernum')).toBeVisible();
  });
});
