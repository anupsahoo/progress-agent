// Bin: generated from the sports2000 schema. The bin table is used to represent the bins in each warehouse that contain items.
// Primary key: BinNum

export interface Bin {
  /** Warehouse Num. ABL integer, format "zzzzzzzzz9". */
  WarehouseNum?: number | null;
  /** Item Num. ABL integer, format "zzzzzzzzz9". */
  Itemnum?: number | null;
  /** Qty. ABL integer, format "->>>>9". */
  Qty?: number | null;
  /** Bin Num. ABL integer, format "zzzzzzzzz9". */
  BinNum: number;
  /** Bin Name. ABL character, format "x(30)". */
  BinName?: string | null;
  /** Optimistic concurrency token. Replaces EXCLUSIVE-LOCK from the ABL program. */
  version?: number;
}

export type BinKey = { BinNum: number };

export const binLabels: Record<string, string> = {
  WarehouseNum: "Warehouse Num",
  Itemnum: "Item Num",
  Qty: "Qty",
  BinNum: "Bin Num",
  BinName: "Bin Name",
};
