import { test, expect } from '@playwright/test';

test.describe('Customer Maintenance', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/customer_maint');
  });

  test('should load the page and render form fields', async ({ page }) => {
    const title = page.locator('h1');
    await expect(title).toHaveText('Customer Maintenance');

    const customerNumberInput = page.locator('input[name="customerNumber"]');
    await expect(customerNumberInput).toBeVisible();
  });

  test('should display customer details on valid submission', async ({ page }) => {
    const customerNumberInput = page.locator('input[name="customerNumber"]');
    await customerNumberInput.fill('12345');

    const submitButton = page.locator('button[type="submit"]');
    await submitButton.click();

    const customerDetails = page.locator('.customer-details');
    await expect(customerDetails).toBeVisible();
    await expect(customerDetails).toContainText('Customer Name: John Doe');
  });

  test('should show validation error for empty customer number', async ({ page }) => {
    const submitButton = page.locator('button[type="submit"]');
    await submitButton.click();

    const errorMessage = page.locator('.error-message');
    await expect(errorMessage).toBeVisible();
    await expect(errorMessage).toHaveText('Customer number is required.');
  });

  test('should show error message for non-existent customer', async ({ page }) => {
    const customerNumberInput = page.locator('input[name="customerNumber"]');
    await customerNumberInput.fill('99999');

    const submitButton = page.locator('button[type="submit"]');
    await submitButton.click();

    const errorMessage = page.locator('.error-message');
    await expect(errorMessage).toBeVisible();
    await expect(errorMessage).toHaveText('Customer not found.');
  });
});