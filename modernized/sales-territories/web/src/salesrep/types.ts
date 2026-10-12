// Salesrep: generated from the sports2000 schema. The salesrep table contains sales representative information
// Primary key: SalesRep

export interface Salesrep {
  /** Sales Rep. ABL character, format "x(4)". */
  SalesRep: string;
  /** Rep Name. ABL character, format "x(30)". */
  RepName?: string | null;
  /** Region. ABL character, format "x(8)". */
  Region?: string | null;
  /** Month Quota. ABL integer EXTENT 12, format "->,>>>,>>9". */
  MonthQuota?: number[] | null;
  /** Optimistic concurrency token. Replaces EXCLUSIVE-LOCK from the ABL program. */
  version?: number;
}

export type SalesrepKey = { SalesRep: string };

export const salesrepLabels: Record<string, string> = {
  SalesRep: "Sales Rep",
  RepName: "Rep Name",
  Region: "Region",
  MonthQuota: "Month Quota",
};
