// Vacation: generated from the sports2000 schema. The vacation table keeps track of employee vacation time.
// Primary key: EmpNum, StartDate

export interface Vacation {
  /** Emp No. ABL integer, format "zzzzzzzzz9". */
  EmpNum: number;
  /** Start Date. ABL date, format "99/99/9999". */
  StartDate: string;
  /** End Date. ABL date, format "99/99/9999". */
  EndDate?: string | null;
  /** Optimistic concurrency token. Replaces EXCLUSIVE-LOCK from the ABL program. */
  version?: number;
}

export type VacationKey = { EmpNum: number; StartDate: string };

export const vacationLabels: Record<string, string> = {
  EmpNum: "Emp No",
  StartDate: "Start Date",
  EndDate: "End Date",
};
