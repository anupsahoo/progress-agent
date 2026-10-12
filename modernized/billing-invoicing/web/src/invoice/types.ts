// Invoice: generated from the sports2000 schema. The invoice table contains transactions for the receivable module.
// Primary key: Invoicenum

export interface Invoice {
  /** Invoice Num. ABL integer, format "zzzzzzzzz9". */
  Invoicenum: number;
  /** Cust Num. ABL integer, format ">>>>9". */
  CustNum?: number | null;
  /** Invoice Date. ABL date, format "99/99/9999". */
  InvoiceDate?: string | null;
  /** Amount. ABL decimal, format "->>,>>9.99". */
  Amount?: number | null;
  /** Total Paid. ABL decimal, format "->>,>>9.99". */
  TotalPaid?: number | null;
  /** Adjustment. ABL decimal, format "->>,>>9.99". */
  Adjustment?: number | null;
  /** Order Num. ABL integer, format "zzzzzzzzz9". */
  OrderNum?: number | null;
  /** Ship Charge. ABL decimal, format "->>,>>9.99". */
  ShipCharge?: number | null;
  /** Optimistic concurrency token. Replaces EXCLUSIVE-LOCK from the ABL program. */
  version?: number;
}

export type InvoiceKey = { Invoicenum: number };

export const invoiceLabels: Record<string, string> = {
  Invoicenum: "Invoice Num",
  CustNum: "Cust Num",
  InvoiceDate: "Invoice Date",
  Amount: "Amount",
  TotalPaid: "Total Paid",
  Adjustment: "Adjustment",
  OrderNum: "Order Num",
  ShipCharge: "Ship Charge",
};
