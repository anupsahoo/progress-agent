// ui-021-department-list-renders: Department: List renders with legacy labels
// Module: HR & Payroll · Table: Department · Legacy: legacy/hr-payroll/department_browse.w
import { test, expect } from '@playwright/test';

test.describe('HR & Payroll / Department', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/hr-payroll/departments` : '#/hr-payroll/departments');
  });

  test("Department: List renders with legacy labels", async ({ page }) => {
    await expect(page.getByTestId('department-list')).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Dept Code" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Dept Name" })).toBeVisible();
    await expect(page.getByTestId('row').first()).toBeVisible();
  });
});
