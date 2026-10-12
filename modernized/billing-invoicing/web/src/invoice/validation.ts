import type { Invoice } from './types';

// Field rules derived from the ABL FORMAT and VALEXP of each Invoice field.
// Server-side checks in api/app/models/invoice.py enforce the same rules.
export function validateInvoice(v: Partial<Invoice>): Record<string, string> {
  const e: Record<string, string> = {};
  // Invoicenum: FORMAT "zzzzzzzzz9" · VALEXP "invoicenum > 0"
  if (v.Invoicenum === undefined || v.Invoicenum === null) e.Invoicenum = "Invoice Num is required.";
  if (typeof v.Invoicenum === 'number' && v.Invoicenum <= 0) e.Invoicenum = "Invoice number cannot be zero";
  if (typeof v.Invoicenum === 'number' && v.Invoicenum > 9999999999) e.Invoicenum = "Invoice Num must be at most 9999999999.";
  if (typeof v.Invoicenum === 'number' && !Number.isInteger(v.Invoicenum)) e.Invoicenum = "Invoice Num must be a whole number.";
  // CustNum: FORMAT ">>>>9" · VALEXP "CAN-FIND(customer OF invoice)"
  if (typeof v.CustNum === 'number' && v.CustNum < 0) e.CustNum = "The Customer number entered must be a valid one.";
  if (typeof v.CustNum === 'number' && v.CustNum > 99999) e.CustNum = "Cust Num must be at most 99999.";
  if (typeof v.CustNum === 'number' && !Number.isInteger(v.CustNum)) e.CustNum = "Cust Num must be a whole number.";
  // InvoiceDate: FORMAT "99/99/9999"
  if (v.InvoiceDate && !/^\d{4}-\d{2}-\d{2}$/.test(String(v.InvoiceDate))) e.InvoiceDate = "Invoice Date must be a date (YYYY-MM-DD).";
  // Amount: FORMAT "->>,>>9.99"
  if (typeof v.Amount === 'number' && v.Amount < -99999.99) e.Amount = "Amount must be at least -99999.99.";
  if (typeof v.Amount === 'number' && v.Amount > 99999.99) e.Amount = "Amount must be at most 99999.99.";
  if (typeof v.Amount === 'number' && Math.round(v.Amount * 100) !== v.Amount * 100) e.Amount = "Amount allows 2 decimal places.";
  // TotalPaid: FORMAT "->>,>>9.99"
  if (typeof v.TotalPaid === 'number' && v.TotalPaid < -99999.99) e.TotalPaid = "Total Paid must be at least -99999.99.";
  if (typeof v.TotalPaid === 'number' && v.TotalPaid > 99999.99) e.TotalPaid = "Total Paid must be at most 99999.99.";
  if (typeof v.TotalPaid === 'number' && Math.round(v.TotalPaid * 100) !== v.TotalPaid * 100) e.TotalPaid = "Total Paid allows 2 decimal places.";
  // Adjustment: FORMAT "->>,>>9.99"
  if (typeof v.Adjustment === 'number' && v.Adjustment < -99999.99) e.Adjustment = "Adjustment must be at least -99999.99.";
  if (typeof v.Adjustment === 'number' && v.Adjustment > 99999.99) e.Adjustment = "Adjustment must be at most 99999.99.";
  if (typeof v.Adjustment === 'number' && Math.round(v.Adjustment * 100) !== v.Adjustment * 100) e.Adjustment = "Adjustment allows 2 decimal places.";
  // OrderNum: FORMAT "zzzzzzzzz9"
  if (typeof v.OrderNum === 'number' && v.OrderNum < 0) e.OrderNum = "The Order number entered must be a valid one.";
  if (typeof v.OrderNum === 'number' && v.OrderNum > 9999999999) e.OrderNum = "Order Num must be at most 9999999999.";
  if (typeof v.OrderNum === 'number' && !Number.isInteger(v.OrderNum)) e.OrderNum = "Order Num must be a whole number.";
  // ShipCharge: FORMAT "->>,>>9.99"
  if (typeof v.ShipCharge === 'number' && v.ShipCharge < -99999.99) e.ShipCharge = "Ship Charge must be at least -99999.99.";
  if (typeof v.ShipCharge === 'number' && v.ShipCharge > 99999.99) e.ShipCharge = "Ship Charge must be at most 99999.99.";
  if (typeof v.ShipCharge === 'number' && Math.round(v.ShipCharge * 100) !== v.ShipCharge * 100) e.ShipCharge = "Ship Charge allows 2 decimal places.";
  return e;
}
