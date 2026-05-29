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

  test('should submit valid customer number and update information', async ({ page }) => {
    await page.fill('input[name="customerNumber"]', '12345');
    await page.click('button[type="submit"]');
    const successMessage = page.locator('.success-message');
    await expect(successMessage).toHaveText('Customer information updated successfully.');
  });

  test('should display validation error for invalid customer number', async ({ page }) => {
    await page.fill('input[name="customerNumber"]', '');
    await page.click('button[type="submit"]');
    const errorMessage = page.locator('.error-message');
    await expect(errorMessage).toHaveText('Customer number is required.');
  });

  test('should display error message for non-existent customer', async ({ page }) => {
    await page.fill('input[name="customerNumber"]', '99999');
    await page.click('button[type="submit"]');
    const errorMessage = page.locator('.error-message');
    await expect(errorMessage).toHaveText('Customer not found.');
  });
});