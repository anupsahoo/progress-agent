import type { Item } from './types';

// Field rules derived from the ABL FORMAT and VALEXP of each Item field.
// Server-side checks in api/app/models/item.py enforce the same rules.
export function validateItem(v: Partial<Item>): Record<string, string> {
  const e: Record<string, string> = {};
  // Itemnum: FORMAT "zzzzzzzzz9" · VALEXP "itemnum >= 0"
  if (v.Itemnum === undefined || v.Itemnum === null) e.Itemnum = "Item Num is required.";
  if (typeof v.Itemnum === 'number' && v.Itemnum < 0) e.Itemnum = "Item number must be greater or equal to 0";
  if (typeof v.Itemnum === 'number' && v.Itemnum > 9999999999) e.Itemnum = "Item Num must be at most 9999999999.";
  if (typeof v.Itemnum === 'number' && !Number.isInteger(v.Itemnum)) e.Itemnum = "Item Num must be a whole number.";
  // ItemName: FORMAT "x(25)"
  if (typeof v.ItemName === 'string' && v.ItemName.length > 25) e.ItemName = "Item Name must be at most 25 characters.";
  // Price: FORMAT "->,>>>,>>9.99"
  if (typeof v.Price === 'number' && v.Price < -9999999.99) e.Price = "Price must be at least -9999999.99.";
  if (typeof v.Price === 'number' && v.Price > 9999999.99) e.Price = "Price must be at most 9999999.99.";
  if (typeof v.Price === 'number' && Math.round(v.Price * 100) !== v.Price * 100) e.Price = "Price allows 2 decimal places.";
  // Onhand: FORMAT "->>>>9"
  if (typeof v.Onhand === 'number' && v.Onhand < -99999) e.Onhand = "On Hand must be at least -99999.";
  if (typeof v.Onhand === 'number' && v.Onhand > 99999) e.Onhand = "On Hand must be at most 99999.";
  if (typeof v.Onhand === 'number' && !Number.isInteger(v.Onhand)) e.Onhand = "On Hand must be a whole number.";
  // Allocated: FORMAT "->>>>9"
  if (typeof v.Allocated === 'number' && v.Allocated < -99999) e.Allocated = "Allocated must be at least -99999.";
  if (typeof v.Allocated === 'number' && v.Allocated > 99999) e.Allocated = "Allocated must be at most 99999.";
  if (typeof v.Allocated === 'number' && !Number.isInteger(v.Allocated)) e.Allocated = "Allocated must be a whole number.";
  // ReOrder: FORMAT "->>>>9"
  if (typeof v.ReOrder === 'number' && v.ReOrder < -99999) e.ReOrder = "Re Order must be at least -99999.";
  if (typeof v.ReOrder === 'number' && v.ReOrder > 99999) e.ReOrder = "Re Order must be at most 99999.";
  if (typeof v.ReOrder === 'number' && !Number.isInteger(v.ReOrder)) e.ReOrder = "Re Order must be a whole number.";
  // OnOrder: FORMAT "->>>>9"
  if (typeof v.OnOrder === 'number' && v.OnOrder < -99999) e.OnOrder = "On Order must be at least -99999.";
  if (typeof v.OnOrder === 'number' && v.OnOrder > 99999) e.OnOrder = "On Order must be at most 99999.";
  if (typeof v.OnOrder === 'number' && !Number.isInteger(v.OnOrder)) e.OnOrder = "On Order must be a whole number.";
  // CatPage: FORMAT ">>9"
  if (typeof v.CatPage === 'number' && v.CatPage < 0) e.CatPage = "Cat Page must be at least 0.";
  if (typeof v.CatPage === 'number' && v.CatPage > 999) e.CatPage = "Cat Page must be at most 999.";
  if (typeof v.CatPage === 'number' && !Number.isInteger(v.CatPage)) e.CatPage = "Cat Page must be a whole number.";
  // CatDescription: FORMAT "X(200)"
  if (typeof v.CatDescription === 'string' && v.CatDescription.length > 200) e.CatDescription = "Cat-Description must be at most 200 characters.";
  // Category1: FORMAT "x(30)"
  if (typeof v.Category1 === 'string' && v.Category1.length > 30) e.Category1 = "Category1 must be at most 30 characters.";
  // Category2: FORMAT "x(30)"
  if (typeof v.Category2 === 'string' && v.Category2.length > 30) e.Category2 = "Category2 must be at most 30 characters.";
  // Special: FORMAT "x(8)"
  if (typeof v.Special === 'string' && v.Special.length > 8) e.Special = "Special must be at most 8 characters.";
  // Weight: FORMAT "->>,>>9.99"
  if (typeof v.Weight === 'number' && v.Weight < -99999.99) e.Weight = "Weight must be at least -99999.99.";
  if (typeof v.Weight === 'number' && v.Weight > 99999.99) e.Weight = "Weight must be at most 99999.99.";
  if (typeof v.Weight === 'number' && Math.round(v.Weight * 100) !== v.Weight * 100) e.Weight = "Weight allows 2 decimal places.";
  // Minqty: FORMAT "->>>>9"
  if (typeof v.Minqty === 'number' && v.Minqty < -99999) e.Minqty = "Min Qty must be at least -99999.";
  if (typeof v.Minqty === 'number' && v.Minqty > 99999) e.Minqty = "Min Qty must be at most 99999.";
  if (typeof v.Minqty === 'number' && !Number.isInteger(v.Minqty)) e.Minqty = "Min Qty must be a whole number.";
  return e;
}
