// ui-001-customer-list-renders: Customer: List renders with legacy labels
// Module: Customer Management · Table: Customer · Legacy: legacy/customer-management/customer_browse.w
import { test, expect } from '@playwright/test';

test.describe('Customer Management / Customer', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/customer-management/customers` : '#/customer-management/customers');
  });

  test("Customer: List renders with legacy labels", async ({ page }) => {
    await expect(page.getByTestId('customer-list')).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Cust Num" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Country" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Name" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Address" })).toBeVisible();
    await expect(page.getByTestId('row').first()).toBeVisible();
  });
});
