// ui-020-employee-list-renders: Employee: List renders with legacy labels
// Module: HR & Payroll · Table: Employee · Legacy: legacy/hr-payroll/employee_browse.w
import { test, expect } from '@playwright/test';

test.describe('HR & Payroll / Employee', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/hr-payroll/employees` : '#/hr-payroll/employees');
  });

  test("Employee: List renders with legacy labels", async ({ page }) => {
    await expect(page.getByTestId('employee-list')).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Emp No" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Last Name" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "First Name" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Address" })).toBeVisible();
    await expect(page.getByTestId('row').first()).toBeVisible();
  });
});
