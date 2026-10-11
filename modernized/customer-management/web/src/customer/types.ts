// Customer: generated from the sports2000 schema. The customer table contains customer information including balance and address.
// Primary key: CustNum

export interface Customer {
  /** Cust Num. ABL integer, format ">>>>9". */
  CustNum: number;
  /** Country. ABL character, format "x(20)". */
  Country?: string | null;
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
  /** Sales Rep. ABL character, format "x(4)". */
  SalesRep?: string | null;
  /** Credit Limit. ABL decimal, format "->,>>>,>>9". */
  CreditLimit?: number | null;
  /** Balance. ABL decimal, format "->,>>>,>>9.99". */
  Balance?: number | null;
  /** Terms. ABL character, format "x(20)". */
  Terms?: string | null;
  /** Discount. ABL integer, format ">>9%". */
  Discount?: number | null;
  /** Comments. ABL character, format "x(80)". */
  Comments?: string | null;
  /** Fax. ABL character, format "x(20)". */
  Fax?: string | null;
  /** Email. ABL character, format "x(50)". */
  EmailAddress?: string | null;
  /** Optimistic concurrency token. Replaces EXCLUSIVE-LOCK from the ABL program. */
  version?: number;
}

export type CustomerKey = { CustNum: number };

export const customerLabels: Record<string, string> = {
  CustNum: "Cust Num",
  Country: "Country",
  Name: "Name",
  Address: "Address",
  Address2: "Address2",
  City: "City",
  State: "State",
  PostalCode: "Postal Code",
  Contact: "Contact",
  Phone: "Phone",
  SalesRep: "Sales Rep",
  CreditLimit: "Credit Limit",
  Balance: "Balance",
  Terms: "Terms",
  Discount: "Discount",
  Comments: "Comments",
  Fax: "Fax",
  EmailAddress: "Email",
};
