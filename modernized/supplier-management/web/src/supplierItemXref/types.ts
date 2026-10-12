// SupplierItemXref: generated from the sports2000 schema. The supplieritemxref lists all of the items that are supplied by a particlar supplier.
// Primary key: SupplierIDNum, Itemnum

export interface SupplierItemXref {
  /** Supplier ID. ABL integer, format "zzzzzzzzz9". */
  SupplierIDNum: number;
  /** Item #. ABL integer, format "zzzzzzzzz9". */
  Itemnum: number;
  /** Optimistic concurrency token. Replaces EXCLUSIVE-LOCK from the ABL program. */
  version?: number;
}

export type SupplierItemXrefKey = { SupplierIDNum: number; Itemnum: number };

export const supplierItemXrefLabels: Record<string, string> = {
  SupplierIDNum: "Supplier ID",
  Itemnum: "Item #",
};
