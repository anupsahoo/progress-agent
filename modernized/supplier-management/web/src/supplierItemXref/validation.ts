import type { SupplierItemXref } from './types';

// Field rules derived from the ABL FORMAT and VALEXP of each SupplierItemXref field.
// Server-side checks in api/app/models/supplier_item_xref.py enforce the same rules.
export function validateSupplierItemXref(v: Partial<SupplierItemXref>): Record<string, string> {
  const e: Record<string, string> = {};
  // SupplierIDNum: FORMAT "zzzzzzzzz9" · VALEXP "CAN-FIND(supplier OF supplieritemxref)"
  if (v.SupplierIDNum === undefined || v.SupplierIDNum === null) e.SupplierIDNum = "Supplier ID is required.";
  if (typeof v.SupplierIDNum === 'number' && v.SupplierIDNum < 0) e.SupplierIDNum = "Supplier must exist.";
  if (typeof v.SupplierIDNum === 'number' && v.SupplierIDNum > 9999999999) e.SupplierIDNum = "Supplier ID must be at most 9999999999.";
  if (typeof v.SupplierIDNum === 'number' && !Number.isInteger(v.SupplierIDNum)) e.SupplierIDNum = "Supplier ID must be a whole number.";
  // Itemnum: FORMAT "zzzzzzzzz9" · VALEXP "CAN-FIND(item OF supplieritemxref)"
  if (v.Itemnum === undefined || v.Itemnum === null) e.Itemnum = "Item # is required.";
  if (typeof v.Itemnum === 'number' && v.Itemnum < 0) e.Itemnum = "Item must be on file.";
  if (typeof v.Itemnum === 'number' && v.Itemnum > 9999999999) e.Itemnum = "Item # must be at most 9999999999.";
  if (typeof v.Itemnum === 'number' && !Number.isInteger(v.Itemnum)) e.Itemnum = "Item # must be a whole number.";
  return e;
}
