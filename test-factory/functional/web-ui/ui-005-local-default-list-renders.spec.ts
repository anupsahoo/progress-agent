// ui-005-local-default-list-renders: LocalDefault: List renders with legacy labels
// Module: Sales & Territories · Table: LocalDefault · Legacy: legacy/sales-territories/local_default_browse.w
import { test, expect } from '@playwright/test';

test.describe('Sales & Territories / LocalDefault', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/sales-territories/local-defaults` : '#/sales-territories/local-defaults');
  });

  test("LocalDefault: List renders with legacy labels", async ({ page }) => {
    await expect(page.getByTestId('local-default-list')).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Country" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Region1 Label" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Region2 Label" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Postal Label" })).toBeVisible();
    await expect(page.getByTestId('row').first()).toBeVisible();
  });
});
