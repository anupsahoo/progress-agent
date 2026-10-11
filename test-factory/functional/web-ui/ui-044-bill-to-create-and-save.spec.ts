// ui-044-bill-to-create-and-save: BillTo: Create and save
// Module: Billing & Invoicing · Table: BillTo · Legacy: legacy/billing-invoicing/bill_to_browse.w
import { test, expect } from '@playwright/test';

test.describe('Billing & Invoicing / BillTo', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/billing-invoicing/bill-tos` : '#/billing-invoicing/bill-tos');
  });

  test("BillTo: Create and save", async ({ page }) => {
    await page.getByTestId('new').click();
    await page.getByTestId('field-CustNum').fill("90005");
    await page.getByTestId('field-BillToID').fill("90002");
    await page.getByTestId('field-Name').fill("GA - Finance Offc.");
    await page.getByTestId('field-Address').fill("987 Peachtree St.");
    await page.getByTestId('field-Address2').fill("Suite 1100");
    await page.getByTestId('field-City').fill("Atanta");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('banner')).toHaveText('BillTo saved.');
  });
});
