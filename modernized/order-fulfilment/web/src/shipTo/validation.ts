import type { ShipTo } from './types';

// Field rules derived from the ABL FORMAT and VALEXP of each ShipTo field.
// Server-side checks in api/app/models/ship_to.py enforce the same rules.
export function validateShipTo(v: Partial<ShipTo>): Record<string, string> {
  const e: Record<string, string> = {};
  // CustNum: FORMAT ">>>>9" · VALEXP "CAN-FIND(customer OF shipto)"
  if (v.CustNum === undefined || v.CustNum === null) e.CustNum = "Cust Num is required.";
  if (typeof v.CustNum === 'number' && v.CustNum < 0) e.CustNum = "Customer must exist";
  if (typeof v.CustNum === 'number' && v.CustNum > 99999) e.CustNum = "Cust Num must be at most 99999.";
  if (typeof v.CustNum === 'number' && !Number.isInteger(v.CustNum)) e.CustNum = "Cust Num must be a whole number.";
  // ShipToID: FORMAT "zzzzzzzzz9"
  if (v.ShipToID === undefined || v.ShipToID === null) e.ShipToID = "Ship To ID is required.";
  if (typeof v.ShipToID === 'number' && v.ShipToID < 0) e.ShipToID = "Ship To ID must be at least 0.";
  if (typeof v.ShipToID === 'number' && v.ShipToID > 9999999999) e.ShipToID = "Ship To ID must be at most 9999999999.";
  if (typeof v.ShipToID === 'number' && !Number.isInteger(v.ShipToID)) e.ShipToID = "Ship To ID must be a whole number.";
  // Contact: FORMAT "x(30)"
  if (typeof v.Contact === 'string' && v.Contact.length > 30) e.Contact = "Contact must be at most 30 characters.";
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
  // Comments: FORMAT "x(80)"
  if (typeof v.Comments === 'string' && v.Comments.length > 80) e.Comments = "Comments must be at most 80 characters.";
  // Name: FORMAT "x(30)"
  if (typeof v.Name === 'string' && v.Name.length > 30) e.Name = "Name must be at most 30 characters.";
  return e;
}
