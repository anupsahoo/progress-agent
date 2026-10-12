import type { Employee } from './types';

// Field rules derived from the ABL FORMAT and VALEXP of each Employee field.
// Server-side checks in api/app/models/employee.py enforce the same rules.
export function validateEmployee(v: Partial<Employee>): Record<string, string> {
  const e: Record<string, string> = {};
  // EmpNum: FORMAT "zzzzzzzzz9"
  if (v.EmpNum === undefined || v.EmpNum === null) e.EmpNum = "Emp No is required.";
  if (typeof v.EmpNum === 'number' && v.EmpNum < 0) e.EmpNum = "Emp No must be at least 0.";
  if (typeof v.EmpNum === 'number' && v.EmpNum > 9999999999) e.EmpNum = "Emp No must be at most 9999999999.";
  if (typeof v.EmpNum === 'number' && !Number.isInteger(v.EmpNum)) e.EmpNum = "Emp No must be a whole number.";
  // LastName: FORMAT "x(25)"
  if (typeof v.LastName === 'string' && v.LastName.length > 25) e.LastName = "Last Name must be at most 25 characters.";
  // FirstName: FORMAT "x(15)"
  if (typeof v.FirstName === 'string' && v.FirstName.length > 15) e.FirstName = "First Name must be at most 15 characters.";
  // Address: FORMAT "x(35)"
  if (typeof v.Address === 'string' && v.Address.length > 35) e.Address = "Address must be at most 35 characters.";
  // Address2: FORMAT "x(35)"
  if (typeof v.Address2 === 'string' && v.Address2.length > 35) e.Address2 = "Address2 must be at most 35 characters.";
  // City: FORMAT "x(25)"
  if (typeof v.City === 'string' && v.City.length > 25) e.City = "City must be at most 25 characters.";
  // State: FORMAT "x(20)"
  if (typeof v.State === 'string' && v.State.length > 20) e.State = "State must be at most 20 characters.";
  // PostalCode: FORMAT "x(10)"
  if (typeof v.PostalCode === 'string' && v.PostalCode.length > 10) e.PostalCode = "Postal Code must be at most 10 characters.";
  // HomePhone: FORMAT "x(20)"
  if (typeof v.HomePhone === 'string' && v.HomePhone.length > 20) e.HomePhone = "Home Phone must be at most 20 characters.";
  // WorkPhone: FORMAT "x(20)"
  if (typeof v.WorkPhone === 'string' && v.WorkPhone.length > 20) e.WorkPhone = "Work Phone must be at most 20 characters.";
  // DeptCode: FORMAT "x(3)" · VALEXP "CAN-FIND(department of employee)"
  if (typeof v.DeptCode === 'string' && v.DeptCode.length > 3) e.DeptCode = "Dept Code must be at most 3 characters.";
  // Position: FORMAT "x(20)"
  if (typeof v.Position === 'string' && v.Position.length > 20) e.Position = "Position must be at most 20 characters.";
  // Birthdate: FORMAT "99/99/9999"
  if (v.Birthdate && !/^\d{4}-\d{2}-\d{2}$/.test(String(v.Birthdate))) e.Birthdate = "Birthdate must be a date (YYYY-MM-DD).";
  // StartDate: FORMAT "99/99/9999"
  if (v.StartDate && !/^\d{4}-\d{2}-\d{2}$/.test(String(v.StartDate))) e.StartDate = "Start Date must be a date (YYYY-MM-DD).";
  // VacationDaysLeft: FORMAT ">>9"
  if (typeof v.VacationDaysLeft === 'number' && v.VacationDaysLeft < 0) e.VacationDaysLeft = "Vacation Days Left must be at least 0.";
  if (typeof v.VacationDaysLeft === 'number' && v.VacationDaysLeft > 999) e.VacationDaysLeft = "Vacation Days Left must be at most 999.";
  if (typeof v.VacationDaysLeft === 'number' && !Number.isInteger(v.VacationDaysLeft)) e.VacationDaysLeft = "Vacation Days Left must be a whole number.";
  // SickDaysLeft: FORMAT ">>9"
  if (typeof v.SickDaysLeft === 'number' && v.SickDaysLeft < 0) e.SickDaysLeft = "Sick Days Left must be at least 0.";
  if (typeof v.SickDaysLeft === 'number' && v.SickDaysLeft > 999) e.SickDaysLeft = "Sick Days Left must be at most 999.";
  if (typeof v.SickDaysLeft === 'number' && !Number.isInteger(v.SickDaysLeft)) e.SickDaysLeft = "Sick Days Left must be a whole number.";
  return e;
}
