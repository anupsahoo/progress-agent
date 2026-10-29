import type { Warehouse } from './types';

// Field rules derived from the ABL FORMAT and VALEXP of each Warehouse field.
// Server-side checks in api/app/models/warehouse.py enforce the same rules.
export function validateWarehouse(v: Partial<Warehouse>): Record<string, string> {
  const e: Record<string, string> = {};
  // WarehouseNum: FORMAT "zzzzzzzzz9" · VALEXP "warehousenum > 0"
  if (v.WarehouseNum === undefined || v.WarehouseNum === null) e.WarehouseNum = "Warehouse Num is required.";
  if (typeof v.WarehouseNum === 'number' && v.WarehouseNum <= 0) e.WarehouseNum = "Entrer a number greater than zero";
  if (typeof v.WarehouseNum === 'number' && v.WarehouseNum > 9999999999) e.WarehouseNum = "Warehouse Num must be at most 9999999999.";
  if (typeof v.WarehouseNum === 'number' && !Number.isInteger(v.WarehouseNum)) e.WarehouseNum = "Warehouse Num must be a whole number.";
  // WarehouseName: FORMAT "x(30)"
  if (typeof v.WarehouseName === 'string' && v.WarehouseName.length > 30) e.WarehouseName = "Warehouse Name must be at most 30 characters.";
  // Country: FORMAT "x(20)"
  if (typeof v.Country === 'string' && v.Country.length > 20) e.Country = "Country must be at most 20 characters.";
  // Address: FORMAT "x(35)"
  if (typeof v.Address === 'string' && v.Address.length > 35) e.Address = "Address must be at most 35 characters.";
  // Address2: FORMAT "x(35)"
  if (typeof v.Address2 === 'string' && v.Address2.length > 35) e.Address2 = "Address2 must be at most 35 characters.";
  // City: FORMAT "x(25)"
  if (typeof v.City === 'string' && v.City.length > 25) e.City = "City must be at most 25 characters.";
  // State: FORMAT "x(20)"
  if (typeof v.State === 'string' && v.State.length > 20) e.State = "State must be at most 20 characters.";
  // PostalCode: FORMAT "x(10)"
  if (typeof v.PostalCode === 'string' && v.PostalCode.length > 10) e.PostalCode = "Postal Code must be at most 10 characters.";
  // Phone: FORMAT "x(20)"
  if (typeof v.Phone === 'string' && v.Phone.length > 20) e.Phone = "Phone must be at most 20 characters.";
  return e;
}
