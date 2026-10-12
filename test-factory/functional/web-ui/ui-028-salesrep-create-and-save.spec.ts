// ui-028-salesrep-create-and-save: Salesrep: Create and save
// Module: Sales & Territories · Table: Salesrep · Legacy: legacy/sales-territories/salesrep_browse.w
import { test, expect } from '@playwright/test';

test.describe('Sales & Territories / Salesrep', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/sales-territories/salesreps` : '#/sales-territories/salesreps');
  });

  test("Salesrep: Create and save", async ({ page }) => {
    await page.getByTestId('new').click();
    await page.getByTestId('field-SalesRep').fill("TDKP");
    await page.getByTestId('field-RepName').fill("Pitt , Dirk K.");
    await page.getByTestId('field-Region').fill("Central");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('banner')).toHaveText('Salesrep saved.');
  });
});
