// ui-032-supplier-item-xref-create-and-save: SupplierItemXref: Create and save
// Module: Supplier Management · Table: SupplierItemXref · Legacy: legacy/supplier-management/supplier_item_xref_browse.w
import { test, expect } from '@playwright/test';

test.describe('Supplier Management / SupplierItemXref', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/supplier-management/supplier-item-xrefs` : '#/supplier-management/supplier-item-xrefs');
  });

  test("SupplierItemXref: Create and save", async ({ page }) => {
    await page.getByTestId('new').click();
    await page.getByTestId('field-SupplierIDNum').fill("90001");
    await page.getByTestId('field-Itemnum').fill("90003");
  
    await page.getByTestId('save').click();
    await expect(page.getByTestId('banner')).toHaveText('SupplierItemXref saved.');
  });
});
