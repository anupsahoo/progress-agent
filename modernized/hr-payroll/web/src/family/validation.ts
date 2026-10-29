import type { Family } from './types';

// Field rules derived from the ABL FORMAT and VALEXP of each Family field.
// Server-side checks in api/app/models/family.py enforce the same rules.
export function validateFamily(v: Partial<Family>): Record<string, string> {
  const e: Record<string, string> = {};
  // EmpNum: FORMAT "zzzzzzzzz9" · VALEXP "CAN-FIND(employee OF family)"
  if (v.EmpNum === undefined || v.EmpNum === null) e.EmpNum = "Emp No is required.";
  if (typeof v.EmpNum === 'number' && v.EmpNum < 0) e.EmpNum = "Employee must exist.";
  if (typeof v.EmpNum === 'number' && v.EmpNum > 9999999999) e.EmpNum = "Emp No must be at most 9999999999.";
  if (typeof v.EmpNum === 'number' && !Number.isInteger(v.EmpNum)) e.EmpNum = "Emp No must be a whole number.";
  // RelativeName: FORMAT "x(15)"
  if (v.RelativeName === undefined || v.RelativeName === null || v.RelativeName.trim() === '') e.RelativeName = "Relative Name is required.";
  if (typeof v.RelativeName === 'string' && v.RelativeName.length > 15) e.RelativeName = "Relative Name must be at most 15 characters.";
  // Relation: FORMAT "x(15)"
  if (typeof v.Relation === 'string' && v.Relation.length > 15) e.Relation = "Relation must be at most 15 characters.";
  // Birthdate: FORMAT "99/99/9999"
  if (v.Birthdate && !/^\d{4}-\d{2}-\d{2}$/.test(String(v.Birthdate))) e.Birthdate = "Birthdate must be a date (YYYY-MM-DD).";
  // BenefitDate: FORMAT "99/99/9999"
  if (v.BenefitDate && !/^\d{4}-\d{2}-\d{2}$/.test(String(v.BenefitDate))) e.BenefitDate = "Benefit Date must be a date (YYYY-MM-DD).";
  return e;
}
