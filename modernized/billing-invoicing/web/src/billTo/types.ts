// BillTo: generated from the sports2000 schema. The billto table contains bill to address information for an order.
// Primary key: CustNum, BillToID

export interface BillTo {
  /** Cust Num. ABL integer, format ">>>>9". */
  CustNum: number;
  /** BillToID. ABL integer, format "zzzzzzzzz9". */
  BillToID: number;
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
  /** Postal Code. ABL character, format "x(10)". */
  PostalCode?: string | null;
  /** Contact. ABL character, format "x(30)". */
  Contact?: string | null;
  /** Phone. ABL character, format "x(20)". */
  Phone?: string | null;
  /** Optimistic concurrency token. Replaces EXCLUSIVE-LOCK from the ABL program. */
  version?: number;
}

export type BillToKey = { CustNum: number; BillToID: number };

export const billToLabels: Record<string, string> = {
  CustNum: "Cust Num",
  BillToID: "BillToID",
  Name: "Name",
  Address: "Address",
  Address2: "Address2",
  City: "City",
  State: "State",
  PostalCode: "Postal Code",
  Contact: "Contact",
  Phone: "Phone",
};
