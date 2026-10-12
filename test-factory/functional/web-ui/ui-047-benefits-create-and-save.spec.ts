// ui-047-benefits-create-and-save: Benefits: Create and save
// Module: HR & Payroll · Table: Benefits · Legacy: legacy/hr-payroll/benefits_browse.w
import { test, expect } from '@playwright/test';

test.describe('HR & Payroll / Benefits', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(process.env.APP_URL ? `${process.env.APP_URL}#/hr-payroll/benefitses` : '#/hr-payroll/benefitses');
  });

  test("Benefits: Create and save", async ({ page }) => {
    await page.getByTestId('new').click();
    await page.getByTestId('field-EmpNum').fill("90003");
    await page.getByTestId('field-HealthCare').fill("Aetna PP");
    await page.getByTestId('field-LifeInsurance').fill("50000");
    await page.getByTestId('field-Pension401K').fill("15");
    await page.getByTestId('field-StockPurchase').fill("25");
    await page.getByTestId('save').click();
    await expect(page.getByTestId('banner')).toHaveText('Benefits saved.');
  });
});
