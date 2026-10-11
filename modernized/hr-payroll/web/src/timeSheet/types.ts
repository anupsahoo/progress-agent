// TimeSheet: generated from the sports2000 schema. The timesheet table records time in and out, hours worked, and overtime.
// Primary key: EmpNum, DayRecorded

export interface TimeSheet {
  /** Emp No. ABL integer, format "zzzzzzzzz9". */
  EmpNum: number;
  /** Day Recorded. ABL date, format "99/99/9999". */
  DayRecorded: string;
  /** Type Recorded. ABL character, format "x(8)". */
  TypeRecorded?: string | null;
  /** AM Time In. ABL character, format "xx:xx". */
  AMTimeIn?: string | null;
  /** AM Time Out. ABL character, format "xx:xx". */
  AMTimeOut?: string | null;
  /** PM Time In. ABL character, format "xx:xx". */
  PMTimeIn?: string | null;
  /** PM Time Out. ABL character, format "xx:xx". */
  PMTimeOut?: string | null;
  /** Regular Hours. ABL decimal, format ">>9.<<". */
  RegularHours?: number | null;
  /** Overtime Hours. ABL decimal, format ">>9.<<". */
  OvertimeHours?: number | null;
  /** Optimistic concurrency token. Replaces EXCLUSIVE-LOCK from the ABL program. */
  version?: number;
}

export type TimeSheetKey = { EmpNum: number; DayRecorded: string };

export const timeSheetLabels: Record<string, string> = {
  EmpNum: "Emp No",
  DayRecorded: "Day Recorded",
  TypeRecorded: "Type Recorded",
  AMTimeIn: "AM Time In",
  AMTimeOut: "AM Time Out",
  PMTimeIn: "PM Time In",
  PMTimeOut: "PM Time Out",
  RegularHours: "Regular Hours",
  OvertimeHours: "Overtime Hours",
};
