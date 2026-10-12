// ui-025-vacation-list-renders: Vacation: List renders with legacy labels
// Module: HR & Payroll · Table: Vacation · Legacy: legacy/hr-payroll/vacation_browse.w
import { test, expect } from '@playwright/test';

test.describe('HR & Payroll / Vacation', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/hr-payroll/vacations` : '#/hr-payroll/vacations');
  });

  test("Vacation: List renders with legacy labels", async ({ page }) => {
    await expect(page.getByTestId('vacation-list')).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Emp No" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Start Date" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "End Date" })).toBeVisible();
    await expect(page.getByTestId('row').first()).toBeVisible();
  });
});
