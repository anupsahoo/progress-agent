import type { Benefits } from './types';

// Field rules derived from the ABL FORMAT and VALEXP of each Benefits field.
// Server-side checks in api/app/models/benefits.py enforce the same rules.
export function validateBenefits(v: Partial<Benefits>): Record<string, string> {
  const e: Record<string, string> = {};
  // EmpNum: FORMAT "zzzzzzzzz9" · VALEXP "CAN-FIND(employee OF benefits)"
  if (v.EmpNum === undefined || v.EmpNum === null) e.EmpNum = "Emp No is required.";
  if (typeof v.EmpNum === 'number' && v.EmpNum < 0) e.EmpNum = "Employee must exist.";
  if (typeof v.EmpNum === 'number' && v.EmpNum > 9999999999) e.EmpNum = "Emp No must be at most 9999999999.";
  if (typeof v.EmpNum === 'number' && !Number.isInteger(v.EmpNum)) e.EmpNum = "Emp No must be a whole number.";
  // HealthCare: FORMAT "x(8)"
  if (typeof v.HealthCare === 'string' && v.HealthCare.length > 8) e.HealthCare = "Health Care must be at most 8 characters.";
  // LifeInsurance: FORMAT "$>>,>>>,>>>"
  if (typeof v.LifeInsurance === 'number' && v.LifeInsurance < 0) e.LifeInsurance = "Life Insurance must be at least 0.";
  if (typeof v.LifeInsurance === 'number' && v.LifeInsurance > 99999999) e.LifeInsurance = "Life Insurance must be at most 99999999.";
  if (typeof v.LifeInsurance === 'number' && !Number.isInteger(v.LifeInsurance)) e.LifeInsurance = "Life Insurance must be a whole number.";
  // Pension401K: FORMAT ">>,>>9"
  if (typeof v.Pension401K === 'number' && v.Pension401K < 0) e.Pension401K = "Pension401K must be at least 0.";
  if (typeof v.Pension401K === 'number' && v.Pension401K > 99999) e.Pension401K = "Pension401K must be at most 99999.";
  if (typeof v.Pension401K === 'number' && !Number.isInteger(v.Pension401K)) e.Pension401K = "Pension401K must be a whole number.";
  // StockPurchase: FORMAT ">>,>>9"
  if (typeof v.StockPurchase === 'number' && v.StockPurchase < 0) e.StockPurchase = "Stock Purchase must be at least 0.";
  if (typeof v.StockPurchase === 'number' && v.StockPurchase > 99999) e.StockPurchase = "Stock Purchase must be at most 99999.";
  if (typeof v.StockPurchase === 'number' && !Number.isInteger(v.StockPurchase)) e.StockPurchase = "Stock Purchase must be a whole number.";
  // MedicalSpending: FORMAT ">>,>>9"
  if (typeof v.MedicalSpending === 'number' && v.MedicalSpending < 0) e.MedicalSpending = "Medical Spending must be at least 0.";
  if (typeof v.MedicalSpending === 'number' && v.MedicalSpending > 99999) e.MedicalSpending = "Medical Spending must be at most 99999.";
  if (typeof v.MedicalSpending === 'number' && !Number.isInteger(v.MedicalSpending)) e.MedicalSpending = "Medical Spending must be a whole number.";
  // DependentCare: FORMAT ">>,>>9"
  if (typeof v.DependentCare === 'number' && v.DependentCare < 0) e.DependentCare = "Dependent Care must be at least 0.";
  if (typeof v.DependentCare === 'number' && v.DependentCare > 99999) e.DependentCare = "Dependent Care must be at most 99999.";
  if (typeof v.DependentCare === 'number' && !Number.isInteger(v.DependentCare)) e.DependentCare = "Dependent Care must be a whole number.";
  return e;
}
