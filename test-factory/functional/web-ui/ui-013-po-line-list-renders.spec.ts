// ui-013-po-line-list-renders: POLine: List renders with legacy labels
// Module: Purchasing · Table: POLine · Legacy: legacy/purchasing/po_line_browse.w
import { test, expect } from '@playwright/test';

test.describe('Purchasing / POLine', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/purchasing/po-lines` : '#/purchasing/po-lines');
  });

  test("POLine: List renders with legacy labels", async ({ page }) => {
    await expect(page.getByTestId('po-line-list')).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Line Num" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Item Num" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Price" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Qty" })).toBeVisible();
    await expect(page.getByTestId('row').first()).toBeVisible();
  });
});
