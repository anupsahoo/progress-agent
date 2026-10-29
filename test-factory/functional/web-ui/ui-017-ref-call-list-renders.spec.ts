// ui-017-ref-call-list-renders: RefCall: List renders with legacy labels
// Module: Credit Management · Table: RefCall · Legacy: legacy/credit-management/ref_call_browse.w
import { test, expect } from '@playwright/test';

test.describe('Credit Management / RefCall', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/credit-management/ref-calls` : '#/credit-management/ref-calls');
  });

  test("RefCall: List renders with legacy labels", async ({ page }) => {
    await expect(page.getByTestId('ref-call-list')).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Call Num" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Cust Num" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Call Date" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Sales Rep" })).toBeVisible();
    await expect(page.getByTestId('row').first()).toBeVisible();
  });
});
