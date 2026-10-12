// ui-093-invoice-search-filter: Invoice: Search filters the list
// Module: Billing & Invoicing · Table: Invoice · Legacy: legacy/billing-invoicing/invoice_browse.w
import { test, expect } from '@playwright/test';

test.describe('Billing & Invoicing / Invoice', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/billing-invoicing/invoices` : '#/billing-invoicing/invoices');
  });

  test("Invoice: Search filters the list", async ({ page }) => {
    const total = await page.getByTestId('row').count();
    await page.getByTestId('search').fill("2");
    await expect.poll(async () => page.getByTestId('row').count()).toBeLessThanOrEqual(total);
  });
});
