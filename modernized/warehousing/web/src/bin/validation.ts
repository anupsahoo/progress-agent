import type { Bin } from './types';

// Field rules derived from the ABL FORMAT and VALEXP of each Bin field.
// Server-side checks in api/app/models/bin.py enforce the same rules.
export function validateBin(v: Partial<Bin>): Record<string, string> {
  const e: Record<string, string> = {};
  // WarehouseNum: FORMAT "zzzzzzzzz9" · VALEXP "CAN-FIND(warehouse OF bin)"
  if (typeof v.WarehouseNum === 'number' && v.WarehouseNum < 0) e.WarehouseNum = "Warehouse must exist.";
  if (typeof v.WarehouseNum === 'number' && v.WarehouseNum > 9999999999) e.WarehouseNum = "Warehouse Num must be at most 9999999999.";
  if (typeof v.WarehouseNum === 'number' && !Number.isInteger(v.WarehouseNum)) e.WarehouseNum = "Warehouse Num must be a whole number.";
  // Itemnum: FORMAT "zzzzzzzzz9" · VALEXP "CAN-FIND(item OF bin)"
  if (typeof v.Itemnum === 'number' && v.Itemnum < 0) e.Itemnum = "Item must be on file";
  if (typeof v.Itemnum === 'number' && v.Itemnum > 9999999999) e.Itemnum = "Item Num must be at most 9999999999.";
  if (typeof v.Itemnum === 'number' && !Number.isInteger(v.Itemnum)) e.Itemnum = "Item Num must be a whole number.";
  // Qty: FORMAT "->>>>9"
  if (typeof v.Qty === 'number' && v.Qty < -99999) e.Qty = "Qty must be at least -99999.";
  if (typeof v.Qty === 'number' && v.Qty > 99999) e.Qty = "Qty must be at most 99999.";
  if (typeof v.Qty === 'number' && !Number.isInteger(v.Qty)) e.Qty = "Qty must be a whole number.";
  // BinNum: FORMAT "zzzzzzzzz9"
  if (v.BinNum === undefined || v.BinNum === null) e.BinNum = "Bin Num is required.";
  if (typeof v.BinNum === 'number' && v.BinNum < 0) e.BinNum = "Bin Num must be at least 0.";
  if (typeof v.BinNum === 'number' && v.BinNum > 9999999999) e.BinNum = "Bin Num must be at most 9999999999.";
  if (typeof v.BinNum === 'number' && !Number.isInteger(v.BinNum)) e.BinNum = "Bin Num must be a whole number.";
  // BinName: FORMAT "x(30)"
  if (typeof v.BinName === 'string' && v.BinName.length > 30) e.BinName = "Bin Name must be at most 30 characters.";
  return e;
}
