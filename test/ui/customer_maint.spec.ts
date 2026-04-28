import { test, expect } from '@playwright/test';

test.describe('Customer Maintenance', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/customer_maint');
  });

  test('should load the page and render form fields', async ({ page }) => {
    await expect(page).toHaveTitle(/Customer Maintenance/);
    await expect(page.locator('input[name="CustNum"]').isVisible()).toBeTruthy();
    await expect(page.locator('input[name="Name"]').isVisible()).toBeTruthy();
    await expect(page.locator('input[name="Address"]').isVisible()).toBeTruthy();
    await expect(page.locator('input[name="City"]').isVisible()).toBeTruthy();
    await expect(page.locator('input[name="State"]').isVisible()).toBeTruthy();
    await expect(page.locator('input[name="PostalCode"]').isVisible()).toBeTruthy();
    await expect(page.locator('input[name="Phone"]').isVisible()).toBeTruthy();
  });

  test('should submit valid customer updates', async ({ page }) => {
    await page.fill('input[name="CustNum"]', '12345');
    await page.click('button[type="submit"]');
    await expect(page.locator('.success-message')).toHaveText('Customer updated successfully');
  });

  test('should display validation errors for invalid input', async ({ page }) => {
    await page.fill('input[name="CustNum"]', '');
    await page.click('button[type="submit"]');
    await expect(page.locator('.error-message')).toHaveText('Customer Number is required');
  });

  test('should handle exclusive lock correctly', async ({ page }) => {
    await page.fill('input[name="CustNum"]', '12345');
    await page.click('button[type="submit"]');
    await expect(page.locator('.lock-message')).toHaveText('Record is locked by another user');
  });
});