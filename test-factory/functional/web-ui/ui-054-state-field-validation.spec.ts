// ui-054-state-field-validation: State: Inline field validation
// Module: Sales & Territories · Table: State · Legacy: legacy/sales-territories/state_browse.w
import { test, expect } from '@playwright/test';

test.describe('Sales & Territories / State', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/sales-territories/states` : '#/sales-territories/states');
  });

  test("State: Inline field validation", async ({ page }) => {
    await page.getByTestId('row').first().dblclick();
    await page.getByTestId('edit').click();
    await page.getByTestId('field-StateName').fill("XXXXXXXXXXXXXXXXXXXXX");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('error-StateName')).toBeVisible();
  });
});
