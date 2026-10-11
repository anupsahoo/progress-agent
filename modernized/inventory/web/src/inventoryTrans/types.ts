// InventoryTrans: generated from the sports2000 schema. The inventorytrans table contains information about the movement of inventory.
// Primary key: InvTransNum

export interface InventoryTrans {
  /** Inventory Trans Num. ABL integer, format "zzzzzzzzz9". */
  InvTransNum: number;
  /** Warehouse Num. ABL integer, format "zzzzzzzzz9". */
  WarehouseNum?: number | null;
  /** Bin Num. ABL integer, format "zzzzzzzzz9". */
  BinNum?: number | null;
  /** Qty. ABL integer, format "->>>>9". */
  Qty?: number | null;
  /** Item Num. ABL integer, format "zzzzzzzzz9". */
  Itemnum?: number | null;
  /** Trans Date. ABL date, format "99/99/9999". */
  TransDate?: string | null;
  /** Type. ABL character, format "X(12)". */
  InvType?: string | null;
  /** PO Num. ABL integer, format "zzzzzzzzz9". */
  PONum?: number | null;
  /** Order Num. ABL integer, format "zzzzzzzzz9". */
  Ordernum?: number | null;
  /** Trans Time. ABL character, format "X(5)". */
  Transtime?: string | null;
  /** Optimistic concurrency token. Replaces EXCLUSIVE-LOCK from the ABL program. */
  version?: number;
}

export type InventoryTransKey = { InvTransNum: number };

export const inventoryTransLabels: Record<string, string> = {
  InvTransNum: "Inventory Trans Num",
  WarehouseNum: "Warehouse Num",
  BinNum: "Bin Num",
  Qty: "Qty",
  Itemnum: "Item Num",
  TransDate: "Trans Date",
  InvType: "Type",
  PONum: "PO Num",
  Ordernum: "Order Num",
  Transtime: "Trans Time",
};
