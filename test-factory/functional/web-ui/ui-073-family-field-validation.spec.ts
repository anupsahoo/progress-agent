// ui-073-family-field-validation: Family: Inline field validation
// Module: HR & Payroll · Table: Family · Legacy: legacy/hr-payroll/family_browse.w
import { test, expect } from '@playwright/test';

test.describe('HR & Payroll / Family', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/hr-payroll/families` : '#/hr-payroll/families');
  });

  test("Family: Inline field validation", async ({ page }) => {
    await page.getByTestId('row').first().dblclick();
    await page.getByTestId('edit').click();
    await page.getByTestId('field-EmpNum').fill("-1");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('error-EmpNum')).toBeVisible();
  });
});
