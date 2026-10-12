import type { Vacation } from './types';

// Field rules derived from the ABL FORMAT and VALEXP of each Vacation field.
// Server-side checks in api/app/models/vacation.py enforce the same rules.
export function validateVacation(v: Partial<Vacation>): Record<string, string> {
  const e: Record<string, string> = {};
  // EmpNum: FORMAT "zzzzzzzzz9" · VALEXP "CAN-FIND(employee WHERE employee.empnum = vacation.empnum)"
  if (v.EmpNum === undefined || v.EmpNum === null) e.EmpNum = "Emp No is required.";
  if (typeof v.EmpNum === 'number' && v.EmpNum < 0) e.EmpNum = "Employee must exist";
  if (typeof v.EmpNum === 'number' && v.EmpNum > 9999999999) e.EmpNum = "Emp No must be at most 9999999999.";
  if (typeof v.EmpNum === 'number' && !Number.isInteger(v.EmpNum)) e.EmpNum = "Emp No must be a whole number.";
  // StartDate: FORMAT "99/99/9999"
  if (v.StartDate === undefined || v.StartDate === null || v.StartDate.trim() === '') e.StartDate = "Start Date is required.";
  if (v.StartDate && !/^\d{4}-\d{2}-\d{2}$/.test(String(v.StartDate))) e.StartDate = "Start Date must be a date (YYYY-MM-DD).";
  // EndDate: FORMAT "99/99/9999"
  if (v.EndDate && !/^\d{4}-\d{2}-\d{2}$/.test(String(v.EndDate))) e.EndDate = "End Date must be a date (YYYY-MM-DD).";
  return e;
}
