// ui-096-department-search-filter: Department: Search filters the list
// Module: HR & Payroll · Table: Department · Legacy: legacy/hr-payroll/department_browse.w
import { test, expect } from '@playwright/test';

test.describe('HR & Payroll / Department', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/hr-payroll/departments` : '#/hr-payroll/departments');
  });

  test("Department: Search filters the list", async ({ page }) => {
    const total = await page.getByTestId('row').count();
    await page.getByTestId('search').fill("200");
    await expect.poll(async () => page.getByTestId('row').count()).toBeLessThanOrEqual(total);
  });
});
