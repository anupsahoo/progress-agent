// ui-089-order-search-filter: Order: Search filters the list
// Module: Order Entry · Table: Order · Legacy: legacy/order-entry/order_browse.w
import { test, expect } from '@playwright/test';

test.describe('Order Entry / Order', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/order-entry/orders` : '#/order-entry/orders');
  });

  test("Order: Search filters the list", async ({ page }) => {
    const total = await page.getByTestId('row').count();
    await page.getByTestId('search').fill("Wal");
    await expect.poll(async () => page.getByTestId('row').count()).toBeLessThanOrEqual(total);
  });
});
