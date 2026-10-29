// ui-066-ship-to-field-validation: ShipTo: Inline field validation
// Module: Order Fulfilment · Table: ShipTo · Legacy: legacy/order-fulfilment/ship_to_browse.w
import { test, expect } from '@playwright/test';

test.describe('Order Fulfilment / ShipTo', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/order-fulfilment/ship-tos` : '#/order-fulfilment/ship-tos');
  });

  test("ShipTo: Inline field validation", async ({ page }) => {
    await page.getByTestId('row').first().dblclick();
    await page.getByTestId('edit').click();
    await page.getByTestId('field-CustNum').fill("-1");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('error-CustNum')).toBeVisible();
  });
});
