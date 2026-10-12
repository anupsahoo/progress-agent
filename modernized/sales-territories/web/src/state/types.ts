// State: generated from the sports2000 schema. The state table contans state abbreviations and corresponding sales regions
// Primary key: State

export interface State {
  /** State. ABL character, format "x(20)". */
  State: string;
  /** State Name. ABL character, format "x(20)". */
  StateName?: string | null;
  /** Region. ABL character, format "x(8)". */
  Region?: string | null;
  /** Optimistic concurrency token. Replaces EXCLUSIVE-LOCK from the ABL program. */
  version?: number;
}

export type StateKey = { State: string };

export const stateLabels: Record<string, string> = {
  State: "State",
  StateName: "State Name",
  Region: "Region",
};
