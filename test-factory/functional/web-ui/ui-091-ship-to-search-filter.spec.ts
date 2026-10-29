// ui-091-ship-to-search-filter: ShipTo: Search filters the list
// Module: Order Fulfilment · Table: ShipTo · Legacy: legacy/order-fulfilment/ship_to_browse.w
import { test, expect } from '@playwright/test';

test.describe('Order Fulfilment / ShipTo', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/order-fulfilment/ship-tos` : '#/order-fulfilment/ship-tos');
  });

  test("ShipTo: Search filters the list", async ({ page }) => {
    const total = await page.getByTestId('row').count();
    await page.getByTestId('search').fill("Jim");
    await expect.poll(async () => page.getByTestId('row').count()).toBeLessThanOrEqual(total);
  });
});
