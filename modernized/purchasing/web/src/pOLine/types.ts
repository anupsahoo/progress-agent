// POLine: generated from the sports2000 schema. The poline table contains the PO detail information including the item and quantity on the PO.
// Primary key: PONum, Linenum

export interface POLine {
  /** Line Num. ABL integer, format ">>9". */
  Linenum: number;
  /** Item Num. ABL integer, format "zzzzzzzzz9". */
  Itemnum?: number | null;
  /** Price. ABL decimal, format "->,>>>,>>9.99". */
  Price?: number | null;
  /** Qty. ABL integer, format "->>>>9". */
  Qty?: number | null;
  /** Discount. ABL integer, format ">>9%". */
  Discount?: number | null;
  /** Extended Price. ABL decimal, format "->>,>>9.99". */
  ExtendedPrice?: number | null;
  /** Order Num. ABL integer, format "zzzzzzzzz9". */
  PONum: number;
  /** PO Line Status. ABL character, format "x(20)". */
  POLineStatus?: string | null;
  /** Optimistic concurrency token. Replaces EXCLUSIVE-LOCK from the ABL program. */
  version?: number;
}

export type POLineKey = { PONum: number; Linenum: number };

export const pOLineLabels: Record<string, string> = {
  Linenum: "Line Num",
  Itemnum: "Item Num",
  Price: "Price",
  Qty: "Qty",
  Discount: "Discount",
  ExtendedPrice: "Extended Price",
  PONum: "Order Num",
  POLineStatus: "PO Line Status",
};
