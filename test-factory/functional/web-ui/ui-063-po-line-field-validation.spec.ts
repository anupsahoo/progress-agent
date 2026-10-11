// ui-063-po-line-field-validation: POLine: Inline field validation
// Module: Purchasing · Table: POLine · Legacy: legacy/purchasing/po_line_browse.w
import { test, expect } from '@playwright/test';

test.describe('Purchasing / POLine', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/purchasing/po-lines` : '#/purchasing/po-lines');
  });

  test("POLine: Inline field validation", async ({ page }) => {
    await page.getByTestId('row').first().dblclick();
    await page.getByTestId('edit').click();
    await page.getByTestId('field-Itemnum').fill("-1");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('error-Itemnum')).toBeVisible();
  });
});
