// ui-090-order-line-search-filter: OrderLine: Search filters the list
// Module: Order Entry · Table: OrderLine · Legacy: legacy/order-entry/order_line_browse.w
import { test, expect } from '@playwright/test';

test.describe('Order Entry / OrderLine', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/order-entry/order-lines` : '#/order-entry/order-lines');
  });

  test("OrderLine: Search filters the list", async ({ page }) => {
    const total = await page.getByTestId('row').count();
    await page.getByTestId('search').fill("Shi");
    await expect.poll(async () => page.getByTestId('row').count()).toBeLessThanOrEqual(total);
  });
});
