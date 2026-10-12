import type { OrderLine } from './types';

// Field rules derived from the ABL FORMAT and VALEXP of each OrderLine field.
// Server-side checks in api/app/models/order_line.py enforce the same rules.
export function validateOrderLine(v: Partial<OrderLine>): Record<string, string> {
  const e: Record<string, string> = {};
  // Ordernum: FORMAT "zzzzzzzzz9" · VALEXP "CAN-FIND(order OF orderline)"
  if (v.Ordernum === undefined || v.Ordernum === null) e.Ordernum = "Order Num is required.";
  if (typeof v.Ordernum === 'number' && v.Ordernum < 0) e.Ordernum = "Order must exist";
  if (typeof v.Ordernum === 'number' && v.Ordernum > 9999999999) e.Ordernum = "Order Num must be at most 9999999999.";
  if (typeof v.Ordernum === 'number' && !Number.isInteger(v.Ordernum)) e.Ordernum = "Order Num must be a whole number.";
  // Linenum: FORMAT ">>9"
  if (v.Linenum === undefined || v.Linenum === null) e.Linenum = "Line Num is required.";
  if (typeof v.Linenum === 'number' && v.Linenum < 0) e.Linenum = "Line Num must be at least 0.";
  if (typeof v.Linenum === 'number' && v.Linenum > 999) e.Linenum = "Line Num must be at most 999.";
  if (typeof v.Linenum === 'number' && !Number.isInteger(v.Linenum)) e.Linenum = "Line Num must be a whole number.";
  // Itemnum: FORMAT "zzzzzzzzz9" · VALEXP "CAN-FIND(item OF orderline)"
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
  // ExtendedPrice: FORMAT "->>>,>>9.99"
  if (typeof v.ExtendedPrice === 'number' && v.ExtendedPrice < -999999.99) e.ExtendedPrice = "Extended Price must be at least -999999.99.";
  if (typeof v.ExtendedPrice === 'number' && v.ExtendedPrice > 999999.99) e.ExtendedPrice = "Extended Price must be at most 999999.99.";
  if (typeof v.ExtendedPrice === 'number' && Math.round(v.ExtendedPrice * 100) !== v.ExtendedPrice * 100) e.ExtendedPrice = "Extended Price allows 2 decimal places.";
  // OrderLineStatus: FORMAT "x(20)"
  if (typeof v.OrderLineStatus === 'string' && v.OrderLineStatus.length > 20) e.OrderLineStatus = "Order Line Status must be at most 20 characters.";
  return e;
}
