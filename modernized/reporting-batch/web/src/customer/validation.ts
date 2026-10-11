import type { Customer } from './types';

// Field rules derived from the ABL FORMAT and VALEXP of each Customer field.
// Server-side checks in api/app/models/customer.py enforce the same rules.
export function validateCustomer(v: Partial<Customer>): Record<string, string> {
  const e: Record<string, string> = {};
  // CustNum: FORMAT ">>>>9" · VALEXP "custnum > 0"
  if (v.CustNum === undefined || v.CustNum === null) e.CustNum = "Cust Num is required.";
  if (typeof v.CustNum === 'number' && v.CustNum <= 0) e.CustNum = "Customer number must be greater than zero";
  if (typeof v.CustNum === 'number' && v.CustNum > 99999) e.CustNum = "Cust Num must be at most 99999.";
  if (typeof v.CustNum === 'number' && !Number.isInteger(v.CustNum)) e.CustNum = "Cust Num must be a whole number.";
  // Country: FORMAT "x(20)"
  if (typeof v.Country === 'string' && v.Country.length > 20) e.Country = "Country must be at most 20 characters.";
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
  if (typeof v.PostalCode === 'string' && v.PostalCode.length > 10) e.PostalCode = "Postal Code must be at most 10 characters.";
  // Contact: FORMAT "x(30)"
  if (typeof v.Contact === 'string' && v.Contact.length > 30) e.Contact = "Contact must be at most 30 characters.";
  // Phone: FORMAT "x(20)"
  if (typeof v.Phone === 'string' && v.Phone.length > 20) e.Phone = "Phone must be at most 20 characters.";
  // SalesRep: FORMAT "x(4)" · VALEXP "CAN-FIND(Salesrep OF Customer)"
  if (typeof v.SalesRep === 'string' && v.SalesRep.length > 4) e.SalesRep = "Sales Rep must be at most 4 characters.";
  // CreditLimit: FORMAT "->,>>>,>>9" · VALEXP "CreditLimit >= 0 AND CreditLimit <= 9999999"
  if (typeof v.CreditLimit === 'number' && v.CreditLimit < 0) e.CreditLimit = "Credit Limit must be >= 0 and <= 9,999,999";
  if (typeof v.CreditLimit === 'number' && v.CreditLimit > 9999999) e.CreditLimit = "Credit Limit must be at most 9999999.";
  if (typeof v.CreditLimit === 'number' && Math.round(v.CreditLimit * 100) !== v.CreditLimit * 100) e.CreditLimit = "Credit Limit allows 2 decimal places.";
  // Balance: FORMAT "->,>>>,>>9.99"
  if (typeof v.Balance === 'number' && v.Balance < -9999999.99) e.Balance = "Balance must be at least -9999999.99.";
  if (typeof v.Balance === 'number' && v.Balance > 9999999.99) e.Balance = "Balance must be at most 9999999.99.";
  if (typeof v.Balance === 'number' && Math.round(v.Balance * 100) !== v.Balance * 100) e.Balance = "Balance allows 2 decimal places.";
  // Terms: FORMAT "x(20)"
  if (typeof v.Terms === 'string' && v.Terms.length > 20) e.Terms = "Terms must be at most 20 characters.";
  // Discount: FORMAT ">>9%" · VALEXP "Discount >= 0"
  if (typeof v.Discount === 'number' && v.Discount < 0) e.Discount = "Discount must be greater or equal to 0";
  if (typeof v.Discount === 'number' && v.Discount > 999) e.Discount = "Discount must be at most 999.";
  if (typeof v.Discount === 'number' && !Number.isInteger(v.Discount)) e.Discount = "Discount must be a whole number.";
  // Comments: FORMAT "x(80)"
  if (typeof v.Comments === 'string' && v.Comments.length > 80) e.Comments = "Comments must be at most 80 characters.";
  // Fax: FORMAT "x(20)"
  if (typeof v.Fax === 'string' && v.Fax.length > 20) e.Fax = "Fax must be at most 20 characters.";
  // EmailAddress: FORMAT "x(50)"
  if (typeof v.EmailAddress === 'string' && v.EmailAddress.length > 50) e.EmailAddress = "Email must be at most 50 characters.";
  if (v.EmailAddress && !/^[^@\s]+@[^@\s]+$/.test(String(v.EmailAddress))) e.EmailAddress = "Email must be a valid e-mail address.";
  return e;
}
