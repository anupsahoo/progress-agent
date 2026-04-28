import { test, expect } from '@playwright/test';

test.describe('Customer Maintenance', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/customer_maint');
  });

  test('should load the customer maintenance page', async ({ page }) => {
    await expect(page).toHaveTitle(/Customer Maintenance/);
    const frame = page.frameLocator('frame[name="fMain"]');
    await expect(frame).toBeVisible();
  });

  test('should render input for customer number', async ({ page }) => {
    const frame = page.frameLocator('frame[name="fMain"]');
    const customerInput = frame.locator('input[name="customerNumber"]');
    await expect(customerInput).toBeVisible();
  });

  test('should submit valid customer number and update information', async ({ page }) => {
    const frame = page.frameLocator('frame[name="fMain"]');
    const customerInput = frame.locator('input[name="customerNumber"]');
    await customerInput.fill('12345');
    await frame.locator('button[type="submit"]').click();

    const successMessage = frame.locator('.success-message');
    await expect(successMessage).toBeVisible();
    await expect(successMessage).toHaveText('Customer information updated successfully.');
  });

  test('should display validation error for empty customer number', async ({ page }) => {
    const frame = page.frameLocator('frame[name="fMain"]');
    const customerInput = frame.locator('input[name="customerNumber"]');
    await customerInput.fill('');
    await frame.locator('button[type="submit"]').click();

    const errorMessage = frame.locator('.error-message');
    await expect(errorMessage).toBeVisible();
    await expect(errorMessage).toHaveText('Customer number is required.');
  });
});