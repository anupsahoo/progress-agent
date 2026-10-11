// ShipTo: generated from the sports2000 schema. The shipto table contains the ship to address information for an order.
// Primary key: CustNum, ShipToID

export interface ShipTo {
  /** Cust Num. ABL integer, format ">>>>9". */
  CustNum: number;
  /** Ship To ID. ABL integer, format "zzzzzzzzz9". */
  ShipToID: number;
  /** Contact. ABL character, format "x(30)". */
  Contact?: string | null;
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
  /** Comments. ABL character, format "x(80)". */
  Comments?: string | null;
  /** Name. ABL character, format "x(30)". */
  Name?: string | null;
  /** Optimistic concurrency token. Replaces EXCLUSIVE-LOCK from the ABL program. */
  version?: number;
}

export type ShipToKey = { CustNum: number; ShipToID: number };

export const shipToLabels: Record<string, string> = {
  CustNum: "Cust Num",
  ShipToID: "Ship To ID",
  Contact: "Contact",
  Address: "Address",
  Address2: "Address2",
  City: "City",
  State: "State",
  PostalCode: "Postal Code",
  Phone: "Phone",
  Comments: "Comments",
  Name: "Name",
};
