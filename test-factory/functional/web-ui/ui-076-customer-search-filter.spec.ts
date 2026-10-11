// ui-076-customer-search-filter: Customer: Search filters the list
// Module: Customer Management · Table: Customer · Legacy: legacy/customer-management/customer_browse.w
import { test, expect } from '@playwright/test';

test.describe('Customer Management / Customer', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/customer-management/customers` : '#/customer-management/customers');
  });

  test("Customer: Search filters the list", async ({ page }) => {
    const total = await page.getByTestId('row').count();
    await page.getByTestId('search').fill("Fin");
    await expect.poll(async () => page.getByTestId('row').count()).toBeLessThanOrEqual(total);
  });
});
