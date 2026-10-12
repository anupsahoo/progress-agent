// ui-072-benefits-field-validation: Benefits: Inline field validation
// Module: HR & Payroll · Table: Benefits · Legacy: legacy/hr-payroll/benefits_browse.w
import { test, expect } from '@playwright/test';

test.describe('HR & Payroll / Benefits', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/hr-payroll/benefitses` : '#/hr-payroll/benefitses');
  });

  test("Benefits: Inline field validation", async ({ page }) => {
    await page.getByTestId('row').first().dblclick();
    await page.getByTestId('edit').click();
    await page.getByTestId('field-EmpNum').fill("-1");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('error-EmpNum')).toBeVisible();
  });
});
