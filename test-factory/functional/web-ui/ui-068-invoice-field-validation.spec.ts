// ui-068-invoice-field-validation: Invoice: Inline field validation
// Module: Billing & Invoicing · Table: Invoice · Legacy: legacy/billing-invoicing/invoice_browse.w
import { test, expect } from '@playwright/test';

test.describe('Billing & Invoicing / Invoice', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/billing-invoicing/invoices` : '#/billing-invoicing/invoices');
  });

  test("Invoice: Inline field validation", async ({ page }) => {
    await page.getByTestId('row').first().dblclick();
    await page.getByTestId('edit').click();
    await page.getByTestId('field-Invoicenum').fill("0");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('error-Invoicenum')).toBeVisible();
  });
});
