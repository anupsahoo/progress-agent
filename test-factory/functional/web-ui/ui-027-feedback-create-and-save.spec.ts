// ui-027-feedback-create-and-save: Feedback: Create and save
// Module: Customer Management · Table: Feedback · Legacy: legacy/customer-management/feedback_browse.w
import { test, expect } from '@playwright/test';

test.describe('Customer Management / Feedback', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/customer-management/feedbacks` : '#/customer-management/feedbacks');
  });

  test("Feedback: Create and save", async ({ page }) => {
    await page.getByTestId('new').click();
    await page.getByTestId('field-Department').fill("TAccount");
    await page.getByTestId('field-Contact').fill("Joe Smith");
    await page.getByTestId('field-Company').fill("Lift Line Skiing");
    await page.getByTestId('field-EmailAddress').fill("joe_smith@liftline.com");
    await page.getByTestId('field-Phone').fill("");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('banner')).toHaveText('Feedback saved.');
  });
});
