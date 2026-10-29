// ui-050-vacation-create-and-save: Vacation: Create and save
// Module: HR & Payroll · Table: Vacation · Legacy: legacy/hr-payroll/vacation_browse.w
import { test, expect } from '@playwright/test';

test.describe('HR & Payroll / Vacation', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/hr-payroll/vacations` : '#/hr-payroll/vacations');
  });

  test("Vacation: Create and save", async ({ page }) => {
    await page.getByTestId('new').click();
    await page.getByTestId('field-EmpNum').fill("90002");
    await page.getByTestId('field-StartDate').fill("T1998-01");
    await page.getByTestId('field-EndDate').fill("1998-01-02");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('banner')).toHaveText('Vacation saved.');
  });
});
