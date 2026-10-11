// ui-024-time-sheet-list-renders: TimeSheet: List renders with legacy labels
// Module: HR & Payroll · Table: TimeSheet · Legacy: legacy/hr-payroll/time_sheet_browse.w
import { test, expect } from '@playwright/test';

test.describe('HR & Payroll / TimeSheet', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/hr-payroll/time-sheets` : '#/hr-payroll/time-sheets');
  });

  test("TimeSheet: List renders with legacy labels", async ({ page }) => {
    await expect(page.getByTestId('time-sheet-list')).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Emp No" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Day Recorded" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Type Recorded" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "AM Time In" })).toBeVisible();
    await expect(page.getByTestId('row').first()).toBeVisible();
  });
});
