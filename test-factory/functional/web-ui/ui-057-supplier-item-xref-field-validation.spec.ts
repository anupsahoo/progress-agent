// ui-057-supplier-item-xref-field-validation: SupplierItemXref: Inline field validation
// Module: Supplier Management · Table: SupplierItemXref · Legacy: legacy/supplier-management/supplier_item_xref_browse.w
import { test, expect } from '@playwright/test';

test.describe('Supplier Management / SupplierItemXref', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/supplier-management/supplier-item-xrefs` : '#/supplier-management/supplier-item-xrefs');
  });

  test("SupplierItemXref: Inline field validation", async ({ page }) => {
    await page.getByTestId('row').first().dblclick();
    await page.getByTestId('edit').click();
    await page.getByTestId('field-SupplierIDNum').fill("-1");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('error-SupplierIDNum')).toBeVisible();
  });
});
