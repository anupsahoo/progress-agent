// ui-039-order-create-and-save: Order: Create and save
// Module: Order Entry · Table: Order · Legacy: legacy/order-entry/order_browse.w
import { test, expect } from '@playwright/test';

test.describe('Order Entry / Order', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/order-entry/orders` : '#/order-entry/orders');
  });

  test("Order: Create and save", async ({ page }) => {
    await page.getByTestId('new').click();
    await page.getByTestId('field-Ordernum').fill("90002");
    await page.getByTestId('field-CustNum').fill("81");
    await page.getByTestId('field-OrderDate').fill("1997-10-05");
    await page.getByTestId('field-ShipDate').fill("1997-10-10");
    await page.getByTestId('field-PromiseDate').fill("1997-10-10");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('banner')).toHaveText('Order saved.');
  });
});
