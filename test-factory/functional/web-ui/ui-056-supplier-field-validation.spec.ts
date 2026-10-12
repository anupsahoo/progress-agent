// ui-056-supplier-field-validation: Supplier: Inline field validation
// Module: Supplier Management · Table: Supplier · Legacy: legacy/supplier-management/supplier_browse.w
import { test, expect } from '@playwright/test';

test.describe('Supplier Management / Supplier', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/supplier-management/suppliers` : '#/supplier-management/suppliers');
  });

  test("Supplier: Inline field validation", async ({ page }) => {
    await page.getByTestId('row').first().dblclick();
    await page.getByTestId('edit').click();
    await page.getByTestId('field-SupplierIDNum').fill("0");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('error-SupplierIDNum')).toBeVisible();
  });
});
