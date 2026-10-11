// ui-018-invoice-list-renders: Invoice: List renders with legacy labels
// Module: Billing & Invoicing · Table: Invoice · Legacy: legacy/billing-invoicing/invoice_browse.w
import { test, expect } from '@playwright/test';

test.describe('Billing & Invoicing / Invoice', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/billing-invoicing/invoices` : '#/billing-invoicing/invoices');
  });

  test("Invoice: List renders with legacy labels", async ({ page }) => {
    await expect(page.getByTestId('invoice-list')).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Invoice Num" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Cust Num" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Invoice Date" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Amount" })).toBeVisible();
    await expect(page.getByTestId('row').first()).toBeVisible();
  });
});
