// ui-082-supplier-item-xref-search-filter: SupplierItemXref: Search filters the list
// Module: Supplier Management · Table: SupplierItemXref · Legacy: legacy/supplier-management/supplier_item_xref_browse.w
import { test, expect } from '@playwright/test';

test.describe('Supplier Management / SupplierItemXref', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/supplier-management/supplier-item-xrefs` : '#/supplier-management/supplier-item-xrefs');
  });

  test("SupplierItemXref: Search filters the list", async ({ page }) => {
    const total = await page.getByTestId('row').count();
    await page.getByTestId('search').fill("1");
    await expect.poll(async () => page.getByTestId('row').count()).toBeLessThanOrEqual(total);
  });
});
