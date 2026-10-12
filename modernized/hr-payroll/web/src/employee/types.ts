// Employee: generated from the sports2000 schema. The employee table stores employee information including name and address
// Primary key: EmpNum

export interface Employee {
  /** Emp No. ABL integer, format "zzzzzzzzz9". */
  EmpNum: number;
  /** Last Name. ABL character, format "x(25)". */
  LastName?: string | null;
  /** First Name. ABL character, format "x(15)". */
  FirstName?: string | null;
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
  /** Home Phone. ABL character, format "x(20)". */
  HomePhone?: string | null;
  /** Work Phone. ABL character, format "x(20)". */
  WorkPhone?: string | null;
  /** Dept Code. ABL character, format "x(3)". */
  DeptCode?: string | null;
  /** Position. ABL character, format "x(20)". */
  Position?: string | null;
  /** Birthdate. ABL date, format "99/99/9999". */
  Birthdate?: string | null;
  /** Start Date. ABL date, format "99/99/9999". */
  StartDate?: string | null;
  /** Vacation Days Left. ABL integer, format ">>9". */
  VacationDaysLeft?: number | null;
  /** Sick Days Left. ABL integer, format ">>9". */
  SickDaysLeft?: number | null;
  /** Optimistic concurrency token. Replaces EXCLUSIVE-LOCK from the ABL program. */
  version?: number;
}

export type EmployeeKey = { EmpNum: number };

export const employeeLabels: Record<string, string> = {
  EmpNum: "Emp No",
  LastName: "Last Name",
  FirstName: "First Name",
  Address: "Address",
  Address2: "Address2",
  City: "City",
  State: "State",
  PostalCode: "Postal Code",
  HomePhone: "Home Phone",
  WorkPhone: "Work Phone",
  DeptCode: "Dept Code",
  Position: "Position",
  Birthdate: "Birthdate",
  StartDate: "Start Date",
  VacationDaysLeft: "Vacation Days Left",
  SickDaysLeft: "Sick Days Left",
};
