import type { Department } from './types';

// Field rules derived from the ABL FORMAT and VALEXP of each Department field.
// Server-side checks in api/app/models/department.py enforce the same rules.
export function validateDepartment(v: Partial<Department>): Record<string, string> {
  const e: Record<string, string> = {};
  // DeptCode: FORMAT "x(3)"
  if (v.DeptCode === undefined || v.DeptCode === null || v.DeptCode.trim() === '') e.DeptCode = "Dept Code is required.";
  if (typeof v.DeptCode === 'string' && v.DeptCode.length > 3) e.DeptCode = "Dept Code must be at most 3 characters.";
  // DeptName: FORMAT "x(15)"
  if (typeof v.DeptName === 'string' && v.DeptName.length > 15) e.DeptName = "Dept Name must be at most 15 characters.";
  return e;
}
