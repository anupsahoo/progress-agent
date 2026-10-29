// ui-055-local-default-field-validation: LocalDefault: Inline field validation
// Module: Sales & Territories · Table: LocalDefault · Legacy: legacy/sales-territories/local_default_browse.w
import { test, expect } from '@playwright/test';

test.describe('Sales & Territories / LocalDefault', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/sales-territories/local-defaults` : '#/sales-territories/local-defaults');
  });

  test("LocalDefault: Inline field validation", async ({ page }) => {
    await page.getByTestId('row').first().dblclick();
    await page.getByTestId('edit').click();
    await page.getByTestId('field-Country').fill("XXXXXXXXXXXXXXXXXXXXX");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('error-Country')).toBeVisible();
  });
});
