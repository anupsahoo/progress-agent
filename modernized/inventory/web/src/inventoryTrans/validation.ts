import type { InventoryTrans } from './types';

// Field rules derived from the ABL FORMAT and VALEXP of each InventoryTrans field.
// Server-side checks in api/app/models/inventory_trans.py enforce the same rules.
export function validateInventoryTrans(v: Partial<InventoryTrans>): Record<string, string> {
  const e: Record<string, string> = {};
  // InvTransNum: FORMAT "zzzzzzzzz9"
  if (v.InvTransNum === undefined || v.InvTransNum === null) e.InvTransNum = "Inventory Trans Num is required.";
  if (typeof v.InvTransNum === 'number' && v.InvTransNum < 0) e.InvTransNum = "Inventory Trans Num must be at least 0.";
  if (typeof v.InvTransNum === 'number' && v.InvTransNum > 9999999999) e.InvTransNum = "Inventory Trans Num must be at most 9999999999.";
  if (typeof v.InvTransNum === 'number' && !Number.isInteger(v.InvTransNum)) e.InvTransNum = "Inventory Trans Num must be a whole number.";
  // WarehouseNum: FORMAT "zzzzzzzzz9"
  if (typeof v.WarehouseNum === 'number' && v.WarehouseNum < 0) e.WarehouseNum = "Warehouse Num must be at least 0.";
  if (typeof v.WarehouseNum === 'number' && v.WarehouseNum > 9999999999) e.WarehouseNum = "Warehouse Num must be at most 9999999999.";
  if (typeof v.WarehouseNum === 'number' && !Number.isInteger(v.WarehouseNum)) e.WarehouseNum = "Warehouse Num must be a whole number.";
  // BinNum: FORMAT "zzzzzzzzz9"
  if (typeof v.BinNum === 'number' && v.BinNum < 0) e.BinNum = "Bin Num must be at least 0.";
  if (typeof v.BinNum === 'number' && v.BinNum > 9999999999) e.BinNum = "Bin Num must be at most 9999999999.";
  if (typeof v.BinNum === 'number' && !Number.isInteger(v.BinNum)) e.BinNum = "Bin Num must be a whole number.";
  // Qty: FORMAT "->>>>9"
  if (typeof v.Qty === 'number' && v.Qty < -99999) e.Qty = "Qty must be at least -99999.";
  if (typeof v.Qty === 'number' && v.Qty > 99999) e.Qty = "Qty must be at most 99999.";
  if (typeof v.Qty === 'number' && !Number.isInteger(v.Qty)) e.Qty = "Qty must be a whole number.";
  // Itemnum: FORMAT "zzzzzzzzz9" · VALEXP "CAN-FIND(item OF inventorytrans)"
  if (typeof v.Itemnum === 'number' && v.Itemnum < 0) e.Itemnum = "Item must be on file.";
  if (typeof v.Itemnum === 'number' && v.Itemnum > 9999999999) e.Itemnum = "Item Num must be at most 9999999999.";
  if (typeof v.Itemnum === 'number' && !Number.isInteger(v.Itemnum)) e.Itemnum = "Item Num must be a whole number.";
  // TransDate: FORMAT "99/99/9999"
  if (v.TransDate && !/^\d{4}-\d{2}-\d{2}$/.test(String(v.TransDate))) e.TransDate = "Trans Date must be a date (YYYY-MM-DD).";
  // InvType: FORMAT "X(12)"
  if (typeof v.InvType === 'string' && v.InvType.length > 12) e.InvType = "Type must be at most 12 characters.";
  // PONum: FORMAT "zzzzzzzzz9"
  if (typeof v.PONum === 'number' && v.PONum < 0) e.PONum = "PO Num must be at least 0.";
  if (typeof v.PONum === 'number' && v.PONum > 9999999999) e.PONum = "PO Num must be at most 9999999999.";
  if (typeof v.PONum === 'number' && !Number.isInteger(v.PONum)) e.PONum = "PO Num must be a whole number.";
  // Ordernum: FORMAT "zzzzzzzzz9"
  if (typeof v.Ordernum === 'number' && v.Ordernum < 0) e.Ordernum = "Order Num must be at least 0.";
  if (typeof v.Ordernum === 'number' && v.Ordernum > 9999999999) e.Ordernum = "Order Num must be at most 9999999999.";
  if (typeof v.Ordernum === 'number' && !Number.isInteger(v.Ordernum)) e.Ordernum = "Order Num must be a whole number.";
  // Transtime: FORMAT "X(5)"
  if (typeof v.Transtime === 'string' && v.Transtime.length > 5) e.Transtime = "Trans Time must be at most 5 characters.";
  return e;
}
