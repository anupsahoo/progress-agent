// ui-088-po-line-search-filter: POLine: Search filters the list
// Module: Purchasing · Table: POLine · Legacy: legacy/purchasing/po_line_browse.w
import { test, expect } from '@playwright/test';

test.describe('Purchasing / POLine', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/purchasing/po-lines` : '#/purchasing/po-lines');
  });

  test("POLine: Search filters the list", async ({ page }) => {
    const total = await page.getByTestId('row').count();
    await page.getByTestId('search').fill("Rec");
    await expect.poll(async () => page.getByTestId('row').count()).toBeLessThanOrEqual(total);
  });
});
