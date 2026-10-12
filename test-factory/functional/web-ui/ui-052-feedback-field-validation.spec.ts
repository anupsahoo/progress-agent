// ui-052-feedback-field-validation: Feedback: Inline field validation
// Module: Customer Management · Table: Feedback · Legacy: legacy/customer-management/feedback_browse.w
import { test, expect } from '@playwright/test';

test.describe('Customer Management / Feedback', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/customer-management/feedbacks` : '#/customer-management/feedbacks');
  });

  test("Feedback: Inline field validation", async ({ page }) => {
    await page.getByTestId('row').first().dblclick();
    await page.getByTestId('edit').click();
    await page.getByTestId('field-Contact').fill("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('error-Contact')).toBeVisible();
  });
});
