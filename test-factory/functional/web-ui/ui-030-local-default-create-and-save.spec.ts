// ui-030-local-default-create-and-save: LocalDefault: Create and save
// Module: Sales & Territories · Table: LocalDefault · Legacy: legacy/sales-territories/local_default_browse.w
import { test, expect } from '@playwright/test';

test.describe('Sales & Territories / LocalDefault', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/sales-territories/local-defaults` : '#/sales-territories/local-defaults');
  });

  test("LocalDefault: Create and save", async ({ page }) => {
    await page.getByTestId('new').click();
    await page.getByTestId('field-LocalDefNum').fill("90002");
    await page.getByTestId('field-Country').fill("Deutschland");
    await page.getByTestId('field-Region1Label').fill("Stadt");
    await page.getByTestId('field-Region2Label').fill("");
    await page.getByTestId('field-PostalLabel').fill("Postleitzahl");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('banner')).toHaveText('LocalDefault saved.');
  });
});
