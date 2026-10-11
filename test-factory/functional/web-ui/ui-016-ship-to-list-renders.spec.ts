// ui-016-ship-to-list-renders: ShipTo: List renders with legacy labels
// Module: Order Fulfilment · Table: ShipTo · Legacy: legacy/order-fulfilment/ship_to_browse.w
import { test, expect } from '@playwright/test';

test.describe('Order Fulfilment / ShipTo', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/order-fulfilment/ship-tos` : '#/order-fulfilment/ship-tos');
  });

  test("ShipTo: List renders with legacy labels", async ({ page }) => {
    await expect(page.getByTestId('ship-to-list')).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Cust Num" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Ship To ID" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Contact" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Address" })).toBeVisible();
    await expect(page.getByTestId('row').first()).toBeVisible();
  });
});
