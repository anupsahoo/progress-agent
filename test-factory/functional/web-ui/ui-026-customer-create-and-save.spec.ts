// ui-026-customer-create-and-save: Customer: Create and save
// Module: Customer Management · Table: Customer · Legacy: legacy/customer-management/customer_browse.w
import { test, expect } from '@playwright/test';

test.describe('Customer Management / Customer', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/customer-management/customers` : '#/customer-management/customers');
  });

  test("Customer: Create and save", async ({ page }) => {
    await page.getByTestId('new').click();
    await page.getByTestId('field-CustNum').fill("90002");
    await page.getByTestId('field-Country').fill("Finland");
    await page.getByTestId('field-Name').fill("Urpon Frisbee");
    await page.getByTestId('field-Address').fill("Rattipolku 3");
    await page.getByTestId('field-Address2').fill("");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('banner')).toHaveText('Customer saved.');
  });
});
