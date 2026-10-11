// ui-041-ship-to-create-and-save: ShipTo: Create and save
// Module: Order Fulfilment · Table: ShipTo · Legacy: legacy/order-fulfilment/ship_to_browse.w
import { test, expect } from '@playwright/test';

test.describe('Order Fulfilment / ShipTo', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/order-fulfilment/ship-tos` : '#/order-fulfilment/ship-tos');
  });

  test("ShipTo: Create and save", async ({ page }) => {
    await page.getByTestId('new').click();
    await page.getByTestId('field-CustNum').fill("90005");
    await page.getByTestId('field-ShipToID').fill("90002");
    await page.getByTestId('field-Contact').fill("Jimmy James");
    await page.getByTestId('field-Address').fill("456 5th St.");
    await page.getByTestId('field-Address2').fill("");
    await page.getByTestId('field-City').fill("Duluth");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('banner')).toHaveText('ShipTo saved.');
  });
});
