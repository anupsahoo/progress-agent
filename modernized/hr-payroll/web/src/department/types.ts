// Department: generated from the sports2000 schema. The department contains a master listing of departments.
// Primary key: DeptCode

export interface Department {
  /** Dept Code. ABL character, format "x(3)". */
  DeptCode: string;
  /** Dept Name. ABL character, format "x(15)". */
  DeptName?: string | null;
  /** Optimistic concurrency token. Replaces EXCLUSIVE-LOCK from the ABL program. */
  version?: number;
}

export type DepartmentKey = { DeptCode: string };

export const departmentLabels: Record<string, string> = {
  DeptCode: "Dept Code",
  DeptName: "Dept Name",
};
