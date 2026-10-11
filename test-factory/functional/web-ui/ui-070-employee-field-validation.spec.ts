// ui-070-employee-field-validation: Employee: Inline field validation
// Module: HR & Payroll · Table: Employee · Legacy: legacy/hr-payroll/employee_browse.w
import { test, expect } from '@playwright/test';

test.describe('HR & Payroll / Employee', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/hr-payroll/employees` : '#/hr-payroll/employees');
  });

  test("Employee: Inline field validation", async ({ page }) => {
    await page.getByTestId('row').first().dblclick();
    await page.getByTestId('edit').click();
    await page.getByTestId('field-LastName').fill("XXXXXXXXXXXXXXXXXXXXXXXXXX");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('error-LastName')).toBeVisible();
  });
});
