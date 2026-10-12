// ui-031-supplier-create-and-save: Supplier: Create and save
// Module: Supplier Management · Table: Supplier · Legacy: legacy/supplier-management/supplier_browse.w
import { test, expect } from '@playwright/test';

test.describe('Supplier Management / Supplier', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/supplier-management/suppliers` : '#/supplier-management/suppliers');
  });

  test("Supplier: Create and save", async ({ page }) => {
    await page.getByTestId('new').click();
    await page.getByTestId('field-SupplierIDNum').fill("90002");
    await page.getByTestId('field-Name').fill("Pool Swimming Supplies");
    await page.getByTestId('field-Address').fill("Rattipolku 3");
    await page.getByTestId('field-Address2').fill("-");
    await page.getByTestId('field-City').fill("Valkeala");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('banner')).toHaveText('Supplier saved.');
  });
});
