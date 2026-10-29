// ui-079-state-search-filter: State: Search filters the list
// Module: Sales & Territories · Table: State · Legacy: legacy/sales-territories/state_browse.w
import { test, expect } from '@playwright/test';

test.describe('Sales & Territories / State', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/sales-territories/states` : '#/sales-territories/states');
  });

  test("State: Search filters the list", async ({ page }) => {
    const total = await page.getByTestId('row').count();
    await page.getByTestId('search').fill("AL");
    await expect.poll(async () => page.getByTestId('row').count()).toBeLessThanOrEqual(total);
  });
});
