// Order: generated from the sports2000 schema. The order table contains order header information.
// Primary key: Ordernum

export interface Order {
  /** Order Num. ABL integer, format "zzzzzzzzz9". */
  Ordernum: number;
  /** Cust Num. ABL integer, format ">>>>9". */
  CustNum?: number | null;
  /** Ordered. ABL date, format "99/99/99". */
  OrderDate?: string | null;
  /** Shipped. ABL date, format "99/99/9999". */
  ShipDate?: string | null;
  /** Promised. ABL date, format "99/99/99". */
  PromiseDate?: string | null;
  /** Carrier. ABL character, format "x(25)". */
  Carrier?: string | null;
  /** Instructions. ABL character, format "x(50)". */
  Instructions?: string | null;
  /** PO. ABL character, format "x(20)". */
  PO?: string | null;
  /** Terms. ABL character, format "x(20)". */
  Terms?: string | null;
  /** Sales Rep. ABL character, format "x(4)". */
  SalesRep?: string | null;
  /** Bill To ID. ABL integer, format "zzzzzzzzz9". */
  BillToID?: number | null;
  /** Ship To ID. ABL integer, format "zzzzzzzzz9". */
  ShipToID?: number | null;
  /** Order Status. ABL character, format "x(20)". */
  OrderStatus?: string | null;
  /** Warehouse Num. ABL integer, format "zzzzzzzzz9". */
  WarehouseNum?: number | null;
  /** Credit Card. ABL character, format "x(20)". */
  Creditcard?: string | null;
  /** Optimistic concurrency token. Replaces EXCLUSIVE-LOCK from the ABL program. */
  version?: number;
}

export type OrderKey = { Ordernum: number };

export const orderLabels: Record<string, string> = {
  Ordernum: "Order Num",
  CustNum: "Cust Num",
  OrderDate: "Ordered",
  ShipDate: "Shipped",
  PromiseDate: "Promised",
  Carrier: "Carrier",
  Instructions: "Instructions",
  PO: "PO",
  Terms: "Terms",
  SalesRep: "Sales Rep",
  BillToID: "Bill To ID",
  ShipToID: "Ship To ID",
  OrderStatus: "Order Status",
  WarehouseNum: "Warehouse Num",
  Creditcard: "Credit Card",
};
