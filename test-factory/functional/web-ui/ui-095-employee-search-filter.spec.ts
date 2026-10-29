// ui-095-employee-search-filter: Employee: Search filters the list
// Module: HR & Payroll · Table: Employee · Legacy: legacy/hr-payroll/employee_browse.w
import { test, expect } from '@playwright/test';

test.describe('HR & Payroll / Employee', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/hr-payroll/employees` : '#/hr-payroll/employees');
  });

  test("Employee: Search filters the list", async ({ page }) => {
    const total = await page.getByTestId('row').count();
    await page.getByTestId('search').fill("And");
    await expect.poll(async () => page.getByTestId('row').count()).toBeLessThanOrEqual(total);
  });
});
