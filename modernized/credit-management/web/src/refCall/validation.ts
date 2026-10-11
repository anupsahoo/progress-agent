import type { RefCall } from './types';

// Field rules derived from the ABL FORMAT and VALEXP of each RefCall field.
// Server-side checks in api/app/models/ref_call.py enforce the same rules.
export function validateRefCall(v: Partial<RefCall>): Record<string, string> {
  const e: Record<string, string> = {};
  // CallNum: FORMAT "x(6)"
  if (v.CallNum === undefined || v.CallNum === null || v.CallNum.trim() === '') e.CallNum = "Call Num is required.";
  if (typeof v.CallNum === 'string' && v.CallNum.length > 6) e.CallNum = "Call Num must be at most 6 characters.";
  // CustNum: FORMAT ">>>>9" · VALEXP "custnum > 0"
  if (typeof v.CustNum === 'number' && v.CustNum <= 0) e.CustNum = "Customer number must be greater than zero";
  if (typeof v.CustNum === 'number' && v.CustNum > 99999) e.CustNum = "Cust Num must be at most 99999.";
  if (typeof v.CustNum === 'number' && !Number.isInteger(v.CustNum)) e.CustNum = "Cust Num must be a whole number.";
  // CallDate: FORMAT "99/99/9999"
  if (v.CallDate && !/^\d{4}-\d{2}-\d{2}$/.test(String(v.CallDate))) e.CallDate = "Call Date must be a date (YYYY-MM-DD).";
  // SalesRep: FORMAT "x(4)"
  if (typeof v.SalesRep === 'string' && v.SalesRep.length > 4) e.SalesRep = "Sales Rep must be at most 4 characters.";
  // Parent: FORMAT "x(6)"
  if (typeof v.Parent === 'string' && v.Parent.length > 6) e.Parent = "Parent must be at most 6 characters.";
  // Txt: FORMAT "x(300)"
  if (typeof v.Txt === 'string' && v.Txt.length > 300) e.Txt = "Txt must be at most 300 characters.";
  return e;
}
