import { test, expect } from '@playwright/test';

// One test per acceptance criterion in specs/requirements.md.
test.describe('customer_maint — automated UI tests', () => {
  test.beforeEach(async ({ page }) => { await page.goto('#customer-maint'); });

  test('R1 looks up a customer by number', async ({ page }) => {
    await page.getByLabel(/customer number/i).fill('3');
    await page.getByRole('button', { name: /load|search/i }).click();
    await expect(page.getByLabel(/name/i).first()).not.toHaveValue('');
  });

  test('R2 shows "not found" for an unknown customer', async ({ page }) => {
    await page.getByLabel(/customer number/i).fill('99999');
    await page.getByRole('button', { name: /load|search/i }).click();
    await expect(page.getByText(/not found/i)).toBeVisible();
  });

  test('R3 customer number is read-only once loaded; six fields editable', async ({ page }) => {
    await page.getByLabel(/customer number/i).fill('3');
    await page.getByRole('button', { name: /load|search/i }).click();
    for (const f of [/name/i, /address/i, /city/i, /state/i, /postal/i, /phone/i]) {
      await expect(page.getByLabel(f).first()).toBeEditable();
    }
  });

  test('R4 save shows a success confirmation', async ({ page }) => {
    await page.getByLabel(/customer number/i).fill('3');
    await page.getByRole('button', { name: /load|search/i }).click();
    await page.getByLabel(/city/i).first().fill('Boston');
    await page.getByRole('button', { name: /save/i }).click();
    await expect(page.getByText(/updated/i)).toBeVisible();
  });
});
