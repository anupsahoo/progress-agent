// ui-029-state-create-and-save: State: Create and save
// Module: Sales & Territories · Table: State · Legacy: legacy/sales-territories/state_browse.w
import { test, expect } from '@playwright/test';

test.describe('Sales & Territories / State', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/sales-territories/states` : '#/sales-territories/states');
  });

  test("State: Create and save", async ({ page }) => {
    await page.getByTestId('new').click();
    await page.getByTestId('field-State').fill("TAL");
    await page.getByTestId('field-StateName').fill("Alabama");
    await page.getByTestId('field-Region').fill("South");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('banner')).toHaveText('State saved.');
  });
});
