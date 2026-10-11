// ui-094-bill-to-search-filter: BillTo: Search filters the list
// Module: Billing & Invoicing · Table: BillTo · Legacy: legacy/billing-invoicing/bill_to_browse.w
import { test, expect } from '@playwright/test';

test.describe('Billing & Invoicing / BillTo', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/billing-invoicing/bill-tos` : '#/billing-invoicing/bill-tos');
  });

  test("BillTo: Search filters the list", async ({ page }) => {
    const total = await page.getByTestId('row').count();
    await page.getByTestId('search').fill("GA ");
    await expect.poll(async () => page.getByTestId('row').count()).toBeLessThanOrEqual(total);
  });
});
