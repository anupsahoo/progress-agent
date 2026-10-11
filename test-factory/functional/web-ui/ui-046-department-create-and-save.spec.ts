// ui-046-department-create-and-save: Department: Create and save
// Module: HR & Payroll · Table: Department · Legacy: legacy/hr-payroll/department_browse.w
import { test, expect } from '@playwright/test';

test.describe('HR & Payroll / Department', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/hr-payroll/departments` : '#/hr-payroll/departments');
  });

  test("Department: Create and save", async ({ page }) => {
    await page.getByTestId('new').click();
    await page.getByTestId('field-DeptCode').fill("T200");
    await page.getByTestId('field-DeptName').fill("Administration");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('banner')).toHaveText('Department saved.');
  });
});
