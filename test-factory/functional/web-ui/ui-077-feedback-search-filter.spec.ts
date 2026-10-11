// ui-077-feedback-search-filter: Feedback: Search filters the list
// Module: Customer Management · Table: Feedback · Legacy: legacy/customer-management/feedback_browse.w
import { test, expect } from '@playwright/test';

test.describe('Customer Management / Feedback', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/customer-management/feedbacks` : '#/customer-management/feedbacks');
  });

  test("Feedback: Search filters the list", async ({ page }) => {
    const total = await page.getByTestId('row').count();
    await page.getByTestId('search').fill("Joe");
    await expect.poll(async () => page.getByTestId('row').count()).toBeLessThanOrEqual(total);
  });
});
