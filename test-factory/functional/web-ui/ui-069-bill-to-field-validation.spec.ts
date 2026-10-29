// ui-069-bill-to-field-validation: BillTo: Inline field validation
// Module: Billing & Invoicing · Table: BillTo · Legacy: legacy/billing-invoicing/bill_to_browse.w
import { test, expect } from '@playwright/test';

test.describe('Billing & Invoicing / BillTo', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/billing-invoicing/bill-tos` : '#/billing-invoicing/bill-tos');
  });

  test("BillTo: Inline field validation", async ({ page }) => {
    await page.getByTestId('row').first().dblclick();
    await page.getByTestId('edit').click();
    await page.getByTestId('field-CustNum').fill("-1");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('error-CustNum')).toBeVisible();
  });
});
