import type { Salesrep } from './types';

// Field rules derived from the ABL FORMAT and VALEXP of each Salesrep field.
// Server-side checks in api/app/models/salesrep.py enforce the same rules.
export function validateSalesrep(v: Partial<Salesrep>): Record<string, string> {
  const e: Record<string, string> = {};
  // SalesRep: FORMAT "x(4)"
  if (v.SalesRep === undefined || v.SalesRep === null || v.SalesRep.trim() === '') e.SalesRep = "Sales Rep is required.";
  if (typeof v.SalesRep === 'string' && v.SalesRep.length > 4) e.SalesRep = "Sales Rep must be at most 4 characters.";
  // RepName: FORMAT "x(30)"
  if (typeof v.RepName === 'string' && v.RepName.length > 30) e.RepName = "Rep Name must be at most 30 characters.";
  // Region: FORMAT "x(8)"
  if (typeof v.Region === 'string' && v.Region.length > 8) e.Region = "Region must be at most 8 characters.";
  return e;
}
