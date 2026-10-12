import type { POLine } from './types';

// Field rules derived from the ABL FORMAT and VALEXP of each POLine field.
// Server-side checks in api/app/models/po_line.py enforce the same rules.
export function validatePOLine(v: Partial<POLine>): Record<string, string> {
  const e: Record<string, string> = {};
  // Linenum: FORMAT ">>9"
  if (v.Linenum === undefined || v.Linenum === null) e.Linenum = "Line Num is required.";
  if (typeof v.Linenum === 'number' && v.Linenum < 0) e.Linenum = "Line Num must be at least 0.";
  if (typeof v.Linenum === 'number' && v.Linenum > 999) e.Linenum = "Line Num must be at most 999.";
  if (typeof v.Linenum === 'number' && !Number.isInteger(v.Linenum)) e.Linenum = "Line Num must be a whole number.";
  // Itemnum: FORMAT "zzzzzzzzz9" · VALEXP "CAN-FIND(item OF poline)"
  if (typeof v.Itemnum === 'number' && v.Itemnum < 0) e.Itemnum = "Item must be on file";
  if (typeof v.Itemnum === 'number' && v.Itemnum > 9999999999) e.Itemnum = "Item Num must be at most 9999999999.";
  if (typeof v.Itemnum === 'number' && !Number.isInteger(v.Itemnum)) e.Itemnum = "Item Num must be a whole number.";
  // Price: FORMAT "->,>>>,>>9.99"
  if (typeof v.Price === 'number' && v.Price < -9999999.99) e.Price = "Price must be at least -9999999.99.";
  if (typeof v.Price === 'number' && v.Price > 9999999.99) e.Price = "Price must be at most 9999999.99.";
  if (typeof v.Price === 'number' && Math.round(v.Price * 100) !== v.Price * 100) e.Price = "Price allows 2 decimal places.";
  // Qty: FORMAT "->>>>9"
  if (typeof v.Qty === 'number' && v.Qty < -99999) e.Qty = "Qty must be at least -99999.";
  if (typeof v.Qty === 'number' && v.Qty > 99999) e.Qty = "Qty must be at most 99999.";
  if (typeof v.Qty === 'number' && !Number.isInteger(v.Qty)) e.Qty = "Qty must be a whole number.";
  // Discount: FORMAT ">>9%"
  if (typeof v.Discount === 'number' && v.Discount < 0) e.Discount = "Discount must be at least 0.";
  if (typeof v.Discount === 'number' && v.Discount > 999) e.Discount = "Discount must be at most 999.";
  if (typeof v.Discount === 'number' && !Number.isInteger(v.Discount)) e.Discount = "Discount must be a whole number.";
  // ExtendedPrice: FORMAT "->>,>>9.99"
  if (typeof v.ExtendedPrice === 'number' && v.ExtendedPrice < -99999.99) e.ExtendedPrice = "Extended Price must be at least -99999.99.";
  if (typeof v.ExtendedPrice === 'number' && v.ExtendedPrice > 99999.99) e.ExtendedPrice = "Extended Price must be at most 99999.99.";
  if (typeof v.ExtendedPrice === 'number' && Math.round(v.ExtendedPrice * 100) !== v.ExtendedPrice * 100) e.ExtendedPrice = "Extended Price allows 2 decimal places.";
  // PONum: FORMAT "zzzzzzzzz9" · VALEXP "can-find(purchaseorder of poline)"
  if (v.PONum === undefined || v.PONum === null) e.PONum = "Order Num is required.";
  if (typeof v.PONum === 'number' && v.PONum < 0) e.PONum = "Purchase order must exist.";
  if (typeof v.PONum === 'number' && v.PONum > 9999999999) e.PONum = "Order Num must be at most 9999999999.";
  if (typeof v.PONum === 'number' && !Number.isInteger(v.PONum)) e.PONum = "Order Num must be a whole number.";
  // POLineStatus: FORMAT "x(20)"
  if (typeof v.POLineStatus === 'string' && v.POLineStatus.length > 20) e.POLineStatus = "PO Line Status must be at most 20 characters.";
  return e;
}
