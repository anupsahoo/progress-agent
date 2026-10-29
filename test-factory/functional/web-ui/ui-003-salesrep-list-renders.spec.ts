// ui-003-salesrep-list-renders: Salesrep: List renders with legacy labels
// Module: Sales & Territories · Table: Salesrep · Legacy: legacy/sales-territories/salesrep_browse.w
import { test, expect } from '@playwright/test';

test.describe('Sales & Territories / Salesrep', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/sales-territories/salesreps` : '#/sales-territories/salesreps');
  });

  test("Salesrep: List renders with legacy labels", async ({ page }) => {
    await expect(page.getByTestId('salesrep-list')).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Sales Rep" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Rep Name" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Region" })).toBeVisible();
    await expect(page.getByTestId('row').first()).toBeVisible();
  });
});
