// ui-006-supplier-list-renders: Supplier: List renders with legacy labels
// Module: Supplier Management · Table: Supplier · Legacy: legacy/supplier-management/supplier_browse.w
import { test, expect } from '@playwright/test';

test.describe('Supplier Management / Supplier', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/supplier-management/suppliers` : '#/supplier-management/suppliers');
  });

  test("Supplier: List renders with legacy labels", async ({ page }) => {
    await expect(page.getByTestId('supplier-list')).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Supplier ID" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Name" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Address" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Address2" })).toBeVisible();
    await expect(page.getByTestId('row').first()).toBeVisible();
  });
});
