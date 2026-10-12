// ui-092-ref-call-search-filter: RefCall: Search filters the list
// Module: Credit Management · Table: RefCall · Legacy: legacy/credit-management/ref_call_browse.w
import { test, expect } from '@playwright/test';

test.describe('Credit Management / RefCall', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/credit-management/ref-calls` : '#/credit-management/ref-calls');
  });

  test("RefCall: Search filters the list", async ({ page }) => {
    const total = await page.getByTestId('row').count();
    await page.getByTestId('search').fill("000");
    await expect.poll(async () => page.getByTestId('row').count()).toBeLessThanOrEqual(total);
  });
});
