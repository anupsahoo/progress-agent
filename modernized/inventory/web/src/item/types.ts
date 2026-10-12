// Item: generated from the sports2000 schema. The item table provides a quick reference for items in stock and quantity on-hand.
// Primary key: Itemnum

export interface Item {
  /** Item Num. ABL integer, format "zzzzzzzzz9". */
  Itemnum: number;
  /** Item Name. ABL character, format "x(25)". */
  ItemName?: string | null;
  /** Price. ABL decimal, format "->,>>>,>>9.99". */
  Price?: number | null;
  /** On Hand. ABL integer, format "->>>>9". */
  Onhand?: number | null;
  /** Allocated. ABL integer, format "->>>>9". */
  Allocated?: number | null;
  /** Re Order. ABL integer, format "->>>>9". */
  ReOrder?: number | null;
  /** On Order. ABL integer, format "->>>>9". */
  OnOrder?: number | null;
  /** Cat Page. ABL integer, format ">>9". */
  CatPage?: number | null;
  /** Cat-Description. ABL character, format "X(200)". */
  CatDescription?: string | null;
  /** Category1. ABL character, format "x(30)". */
  Category1?: string | null;
  /** Category2. ABL character, format "x(30)". */
  Category2?: string | null;
  /** Special. ABL character, format "x(8)". */
  Special?: string | null;
  /** Weight. ABL decimal, format "->>,>>9.99". */
  Weight?: number | null;
  /** Min Qty. ABL integer, format "->>>>9". */
  Minqty?: number | null;
  /** Optimistic concurrency token. Replaces EXCLUSIVE-LOCK from the ABL program. */
  version?: number;
}

export type ItemKey = { Itemnum: number };

export const itemLabels: Record<string, string> = {
  Itemnum: "Item Num",
  ItemName: "Item Name",
  Price: "Price",
  Onhand: "On Hand",
  Allocated: "Allocated",
  ReOrder: "Re Order",
  OnOrder: "On Order",
  CatPage: "Cat Page",
  CatDescription: "Cat-Description",
  Category1: "Category1",
  Category2: "Category2",
  Special: "Special",
  Weight: "Weight",
  Minqty: "Min Qty",
};
