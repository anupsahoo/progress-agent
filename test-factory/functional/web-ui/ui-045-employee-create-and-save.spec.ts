// ui-045-employee-create-and-save: Employee: Create and save
// Module: HR & Payroll · Table: Employee · Legacy: legacy/hr-payroll/employee_browse.w
import { test, expect } from '@playwright/test';

test.describe('HR & Payroll / Employee', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/hr-payroll/employees` : '#/hr-payroll/employees');
  });

  test("Employee: Create and save", async ({ page }) => {
    await page.getByTestId('new').click();
    await page.getByTestId('field-EmpNum').fill("90002");
    await page.getByTestId('field-LastName').fill("Andrews");
    await page.getByTestId('field-FirstName').fill("Anita");
    await page.getByTestId('field-Address').fill("10 Smith St");
    await page.getByTestId('field-Address2').fill("");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('banner')).toHaveText('Employee saved.');
  });
});
