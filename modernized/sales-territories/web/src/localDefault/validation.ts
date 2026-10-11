import type { LocalDefault } from './types';

// Field rules derived from the ABL FORMAT and VALEXP of each LocalDefault field.
// Server-side checks in api/app/models/local_default.py enforce the same rules.
export function validateLocalDefault(v: Partial<LocalDefault>): Record<string, string> {
  const e: Record<string, string> = {};
  // Country: FORMAT "x(20)"
  if (typeof v.Country === 'string' && v.Country.length > 20) e.Country = "Country must be at most 20 characters.";
  // Region1Label: FORMAT "x(15)"
  if (typeof v.Region1Label === 'string' && v.Region1Label.length > 15) e.Region1Label = "Region1 Label must be at most 15 characters.";
  // Region2Label: FORMAT "x(15)"
  if (typeof v.Region2Label === 'string' && v.Region2Label.length > 15) e.Region2Label = "Region2 Label must be at most 15 characters.";
  // PostalLabel: FORMAT "x(15)"
  if (typeof v.PostalLabel === 'string' && v.PostalLabel.length > 15) e.PostalLabel = "Postal Label must be at most 15 characters.";
  // PostalFormat: FORMAT "x(15)"
  if (typeof v.PostalFormat === 'string' && v.PostalFormat.length > 15) e.PostalFormat = "Postal Format must be at most 15 characters.";
  // TelFormat: FORMAT "x(15)"
  if (typeof v.TelFormat === 'string' && v.TelFormat.length > 15) e.TelFormat = "Tel Format must be at most 15 characters.";
  // CurrencySymbol: FORMAT "x(6)"
  if (typeof v.CurrencySymbol === 'string' && v.CurrencySymbol.length > 6) e.CurrencySymbol = "Currency Symbol must be at most 6 characters.";
  // DateFormat: FORMAT "x(8)"
  if (typeof v.DateFormat === 'string' && v.DateFormat.length > 8) e.DateFormat = "Date Format must be at most 8 characters.";
  // LocalDefNum: FORMAT "zzzzzzzzz9"
  if (v.LocalDefNum === undefined || v.LocalDefNum === null) e.LocalDefNum = "Local Default Num is required.";
  if (typeof v.LocalDefNum === 'number' && v.LocalDefNum < 0) e.LocalDefNum = "Local Default Num must be at least 0.";
  if (typeof v.LocalDefNum === 'number' && v.LocalDefNum > 9999999999) e.LocalDefNum = "Local Default Num must be at most 9999999999.";
  if (typeof v.LocalDefNum === 'number' && !Number.isInteger(v.LocalDefNum)) e.LocalDefNum = "Local Default Num must be a whole number.";
  return e;
}
