// ui-051-customer-field-validation: Customer: Inline field validation
// Module: Customer Management · Table: Customer · Legacy: legacy/customer-management/customer_browse.w
import { test, expect } from '@playwright/test';

test.describe('Customer Management / Customer', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/customer-management/customers` : '#/customer-management/customers');
  });

  test("Customer: Inline field validation", async ({ page }) => {
    await page.getByTestId('row').first().dblclick();
    await page.getByTestId('edit').click();
    await page.getByTestId('field-CustNum').fill("0");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('error-CustNum')).toBeVisible();
  });
});
