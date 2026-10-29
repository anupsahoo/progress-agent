// RefCall: generated from the sports2000 schema. The refcall table contains information about a sale.
// Primary key: CallNum

export interface RefCall {
  /** Call Num. ABL character, format "x(6)". */
  CallNum: string;
  /** Cust Num. ABL integer, format ">>>>9". */
  CustNum?: number | null;
  /** Call Date. ABL date, format "99/99/9999". */
  CallDate?: string | null;
  /** Sales Rep. ABL character, format "x(4)". */
  SalesRep?: string | null;
  /** Parent. ABL character, format "x(6)". */
  Parent?: string | null;
  /** Txt. ABL character, format "x(300)". */
  Txt?: string | null;
  /** Optimistic concurrency token. Replaces EXCLUSIVE-LOCK from the ABL program. */
  version?: number;
}

export type RefCallKey = { CallNum: string };

export const refCallLabels: Record<string, string> = {
  CallNum: "Call Num",
  CustNum: "Cust Num",
  CallDate: "Call Date",
  SalesRep: "Sales Rep",
  Parent: "Parent",
  Txt: "Txt",
};
