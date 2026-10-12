// ui-043-invoice-create-and-save: Invoice: Create and save
// Module: Billing & Invoicing · Table: Invoice · Legacy: legacy/billing-invoicing/invoice_browse.w
import { test, expect } from '@playwright/test';

test.describe('Billing & Invoicing / Invoice', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/billing-invoicing/invoices` : '#/billing-invoicing/invoices');
  });

  test("Invoice: Create and save", async ({ page }) => {
    await page.getByTestId('new').click();
    await page.getByTestId('field-Invoicenum').fill("90002");
    await page.getByTestId('field-CustNum').fill("81");
    await page.getByTestId('field-InvoiceDate').fill("1997-10-06");
    await page.getByTestId('field-Amount').fill("2812.98");
    await page.getByTestId('field-TotalPaid').fill("2812.98");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('banner')).toHaveText('Invoice saved.');
  });
});
