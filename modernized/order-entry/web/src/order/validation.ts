import type { Order } from './types';

// Field rules derived from the ABL FORMAT and VALEXP of each Order field.
// Server-side checks in api/app/models/order.py enforce the same rules.
export function validateOrder(v: Partial<Order>): Record<string, string> {
  const e: Record<string, string> = {};
  // Ordernum: FORMAT "zzzzzzzzz9" · VALEXP "ordernum > 0"
  if (v.Ordernum === undefined || v.Ordernum === null) e.Ordernum = "Order Num is required.";
  if (typeof v.Ordernum === 'number' && v.Ordernum <= 0) e.Ordernum = "Order number must be greater than zero";
  if (typeof v.Ordernum === 'number' && v.Ordernum > 9999999999) e.Ordernum = "Order Num must be at most 9999999999.";
  if (typeof v.Ordernum === 'number' && !Number.isInteger(v.Ordernum)) e.Ordernum = "Order Num must be a whole number.";
  // CustNum: FORMAT ">>>>9" · VALEXP "CAN-FIND(customer OF order)"
  if (typeof v.CustNum === 'number' && v.CustNum < 0) e.CustNum = "Customer must already exist.";
  if (typeof v.CustNum === 'number' && v.CustNum > 99999) e.CustNum = "Cust Num must be at most 99999.";
  if (typeof v.CustNum === 'number' && !Number.isInteger(v.CustNum)) e.CustNum = "Cust Num must be a whole number.";
  // OrderDate: FORMAT "99/99/99"
  if (v.OrderDate && !/^\d{4}-\d{2}-\d{2}$/.test(String(v.OrderDate))) e.OrderDate = "Ordered must be a date (YYYY-MM-DD).";
  // ShipDate: FORMAT "99/99/9999"
  if (v.ShipDate && !/^\d{4}-\d{2}-\d{2}$/.test(String(v.ShipDate))) e.ShipDate = "Shipped must be a date (YYYY-MM-DD).";
  // PromiseDate: FORMAT "99/99/99"
  if (v.PromiseDate && !/^\d{4}-\d{2}-\d{2}$/.test(String(v.PromiseDate))) e.PromiseDate = "Promised must be a date (YYYY-MM-DD).";
  // Carrier: FORMAT "x(25)"
  if (typeof v.Carrier === 'string' && v.Carrier.length > 25) e.Carrier = "Carrier must be at most 25 characters.";
  // Instructions: FORMAT "x(50)"
  if (typeof v.Instructions === 'string' && v.Instructions.length > 50) e.Instructions = "Instructions must be at most 50 characters.";
  // PO: FORMAT "x(20)"
  if (typeof v.PO === 'string' && v.PO.length > 20) e.PO = "PO must be at most 20 characters.";
  // Terms: FORMAT "x(20)"
  if (typeof v.Terms === 'string' && v.Terms.length > 20) e.Terms = "Terms must be at most 20 characters.";
  // SalesRep: FORMAT "x(4)"
  if (typeof v.SalesRep === 'string' && v.SalesRep.length > 4) e.SalesRep = "Sales Rep must be at most 4 characters.";
  // BillToID: FORMAT "zzzzzzzzz9"
  if (typeof v.BillToID === 'number' && v.BillToID < 0) e.BillToID = "Bill To ID must be at least 0.";
  if (typeof v.BillToID === 'number' && v.BillToID > 9999999999) e.BillToID = "Bill To ID must be at most 9999999999.";
  if (typeof v.BillToID === 'number' && !Number.isInteger(v.BillToID)) e.BillToID = "Bill To ID must be a whole number.";
  // ShipToID: FORMAT "zzzzzzzzz9"
  if (typeof v.ShipToID === 'number' && v.ShipToID < 0) e.ShipToID = "Ship To ID must be at least 0.";
  if (typeof v.ShipToID === 'number' && v.ShipToID > 9999999999) e.ShipToID = "Ship To ID must be at most 9999999999.";
  if (typeof v.ShipToID === 'number' && !Number.isInteger(v.ShipToID)) e.ShipToID = "Ship To ID must be a whole number.";
  // OrderStatus: FORMAT "x(20)"
  if (typeof v.OrderStatus === 'string' && v.OrderStatus.length > 20) e.OrderStatus = "Order Status must be at most 20 characters.";
  // WarehouseNum: FORMAT "zzzzzzzzz9" · VALEXP "(warehousenum = 0) or can-find(warehouse of order)"
  if (typeof v.WarehouseNum === 'number' && v.WarehouseNum < 0) e.WarehouseNum = "Entrer a number greater than zero";
  if (typeof v.WarehouseNum === 'number' && v.WarehouseNum > 9999999999) e.WarehouseNum = "Warehouse Num must be at most 9999999999.";
  if (typeof v.WarehouseNum === 'number' && !Number.isInteger(v.WarehouseNum)) e.WarehouseNum = "Warehouse Num must be a whole number.";
  // Creditcard: FORMAT "x(20)"
  if (typeof v.Creditcard === 'string' && v.Creditcard.length > 20) e.Creditcard = "Credit Card must be at most 20 characters.";
  return e;
}
