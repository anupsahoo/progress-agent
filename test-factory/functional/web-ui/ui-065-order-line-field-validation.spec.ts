// ui-065-order-line-field-validation: OrderLine: Inline field validation
// Module: Order Entry · Table: OrderLine · Legacy: legacy/order-entry/order_line_browse.w
import { test, expect } from '@playwright/test';

test.describe('Order Entry / OrderLine', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/order-entry/order-lines` : '#/order-entry/order-lines');
  });

  test("OrderLine: Inline field validation", async ({ page }) => {
    await page.getByTestId('row').first().dblclick();
    await page.getByTestId('edit').click();
    await page.getByTestId('field-Ordernum').fill("-1");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('error-Ordernum')).toBeVisible();
  });
});
