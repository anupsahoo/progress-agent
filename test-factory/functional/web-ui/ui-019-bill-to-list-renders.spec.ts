// ui-019-bill-to-list-renders: BillTo: List renders with legacy labels
// Module: Billing & Invoicing · Table: BillTo · Legacy: legacy/billing-invoicing/bill_to_browse.w
import { test, expect } from '@playwright/test';

test.describe('Billing & Invoicing / BillTo', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/billing-invoicing/bill-tos` : '#/billing-invoicing/bill-tos');
  });

  test("BillTo: List renders with legacy labels", async ({ page }) => {
    await expect(page.getByTestId('bill-to-list')).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Cust Num" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "BillToID" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Name" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Address" })).toBeVisible();
    await expect(page.getByTestId('row').first()).toBeVisible();
  });
});
