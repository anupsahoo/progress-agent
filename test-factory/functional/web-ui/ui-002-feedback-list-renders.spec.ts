// ui-002-feedback-list-renders: Feedback: List renders with legacy labels
// Module: Customer Management · Table: Feedback · Legacy: legacy/customer-management/feedback_browse.w
import { test, expect } from '@playwright/test';

test.describe('Customer Management / Feedback', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/customer-management/feedbacks` : '#/customer-management/feedbacks');
  });

  test("Feedback: List renders with legacy labels", async ({ page }) => {
    await expect(page.getByTestId('feedback-list')).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Contact Name" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Company" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Email" })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: "Phone" })).toBeVisible();
    await expect(page.getByTestId('row').first()).toBeVisible();
  });
});
