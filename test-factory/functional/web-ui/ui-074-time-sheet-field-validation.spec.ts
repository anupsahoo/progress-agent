// ui-074-time-sheet-field-validation: TimeSheet: Inline field validation
// Module: HR & Payroll · Table: TimeSheet · Legacy: legacy/hr-payroll/time_sheet_browse.w
import { test, expect } from '@playwright/test';

test.describe('HR & Payroll / TimeSheet', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/hr-payroll/time-sheets` : '#/hr-payroll/time-sheets');
  });

  test("TimeSheet: Inline field validation", async ({ page }) => {
    await page.getByTestId('row').first().dblclick();
    await page.getByTestId('edit').click();
    await page.getByTestId('field-EmpNum').fill("-1");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('error-EmpNum')).toBeVisible();
  });
});
