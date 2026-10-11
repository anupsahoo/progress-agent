// ui-067-ref-call-field-validation: RefCall: Inline field validation
// Module: Credit Management · Table: RefCall · Legacy: legacy/credit-management/ref_call_browse.w
import { test, expect } from '@playwright/test';

test.describe('Credit Management / RefCall', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/credit-management/ref-calls` : '#/credit-management/ref-calls');
  });

  test("RefCall: Inline field validation", async ({ page }) => {
    await page.getByTestId('row').first().dblclick();
    await page.getByTestId('edit').click();
    await page.getByTestId('field-CustNum').fill("0");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('error-CustNum')).toBeVisible();
  });
});
