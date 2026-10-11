// ui-042-ref-call-create-and-save: RefCall: Create and save
// Module: Credit Management · Table: RefCall · Legacy: legacy/credit-management/ref_call_browse.w
import { test, expect } from '@playwright/test';

test.describe('Credit Management / RefCall', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/credit-management/ref-calls` : '#/credit-management/ref-calls');
  });

  test("RefCall: Create and save", async ({ page }) => {
    await page.getByTestId('new').click();
    await page.getByTestId('field-CallNum').fill("T000002");
    await page.getByTestId('field-CustNum').fill("21");
    await page.getByTestId('field-CallDate').fill("1998-01-21");
    await page.getByTestId('field-SalesRep').fill("HXM");
    await page.getByTestId('field-Parent').fill("");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('banner')).toHaveText('RefCall saved.');
  });
});
