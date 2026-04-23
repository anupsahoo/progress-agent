import { test, expect } from '@playwright/test';

test('Customer Maintenance', async ({ page }) => {
  await page.goto('http://localhost:5173');
  await page.fill('input[placeholder="Enter Customer Number"]', '1');
  await page.click('button:has-text("Find Customer")');
  await expect(page.locator('text=Customer Details')).toBeVisible();
  await page.fill('input[type="text"]', 'Updated Name');
  await page.click('button:has-text("Update Customer")');
  await expect(page.locator('text=Record updated successfully.')).toBeVisible();
});