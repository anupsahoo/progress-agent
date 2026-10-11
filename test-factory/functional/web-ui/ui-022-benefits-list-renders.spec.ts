// ui-022-benefits-list-renders: Benefits: List renders with legacy labels
// Module: HR & Payroll · Table: Benefits · Legacy: legacy/hr-payroll/benefits_browse.w
import { test, expect } from '@playwright/test';

test.describe('HR & Payroll / Benefits', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/hr-payroll/benefitses` : '#/hr-payroll/benefitses');
  });

  test("Benefits: List renders with legacy labels", async ({ page }) => {
    await expect(page.getByTestId('benefits-list')).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Emp No" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Health Care" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Life Insurance" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Pension401K" })).toBeVisible();
    await expect(page.getByTestId('row').first()).toBeVisible();
  });
});
