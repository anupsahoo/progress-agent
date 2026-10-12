// ui-075-vacation-field-validation: Vacation: Inline field validation
// Module: HR & Payroll · Table: Vacation · Legacy: legacy/hr-payroll/vacation_browse.w
import { test, expect } from '@playwright/test';

test.describe('HR & Payroll / Vacation', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/hr-payroll/vacations` : '#/hr-payroll/vacations');
  });

  test("Vacation: Inline field validation", async ({ page }) => {
    await page.getByTestId('row').first().dblclick();
    await page.getByTestId('edit').click();
    await page.getByTestId('field-EmpNum').fill("-1");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('error-EmpNum')).toBeVisible();
  });
});
