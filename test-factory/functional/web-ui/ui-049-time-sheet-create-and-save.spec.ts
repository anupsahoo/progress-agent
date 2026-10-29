// ui-049-time-sheet-create-and-save: TimeSheet: Create and save
// Module: HR & Payroll · Table: TimeSheet · Legacy: legacy/hr-payroll/time_sheet_browse.w
import { test, expect } from '@playwright/test';

test.describe('HR & Payroll / TimeSheet', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/hr-payroll/time-sheets` : '#/hr-payroll/time-sheets');
  });

  test("TimeSheet: Create and save", async ({ page }) => {
    await page.getByTestId('new').click();
    await page.getByTestId('field-EmpNum').fill("90002");
    await page.getByTestId('field-DayRecorded').fill("T1998-01");
    await page.getByTestId('field-TypeRecorded').fill("full");
    await page.getByTestId('field-AMTimeIn').fill("901");
    await page.getByTestId('field-AMTimeOut').fill("");
    await page.getByTestId('field-PMTimeIn').fill("");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('banner')).toHaveText('TimeSheet saved.');
  });
});
