// ui-048-family-create-and-save: Family: Create and save
// Module: HR & Payroll · Table: Family · Legacy: legacy/hr-payroll/family_browse.w
import { test, expect } from '@playwright/test';

test.describe('HR & Payroll / Family', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/hr-payroll/families` : '#/hr-payroll/families');
  });

  test("Family: Create and save", async ({ page }) => {
    await page.getByTestId('new').click();
    await page.getByTestId('field-EmpNum').fill("90001");
    await page.getByTestId('field-RelativeName').fill("TKen Kob");
    await page.getByTestId('field-Relation').fill("Spouse");
    await page.getByTestId('field-Birthdate').fill("1965-12-07");
    await page.getByTestId('field-BenefitDate').fill("1998-03-16");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('banner')).toHaveText('Family saved.');
  });
});
