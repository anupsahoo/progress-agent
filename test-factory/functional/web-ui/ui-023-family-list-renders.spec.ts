// ui-023-family-list-renders: Family: List renders with legacy labels
// Module: HR & Payroll · Table: Family · Legacy: legacy/hr-payroll/family_browse.w
import { test, expect } from '@playwright/test';

test.describe('HR & Payroll / Family', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/hr-payroll/families` : '#/hr-payroll/families');
  });

  test("Family: List renders with legacy labels", async ({ page }) => {
    await expect(page.getByTestId('family-list')).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Emp No" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Relative Name" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Relation" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Birthdate" })).toBeVisible();
    await expect(page.getByTestId('row').first()).toBeVisible();
  });
});
