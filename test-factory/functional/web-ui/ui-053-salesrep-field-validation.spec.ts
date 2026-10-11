// ui-053-salesrep-field-validation: Salesrep: Inline field validation
// Module: Sales & Territories · Table: Salesrep · Legacy: legacy/sales-territories/salesrep_browse.w
import { test, expect } from '@playwright/test';

test.describe('Sales & Territories / Salesrep', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/sales-territories/salesreps` : '#/sales-territories/salesreps');
  });

  test("Salesrep: Inline field validation", async ({ page }) => {
    await page.getByTestId('row').first().dblclick();
    await page.getByTestId('edit').click();
    await page.getByTestId('field-RepName').fill("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('error-RepName')).toBeVisible();
  });
});
