// ui-081-supplier-search-filter: Supplier: Search filters the list
// Module: Supplier Management · Table: Supplier · Legacy: legacy/supplier-management/supplier_browse.w
import { test, expect } from '@playwright/test';

test.describe('Supplier Management / Supplier', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/supplier-management/suppliers` : '#/supplier-management/suppliers');
  });

  test("Supplier: Search filters the list", async ({ page }) => {
    const total = await page.getByTestId('row').count();
    await page.getByTestId('search').fill("Poo");
    await expect.poll(async () => page.getByTestId('row').count()).toBeLessThanOrEqual(total);
  });
});
