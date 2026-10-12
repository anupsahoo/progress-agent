// ui-004-state-list-renders: State: List renders with legacy labels
// Module: Sales & Territories · Table: State · Legacy: legacy/sales-territories/state_browse.w
import { test, expect } from '@playwright/test';

test.describe('Sales & Territories / State', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/sales-territories/states` : '#/sales-territories/states');
  });

  test("State: List renders with legacy labels", async ({ page }) => {
    await expect(page.getByTestId('state-list')).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "State" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "State Name" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Region" })).toBeVisible();
    await expect(page.getByTestId('row').first()).toBeVisible();
  });
});
