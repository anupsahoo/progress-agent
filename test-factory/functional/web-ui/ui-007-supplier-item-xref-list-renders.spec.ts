// ui-007-supplier-item-xref-list-renders: SupplierItemXref: List renders with legacy labels
// Module: Supplier Management · Table: SupplierItemXref · Legacy: legacy/supplier-management/supplier_item_xref_browse.w
import { test, expect } from '@playwright/test';

test.describe('Supplier Management / SupplierItemXref', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/supplier-management/supplier-item-xrefs` : '#/supplier-management/supplier-item-xrefs');
  });

  test("SupplierItemXref: List renders with legacy labels", async ({ page }) => {
    await expect(page.getByTestId('supplier-item-xref-list')).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Supplier ID" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Item #" })).toBeVisible();
    await expect(page.getByTestId('row').first()).toBeVisible();
  });
});
