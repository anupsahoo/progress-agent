import { test, expect } from '@playwright/test';

test.describe('Customer Maintenance', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/customer_maint');
  });

  test('should load the page and render form fields', async ({ page }) => {
    await expect(page).toHaveTitle(/Customer Maintenance/);
    await expect(page.locator('input[name="CustNum"]')).toBeVisible();
    await expect(page.locator('input[name="Name"]')).toBeVisible();
    await expect(page.locator('input[name="Address"]')).toBeVisible();
    await expect(page.locator('input[name="City"]')).toBeVisible();
    await expect(page.locator('input[name="State"]')).toBeVisible();
    await expect(page.locator('input[name="PostalCode"]')).toBeVisible();
    await expect(page.locator('input[name="Phone"]')).toBeVisible();
  });

  test('should submit valid customer updates', async ({ page }) => {
    await page.fill('input[name="CustNum"]', '12345');
    await page.fill('input[name="Name"]', 'John Doe');
    await page.fill('input[name="Address"]', '123 Main St');
    await page.fill('input[name="City"]', 'Anytown');
    await page.fill('input[name="State"]', 'CA');
    await page.fill('input[name="PostalCode"]', '90210');
    await page.fill('input[name="Phone"]', '555-1234');
    await page.click('button[type="submit"]');

    await expect(page.locator('.success-message')).toContainText('Customer updated successfully');
  });

  test('should display validation errors for invalid input', async ({ page }) => {
    await page.fill('input[name="CustNum"]', '');
    await page.click('button[type="submit"]');

    await expect(page.locator('.error-message')).toContainText('Customer Number is required');
  });
});