import type { TimeSheet } from './types';

// Field rules derived from the ABL FORMAT and VALEXP of each TimeSheet field.
// Server-side checks in api/app/models/time_sheet.py enforce the same rules.
export function validateTimeSheet(v: Partial<TimeSheet>): Record<string, string> {
  const e: Record<string, string> = {};
  // EmpNum: FORMAT "zzzzzzzzz9" · VALEXP "CAN-FIND(employee OF timesheet)"
  if (v.EmpNum === undefined || v.EmpNum === null) e.EmpNum = "Emp No is required.";
  if (typeof v.EmpNum === 'number' && v.EmpNum < 0) e.EmpNum = "Employee must exist.";
  if (typeof v.EmpNum === 'number' && v.EmpNum > 9999999999) e.EmpNum = "Emp No must be at most 9999999999.";
  if (typeof v.EmpNum === 'number' && !Number.isInteger(v.EmpNum)) e.EmpNum = "Emp No must be a whole number.";
  // DayRecorded: FORMAT "99/99/9999"
  if (v.DayRecorded === undefined || v.DayRecorded === null || v.DayRecorded.trim() === '') e.DayRecorded = "Day Recorded is required.";
  if (v.DayRecorded && !/^\d{4}-\d{2}-\d{2}$/.test(String(v.DayRecorded))) e.DayRecorded = "Day Recorded must be a date (YYYY-MM-DD).";
  // TypeRecorded: FORMAT "x(8)"
  if (typeof v.TypeRecorded === 'string' && v.TypeRecorded.length > 8) e.TypeRecorded = "Type Recorded must be at most 8 characters.";
  // AMTimeIn: FORMAT "xx:xx"
  if (typeof v.AMTimeIn === 'string' && v.AMTimeIn.length > 5) e.AMTimeIn = "AM Time In must be at most 5 characters.";
  // AMTimeOut: FORMAT "xx:xx"
  if (typeof v.AMTimeOut === 'string' && v.AMTimeOut.length > 5) e.AMTimeOut = "AM Time Out must be at most 5 characters.";
  // PMTimeIn: FORMAT "xx:xx"
  if (typeof v.PMTimeIn === 'string' && v.PMTimeIn.length > 5) e.PMTimeIn = "PM Time In must be at most 5 characters.";
  // PMTimeOut: FORMAT "xx:xx"
  if (typeof v.PMTimeOut === 'string' && v.PMTimeOut.length > 5) e.PMTimeOut = "PM Time Out must be at most 5 characters.";
  // RegularHours: FORMAT ">>9.<<"
  if (typeof v.RegularHours === 'number' && v.RegularHours < 0) e.RegularHours = "Regular Hours must be at least 0.";
  if (typeof v.RegularHours === 'number' && v.RegularHours > 999.99) e.RegularHours = "Regular Hours must be at most 999.99.";
  if (typeof v.RegularHours === 'number' && Math.round(v.RegularHours * 100) !== v.RegularHours * 100) e.RegularHours = "Regular Hours allows 2 decimal places.";
  // OvertimeHours: FORMAT ">>9.<<"
  if (typeof v.OvertimeHours === 'number' && v.OvertimeHours < 0) e.OvertimeHours = "Overtime Hours must be at least 0.";
  if (typeof v.OvertimeHours === 'number' && v.OvertimeHours > 999.99) e.OvertimeHours = "Overtime Hours must be at most 999.99.";
  if (typeof v.OvertimeHours === 'number' && Math.round(v.OvertimeHours * 100) !== v.OvertimeHours * 100) e.OvertimeHours = "Overtime Hours allows 2 decimal places.";
  return e;
}
