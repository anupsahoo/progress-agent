import type { PurchaseOrder } from './types';

// Field rules derived from the ABL FORMAT and VALEXP of each PurchaseOrder field.
// Server-side checks in api/app/models/purchase_order.py enforce the same rules.
export function validatePurchaseOrder(v: Partial<PurchaseOrder>): Record<string, string> {
  const e: Record<string, string> = {};
  // PONum: FORMAT "zzzzzzzzz9" · VALEXP "ponum > 0"
  if (v.PONum === undefined || v.PONum === null) e.PONum = "PO Num is required.";
  if (typeof v.PONum === 'number' && v.PONum <= 0) e.PONum = "PO number must be greater than zero";
  if (typeof v.PONum === 'number' && v.PONum > 9999999999) e.PONum = "PO Num must be at most 9999999999.";
  if (typeof v.PONum === 'number' && !Number.isInteger(v.PONum)) e.PONum = "PO Num must be a whole number.";
  // DateEntered: FORMAT "99/99/9999"
  if (v.DateEntered && !/^\d{4}-\d{2}-\d{2}$/.test(String(v.DateEntered))) e.DateEntered = "Date Entered must be a date (YYYY-MM-DD).";
  // SupplierIDNum: FORMAT "zzzzzzzzz9" · VALEXP "CAN-FIND(supplier OF purchaseorder)"
  if (typeof v.SupplierIDNum === 'number' && v.SupplierIDNum < 0) e.SupplierIDNum = "Supplier must exist.";
  if (typeof v.SupplierIDNum === 'number' && v.SupplierIDNum > 9999999999) e.SupplierIDNum = "Supplier ID must be at most 9999999999.";
  if (typeof v.SupplierIDNum === 'number' && !Number.isInteger(v.SupplierIDNum)) e.SupplierIDNum = "Supplier ID must be a whole number.";
  // ReceiveDate: FORMAT "99/99/9999"
  if (v.ReceiveDate && !/^\d{4}-\d{2}-\d{2}$/.test(String(v.ReceiveDate))) e.ReceiveDate = "Date Received must be a date (YYYY-MM-DD).";
  // POStatus: FORMAT "x(20)"
  if (typeof v.POStatus === 'string' && v.POStatus.length > 20) e.POStatus = "PO Status must be at most 20 characters.";
  return e;
}
