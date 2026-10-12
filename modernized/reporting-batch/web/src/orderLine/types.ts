// OrderLine: generated from the sports2000 schema. The orderline table contains order detail information including item number and quantity ordered.
// Primary key: Ordernum, Linenum

export interface OrderLine {
  /** Order Num. ABL integer, format "zzzzzzzzz9". */
  Ordernum: number;
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
  /** Extended Price. ABL decimal, format "->>>,>>9.99". */
  ExtendedPrice?: number | null;
  /** Order Line Status. ABL character, format "x(20)". */
  OrderLineStatus?: string | null;
  /** Optimistic concurrency token. Replaces EXCLUSIVE-LOCK from the ABL program. */
  version?: number;
}

export type OrderLineKey = { Ordernum: number; Linenum: number };

export const orderLineLabels: Record<string, string> = {
  Ordernum: "Order Num",
  Linenum: "Line Num",
  Itemnum: "Item Num",
  Price: "Price",
  Qty: "Qty",
  Discount: "Discount",
  ExtendedPrice: "Extended Price",
  OrderLineStatus: "Order Line Status",
};
