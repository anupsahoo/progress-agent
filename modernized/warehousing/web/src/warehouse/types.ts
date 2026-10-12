// Warehouse: generated from the sports2000 schema. The warehouse table contains warehouse information including warehouse name and address.
// Primary key: WarehouseNum

export interface Warehouse {
  /** Warehouse Num. ABL integer, format "zzzzzzzzz9". */
  WarehouseNum: number;
  /** Warehouse Name. ABL character, format "x(30)". */
  WarehouseName?: string | null;
  /** Country. ABL character, format "x(20)". */
  Country?: string | null;
  /** Address. ABL character, format "x(35)". */
  Address?: string | null;
  /** Address2. ABL character, format "x(35)". */
  Address2?: string | null;
  /** City. ABL character, format "x(25)". */
  City?: string | null;
  /** State. ABL character, format "x(20)". */
  State?: string | null;
  /** Postal Code. ABL character, format "x(10)". */
  PostalCode?: string | null;
  /** Phone. ABL character, format "x(20)". */
  Phone?: string | null;
  /** Optimistic concurrency token. Replaces EXCLUSIVE-LOCK from the ABL program. */
  version?: number;
}

export type WarehouseKey = { WarehouseNum: number };

export const warehouseLabels: Record<string, string> = {
  WarehouseNum: "Warehouse Num",
  WarehouseName: "Warehouse Name",
  Country: "Country",
  Address: "Address",
  Address2: "Address2",
  City: "City",
  State: "State",
  PostalCode: "Postal Code",
  Phone: "Phone",
};
