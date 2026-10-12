// Supplier: generated from the sports2000 schema. The supplier table contains a supplier's name, address and additional information pertaining to the supplier.
// Primary key: SupplierIDNum

export interface Supplier {
  /** Supplier ID. ABL integer, format "zzzzzzzzz9". */
  SupplierIDNum: number;
  /** Name. ABL character, format "x(30)". */
  Name?: string | null;
  /** Address. ABL character, format "x(35)". */
  Address?: string | null;
  /** Address2. ABL character, format "x(35)". */
  Address2?: string | null;
  /** City. ABL character, format "x(25)". */
  City?: string | null;
  /** State. ABL character, format "x(20)". */
  State?: string | null;
  /** ZipCode. ABL character, format "x(10)". */
  PostalCode?: string | null;
  /** Country. ABL character, format "x(20)". */
  Country?: string | null;
  /** Phone. ABL character, format "x(20)". */
  Phone?: string | null;
  /** Comments. ABL character, format "x(80)". */
  Comments?: string | null;
  /** Password. ABL character, format "x(8)". */
  Password: string;
  /** Login Date. ABL date, format "99/99/9999". */
  LoginDate?: string | null;
  /** Ship Amount. ABL integer, format ">>>>9". */
  ShipAmount?: number | null;
  /** Discount. ABL integer, format ">>9%". */
  Discount?: number | null;
  /** Optimistic concurrency token. Replaces EXCLUSIVE-LOCK from the ABL program. */
  version?: number;
}

export type SupplierKey = { SupplierIDNum: number };

export const supplierLabels: Record<string, string> = {
  SupplierIDNum: "Supplier ID",
  Name: "Name",
  Address: "Address",
  Address2: "Address2",
  City: "City",
  State: "State",
  PostalCode: "ZipCode",
  Country: "Country",
  Phone: "Phone",
  Comments: "Comments",
  Password: "Password",
  LoginDate: "Login Date",
  ShipAmount: "Ship Amount",
  Discount: "Discount",
};
