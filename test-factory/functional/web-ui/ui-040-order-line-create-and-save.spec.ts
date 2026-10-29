// ui-040-order-line-create-and-save: OrderLine: Create and save
// Module: Order Entry · Table: OrderLine · Legacy: legacy/order-entry/order_line_browse.w
import { test, expect } from '@playwright/test';

test.describe('Order Entry / OrderLine', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/order-entry/order-lines` : '#/order-entry/order-lines');
  });

  test("OrderLine: Create and save", async ({ page }) => {
    await page.getByTestId('new').click();
    await page.getByTestId('field-Ordernum').fill("90001");
    await page.getByTestId('field-Linenum').fill("90002");
    await page.getByTestId('field-Itemnum').fill("55");
    await page.getByTestId('field-Price').fill("23.85");
    await page.getByTestId('field-Qty').fill("21");
    await page.getByTestId('field-Discount').fill("10");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('banner')).toHaveText('OrderLine saved.');
  });
});
