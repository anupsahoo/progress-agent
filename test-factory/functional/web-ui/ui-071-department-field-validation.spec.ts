// ui-071-department-field-validation: Department: Inline field validation
// Module: HR & Payroll · Table: Department · Legacy: legacy/hr-payroll/department_browse.w
import { test, expect } from '@playwright/test';

test.describe('HR & Payroll / Department', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/hr-payroll/departments` : '#/hr-payroll/departments');
  });

  test("Department: Inline field validation", async ({ page }) => {
    await page.getByTestId('row').first().dblclick();
    await page.getByTestId('edit').click();
    await page.getByTestId('field-DeptName').fill("XXXXXXXXXXXXXXXX");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('error-DeptName')).toBeVisible();
  });
});
