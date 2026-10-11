import type { Supplier } from './types';

// Field rules derived from the ABL FORMAT and VALEXP of each Supplier field.
// Server-side checks in api/app/models/supplier.py enforce the same rules.
export function validateSupplier(v: Partial<Supplier>): Record<string, string> {
  const e: Record<string, string> = {};
  // SupplierIDNum: FORMAT "zzzzzzzzz9" · VALEXP "supplier.SupplierIDnum > 0"
  if (v.SupplierIDNum === undefined || v.SupplierIDNum === null) e.SupplierIDNum = "Supplier ID is required.";
  if (typeof v.SupplierIDNum === 'number' && v.SupplierIDNum <= 0) e.SupplierIDNum = "Supplier number must be greater than zero";
  if (typeof v.SupplierIDNum === 'number' && v.SupplierIDNum > 9999999999) e.SupplierIDNum = "Supplier ID must be at most 9999999999.";
  if (typeof v.SupplierIDNum === 'number' && !Number.isInteger(v.SupplierIDNum)) e.SupplierIDNum = "Supplier ID must be a whole number.";
  // Name: FORMAT "x(30)"
  if (typeof v.Name === 'string' && v.Name.length > 30) e.Name = "Name must be at most 30 characters.";
  // Address: FORMAT "x(35)"
  if (typeof v.Address === 'string' && v.Address.length > 35) e.Address = "Address must be at most 35 characters.";
  // Address2: FORMAT "x(35)"
  if (typeof v.Address2 === 'string' && v.Address2.length > 35) e.Address2 = "Address2 must be at most 35 characters.";
  // City: FORMAT "x(25)"
  if (typeof v.City === 'string' && v.City.length > 25) e.City = "City must be at most 25 characters.";
  // State: FORMAT "x(20)"
  if (typeof v.State === 'string' && v.State.length > 20) e.State = "State must be at most 20 characters.";
  // PostalCode: FORMAT "x(10)"
  if (typeof v.PostalCode === 'string' && v.PostalCode.length > 10) e.PostalCode = "ZipCode must be at most 10 characters.";
  // Country: FORMAT "x(20)"
  if (typeof v.Country === 'string' && v.Country.length > 20) e.Country = "Country must be at most 20 characters.";
  // Phone: FORMAT "x(20)"
  if (typeof v.Phone === 'string' && v.Phone.length > 20) e.Phone = "Phone must be at most 20 characters.";
  // Comments: FORMAT "x(80)"
  if (typeof v.Comments === 'string' && v.Comments.length > 80) e.Comments = "Comments must be at most 80 characters.";
  // Password: FORMAT "x(8)"
  if (v.Password === undefined || v.Password === null || v.Password.trim() === '') e.Password = "Password is required.";
  if (typeof v.Password === 'string' && v.Password.length > 8) e.Password = "Password must be at most 8 characters.";
  // LoginDate: FORMAT "99/99/9999"
  if (v.LoginDate && !/^\d{4}-\d{2}-\d{2}$/.test(String(v.LoginDate))) e.LoginDate = "Login Date must be a date (YYYY-MM-DD).";
  // ShipAmount: FORMAT ">>>>9"
  if (typeof v.ShipAmount === 'number' && v.ShipAmount < 0) e.ShipAmount = "Ship Amount must be at least 0.";
  if (typeof v.ShipAmount === 'number' && v.ShipAmount > 99999) e.ShipAmount = "Ship Amount must be at most 99999.";
  if (typeof v.ShipAmount === 'number' && !Number.isInteger(v.ShipAmount)) e.ShipAmount = "Ship Amount must be a whole number.";
  // Discount: FORMAT ">>9%" · VALEXP "Discount >= 0"
  if (typeof v.Discount === 'number' && v.Discount < 0) e.Discount = "Discount must be greater or equal to 0";
  if (typeof v.Discount === 'number' && v.Discount > 999) e.Discount = "Discount must be at most 999.";
  if (typeof v.Discount === 'number' && !Number.isInteger(v.Discount)) e.Discount = "Discount must be a whole number.";
  return e;
}
