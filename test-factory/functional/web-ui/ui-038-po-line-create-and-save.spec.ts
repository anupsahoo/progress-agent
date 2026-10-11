// ui-038-po-line-create-and-save: POLine: Create and save
// Module: Purchasing · Table: POLine · Legacy: legacy/purchasing/po_line_browse.w
import { test, expect } from '@playwright/test';

test.describe('Purchasing / POLine', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/purchasing/po-lines` : '#/purchasing/po-lines');
  });

  test("POLine: Create and save", async ({ page }) => {
    await page.getByTestId('new').click();
    await page.getByTestId('field-PONum').fill("98001");
    await page.getByTestId('field-Linenum').fill("90002");
    await page.getByTestId('field-Itemnum').fill("45");
    await page.getByTestId('field-Price').fill("81");
    await page.getByTestId('field-Qty').fill("5");
    await page.getByTestId('field-Discount').fill("0");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('banner')).toHaveText('POLine saved.');
  });
});
